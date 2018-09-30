extends OptionButton

func _ready():
	fillInMonitors()
	Settings.connect("settingsChanged", self, "fillInMonitors")
	
func fillInMonitors():
	clear()
	for screen in range(OS.get_screen_count()):
		var format = (tr("SETTINGS_MONITOR")+" %d")
		add_item(format % (screen+1))		
	selected = Settings.cfg.display.screen

func _on_Monitor_item_selected(ID):
	Settings.cfg.display.screen = ID
	Settings.applySettings()

func _on_Monitor_visibility_changed():
	fillInMonitors()
