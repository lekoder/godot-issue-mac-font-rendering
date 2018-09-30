extends Sprite

var lastPosition = Vector2(0,0)
var fade = 1000

var detectMouse = 0
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")
	lastPosition = get_viewport().get_mouse_position()
	
func _on_joy_connection_changed(device_id, connected):
	if connected:
		Settings.controlScheme = Settings.control.gamepad
	else:
		Settings.controlScheme = Settings.control.keyMouse
	
func _process(delta):
	var fadeTime = get_parent().fadeTime
	
	if fadeTime > 0:
		var viewport = get_viewport()
		position = viewport.get_mouse_position()
		if position == lastPosition:
			fade += delta
		else:
			fade = 0
			lastPosition = position
			Settings.controlScheme = Settings.control.keyMouse
		modulate = Color(1,1,1,1-clamp(fade/fadeTime,0,1))
	else:
		modulate = Color(1,1,1,0)
		fade = 0

	for joy in [
		Input.get_joy_axis(0,JOY_ANALOG_RX), Input.get_joy_axis(0,JOY_ANALOG_RY),
		Input.get_joy_axis(0,JOY_ANALOG_LX), Input.get_joy_axis(0,JOY_ANALOG_LY),
		Input.get_joy_axis(0,JOY_ANALOG_L2), Input.get_joy_axis(0,JOY_ANALOG_R2),
	]:
		if abs(joy) > 0.2:
			Settings.controlScheme = Settings.control.gamepad
		