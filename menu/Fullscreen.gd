extends CheckButton

func _on_Fullscreen_visibility_changed():
	pressed = !Settings.cfg.display.windowed

func _on_Fullscreen_toggled(button_pressed):
	Settings.cfg.display.windowed = !button_pressed
	Settings.applySettings()
