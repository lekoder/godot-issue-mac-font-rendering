extends Container

onready var game = load("res://Game.tscn")
onready var enceladus = load("res://enceladus/Enceladus.tscn")

func startGame():
	match(CurrentGame.firstStage):
		true:
			get_tree().change_scene_to(game)
		false:
			get_tree().change_scene_to(enceladus)

func startNewGame():
	CurrentGame.newGame()
	CurrentGame.saveToFile()
	startGame()

func _on_NewGame_pressed():
	if CurrentGame.hasSaveGame():
		$NoMargins/Popups/Override.popup_centered()
		$NoMargins/Popups/Override.get_cancel().grab_focus()
	else:
		startNewGame()

func _on_Continue_pressed():
	CurrentGame.loadFromFile()
	startGame()

func _on_Settings_pressed():
	$NoMargins/SettingsLayer.popup_centered()
	
func _on_Exit_pressed():
	$NoMargins/Popups/Exit.popup_centered()
	$NoMargins/Popups/Exit.get_cancel().grab_focus()
	
func _on_Exit_confirmed():
	get_tree().quit()


func _on_Override_confirmed():
	startNewGame()

	