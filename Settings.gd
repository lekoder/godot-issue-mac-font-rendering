extends Node

enum control {
	gamepad,
	keyMouse
}

var cfg = {
	"display": {
		"windowed": true,
		"screen": 0,
		"windowSize": OS.window_size,
		"details": 1.0,
	},
	"locale": {
		"language": OS.get_locale()
	},
	"audio": {
		"master": 0,
		"sfx": 0,
		"music": 0
	},
	"ui": {
		"scale": 0
	}
}

signal settingsChanged

var minWindow = Vector2(640,512)
var minScreen = Vector2(1280,768)
var maxScreenScale = Vector2(1920, 1080)
var screenScaleMin = Vector2(1280,768)

var controlScheme = control.keyMouse

var settingsPath = "user://settings.cfg"
var settingsFile = ConfigFile.new()

func saveToFile():
	for section in cfg:
		for key in cfg[section]:
			settingsFile.set_value(section,key,cfg[section][key])
	settingsFile.save(settingsPath)

func loadFromFile():
	var error = settingsFile.load(settingsPath)
	if error != OK:
		print("Error loading settings %s" % error)
		return
	for section in cfg:
		for key in cfg[section]:
			cfg[section][key] = settingsFile.get_value(section,key,cfg[section][key])
	
func muteOverride(db):
	if db<=-40:
		return -100
	else:
		return db	
		
func scaleWindow(size):
	OS.set_window_size(size)
	

func applySettings():
	print("applying ",cfg)
	if cfg.display.windowed:
		OS.window_fullscreen = false
		#OS.set_window_always_on_top(false)
		OS.window_borderless = false
		OS.window_resizable = true
		scaleWindow(cfg.display.windowSize)
	else:
		OS.window_fullscreen = false # workaround for switching screens
		var screen = cfg.display.screen
		if screen >= OS.get_screen_count():
			screen = 0
		var size = OS.get_screen_size(screen)
		var pos = OS.get_screen_position(screen)
		print("Moving to %s, size %s, screen %s" % [pos, size, screen])
		OS.window_borderless = true
		# OS.set_window_always_on_top(false)
		OS.set_window_position(pos)
		scaleWindow(size)
		OS.window_resizable = false
		OS.window_fullscreen = true
		
		
	TranslationServer.set_locale(cfg.locale.language)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), muteOverride(cfg.audio.master))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), muteOverride(cfg.audio.sfx))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), muteOverride(cfg.audio.music))
	var r = cfg.ui.scale
	maxScreenScale = minScreen * r + OS.window_size * (1-r)
	print("UI scale : %s" % maxScreenScale)
	emit_signal("settingsChanged")
	applyInterfaceScale()

func applyInterfaceScale():
	var newSize = OS.window_size
	if newSize.x > 0 and newSize.y > 0:
		var aspect = clamp(OS.window_size.x/OS.window_size.y, 0.25, 4)
		if newSize.x < minScreen.x:
			newSize.x = minScreen.x
			newSize.y = newSize.x / aspect
		if newSize.x > maxScreenScale.x:
			newSize.x = maxScreenScale.x
			newSize.y = newSize.x / aspect
			
		if newSize.y < minScreen.y:
			newSize.y = minScreen.y
			newSize.x = newSize.y * aspect
		if newSize.y > maxScreenScale.y:
			newSize.y = maxScreenScale.y
			newSize.x = newSize.y * aspect
	
		cfg.display.windowSize = OS.window_size
		var root = get_tree().get_root()
		print("overriding to ", newSize)
		root.set_size_override(true, newSize)

func _on_resize():
	applyInterfaceScale()
	pass
	
export var shittyWorkaroundCounter = 0.005
func _process(delta):
	if shittyWorkaroundCounter > 0:
		shittyWorkaroundCounter -= delta
		if shittyWorkaroundCounter <= 0:
			OS.window_per_pixel_transparency_enabled = false
			applySettings()
		

func _ready():
	loadFromFile()
	saveToFile()
	get_tree().get_root().connect("size_changed", self, "_on_resize")
	applySettings()
	
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		for setting in ProjectSettings.get_property_list():
			if setting.name.substr(0,6) == "input/":
				Input.action_release(setting.name.substr(6, setting.name.length()-6))
