extends HSlider

export var bus = "master"
var player
func _ready():
	value = Settings.cfg.display.details
	connect("visibility_changed",self,"_on_visibility_changed")
	connect("value_changed", self, "_on_value_changed")

func _on_value_changed(value):
	Settings.cfg.display.details = value
	Settings.applySettings()


func _on_visibility_changed():
	value = Settings.cfg.display.details
