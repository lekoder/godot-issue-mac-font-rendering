extends Popup

func _ready():
	get_tree().get_root().connect("size_changed", self, "_on_resize")
	
func _on_resize():
	if visible:
		popup_centered()

func _on_Save_pressed():
	Settings.saveToFile()
	hide()

func _on_Cancel_pressed():
	Settings.loadFromFile()
	Settings.applySettings()
	hide()
	

