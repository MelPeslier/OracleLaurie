class_name CarteDos
extends Control


@export var card_ref : CardRef


@onready var image: TextureRect = %Image


func init_type(_image: Texture2D, _card_ref: CardRef) -> void:
	image.texture = _image
	card_ref = _card_ref
