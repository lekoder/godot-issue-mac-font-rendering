extends TabContainer


func focus():
	$SETTINGS_GAME/VBoxContainer/Language.grab_focus()
	print("focused (hopefully)")