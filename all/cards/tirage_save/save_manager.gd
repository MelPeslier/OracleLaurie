class_name SaveManager
extends Resource

const SAVE_PATH : String = "user://tirage_saves.tres"

@export var tirage_saves : Array[TirageSave] = []


func save() -> void:
	ResourceSaver.save(self, SAVE_PATH)


static func load_or_create() -> SaveManager:
	var res : SaveManager = SafeResourceLoader.load( SAVE_PATH ) as SaveManager
	if not res:
		res = SaveManager.reset()
	return res


static func reset() -> SaveManager:
	var res := SaveManager.new()
	return res
