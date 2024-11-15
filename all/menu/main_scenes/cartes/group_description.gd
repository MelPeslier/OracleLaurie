class_name GroupDescription
extends Control


@export var change_tween_data: TweenData
@export var interval: float = 0.3

var change_tween: Tween
var card_group_data: CardGroupData : set = _set_card_group_data
var is_description := false

@onready var textures: Control = %Textures
@onready var image: TextureRect = %Image
@onready var titre: Label = %Titre
@onready var cards_number: Label = %CardsNumber
@onready var description: Label = %Description


func _set_card_group_data(_card_group_data: CardGroupData) -> void:
	card_group_data = _card_group_data
	image.texture = _card_group_data.image
	titre.text = _card_group_data.titre
	description.text = _card_group_data.description
	cards_number.text = str( _card_group_data.nombre_de_cartes )


func _ready() -> void:
	show_preview(0.0)


func tap() -> void:
	is_description = not is_description
	if is_description:
		show_description(1.0)
	else:
		show_preview(1.0)

func show_preview(_time_scale: float) -> void:
	var _duration := change_tween_data.duration * _time_scale
	change_tween = change_tween_data.kill_and_create(self, change_tween, true)
	change_tween.tween_property(description, "modulate:a", 0.0, _duration)
	change_tween.tween_property(cards_number, "modulate:a", 0.0, _duration).set_delay(interval)
	change_tween.tween_property(textures, "modulate:a", 1.0, _duration).set_delay(interval * 2.0)


func show_description(_time_scale: float) -> void:
	var _duration := change_tween_data.duration * _time_scale
	change_tween = change_tween_data.kill_and_create(self, change_tween, true)
	change_tween.tween_property(textures, "modulate:a", 0.7, _duration)
	change_tween.tween_property(cards_number, "modulate:a", 1.0, _duration).set_delay(interval)
	change_tween.tween_property(description, "modulate:a", 1.0, _duration).set_delay(interval * 2.0)
