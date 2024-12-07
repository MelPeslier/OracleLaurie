class_name TirageSave
extends Resource

@export var date: String
@export var cards_ref : Array[CardRef]
@export var minds_save: Array[MindSave]

func _init() -> void:
	date = Time.get_date_string_from_system()
