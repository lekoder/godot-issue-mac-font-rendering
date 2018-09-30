extends Tabs

export var text = ""

func _ready():
	text = name
	retranslate()
	Settings.connect("settingsChanged", self, "retranslate")
	
func retranslate():
	name = tr(text)
