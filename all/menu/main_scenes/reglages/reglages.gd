extends ControlFocus

@onready var language: ButtonReglage = %Language



func _on_reset_clicked() -> void:
	Data.save_manager = SaveManager.reset()
	Data.save_manager.save()


func _on_language_clicked() -> void:
	var locale : String = TranslationServer.get_locale()
	var all := TranslationServer.get_loaded_locales()
	var translation_index : int = ( all.find( locale ) + 1) % all.size()
	var new_locale := all[ translation_index ]
	TranslationServer.set_locale( new_locale )
	Data.user_pref.locale = new_locale
	Data.user_pref.save()
