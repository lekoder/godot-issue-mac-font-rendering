extends HSlider

export var bus = "master"
var player
func _ready():
	value = Settings.cfg.audio[bus]
	if has_node("Audio"):
		player = $Audio
	connect("visibility_changed",self,"_on_visibility_changed")
	connect("value_changed", self, "_on_value_changed")

func _on_value_changed(value):
	Settings.cfg.audio[bus] = value
	if player:
		if !player.playing:
			player.play()
	Settings.applySettings()


func _on_visibility_changed():
	value = Settings.cfg.audio[bus]

