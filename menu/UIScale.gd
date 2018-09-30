extends HSlider

var player
func _ready():
	value = Settings.cfg.ui.scale
	connect("visibility_changed",self,"_on_visibility_changed")
	connect("value_changed", self, "_on_value_changed")

func _on_value_changed(value):
	print("Scale to %f",value)
	Settings.cfg.ui.scale = value
	if !Input.is_mouse_button_pressed(BUTTON_LEFT):
		Settings.applySettings()
		grab_focus()

func _on_visibility_changed():
	value = Settings.cfg.ui.scale

func _on_UIScale_gui_input(event):
	if event is InputEventMouseButton and !event.pressed:
		Settings.applySettings()
		grab_focus()