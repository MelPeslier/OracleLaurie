class_name UserPref
extends Resource

const SAVE_PATH : String = "user://user_pref.tres"

@export var locale : String = ""


func save() -> void:
	ResourceSaver.save(self, SAVE_PATH)


static func load_or_create() -> UserPref:
	var res : UserPref = SafeResourceLoader.load( SAVE_PATH ) as UserPref
	if not res:
		res = UserPref.reset()
	TranslationServer.set_locale( res.locale )
	return res


static func reset() -> UserPref:
	var res := UserPref.new()
	res.locale = OS.get_locale_language()
	res.save()
	return res
