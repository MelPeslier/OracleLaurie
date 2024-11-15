class_name InfoDisplay
extends HBoxContainer


@onready var image: TextureRect = %Image
@onready var description: Label = %Description


func update_infos(_info: Info) -> void:
	if _info is InputInfo:
		image.custom_minimum_size = Vector2(60, 60)
	
	description.text = _info.description
