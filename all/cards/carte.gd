class_name Carte
extends Control

enum CardState{
	PREVIEW,
	DESCRIPTION,
	COMPLEMENT
}

@export var change_tween_data: TweenData
@export var interval: float = 0.3

var change_tween: Tween

var card_data: CardData : set = _set_card_data
var card_state: CardState : set = _set_card_state


@onready var textures: Control = %Textures
@onready var image: TextureRect = %Image
@onready var titre: Label = %Titre
@onready var mots_cles: Label = %MotsCles
@onready var description: Label = %Description
@onready var complement: Label = %Complement

func _set_card_data(_card_data: CardData) -> void:
	card_data = _card_data
	if not is_inside_tree(): return
	image.texture = card_data.image
	titre.text = card_data.titre
	mots_cles.text = card_data.mots_cles
	description.text = card_data.description
	complement.text = card_data.complement
	card_state = CardState.PREVIEW
	if complement.text.is_empty():
		complement.visible = false


#func _input(event: InputEvent) -> void:
	#if InputHelper.is_action_just_released("tap"):
		#if InputHelper.focus_type == InputHelper.FocusType.TOUCH_SCREEN:
			#if InputHelper.is_point_inside_box(self, event.position):
				#pass

func _set_card_state(_card_state: CardState) -> void:
	card_state = _card_state
	match card_state:
		CardState.PREVIEW:
			show_preview()
		CardState.DESCRIPTION:
			show_description()
		CardState.COMPLEMENT:
			if complement.text.is_empty():
				card_state = CardState.PREVIEW
				show_preview()
			else:
				show_complement()

func tap() -> void:
	card_state = (card_state + 1) % 3

func show_preview() -> void:
	var _duration := change_tween_data.duration
	change_tween = change_tween_data.kill_and_create(self, change_tween, true)
	change_tween.tween_property(complement, "modulate:a", 0.0, _duration)
	change_tween.tween_property(description, "modulate:a", 0.0, _duration).set_delay(interval)
	change_tween.tween_property(textures, "modulate:a", 1.0, _duration).set_delay(interval * 2.0)


func show_description() -> void:
	var _duration := change_tween_data.duration
	change_tween = change_tween_data.kill_and_create(self, change_tween, true)
	change_tween.tween_property(complement, "modulate:a", 0.0, _duration)
	change_tween.tween_property(textures, "modulate:a", 0.7, _duration)
	change_tween.tween_property(description, "modulate:a", 1.0, _duration).set_delay(interval)

func show_complement() -> void:
	var _duration := change_tween_data.duration
	change_tween = change_tween_data.kill_and_create(self, change_tween, true)
	change_tween.tween_property(complement, "modulate:a", 1.0, _duration)
	change_tween.tween_property(description, "modulate:a", 1.0, _duration)
	change_tween.tween_property(textures, "modulate:a", 0.7, _duration)
