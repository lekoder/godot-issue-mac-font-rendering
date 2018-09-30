extends OptionButton

var langs
func _ready():
	fillInLanguages()
	
func fillInLanguages():
	clear()
	var locale = Settings.cfg.locale.language
	langs = ProjectSettings.get_setting("locale/locale_filter")[1]
	var i=0
	for lang in langs:
		TranslationServer.set_locale(lang)
		var name = tr("LANG_OWN_NAME")
		add_item(name)
		if lang == locale:
			selected = i
		i += 1
	TranslationServer.set_locale(locale)

func _on_Language_item_selected(id):
	var to = langs[id]
	print("switching locale to ",to)
	Settings.cfg.locale.language = to
	Settings.applySettings()


func _on_Language_visibility_changed():
	fillInLanguages()
