extends ConfirmationDialog

func _ready():
	get_tree().get_root().connect("size_changed", self, "_on_resize")

func _on_resize():
	if visible:
		popup_centered()
