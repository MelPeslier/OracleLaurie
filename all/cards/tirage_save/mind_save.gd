class_name MindSave
extends Resource

@export var date : String = ""
@export var text : String = ""

func _init() -> void:
	if date.is_empty():
		date = Time.get_date_string_from_system()
