class_name Carte
extends Control

var card_data: CardData : set = _set_card_data


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


#func _input(event: InputEvent) -> void:
	#if InputHelper.is_action_just_released("tap"):
		#if InputHelper.focus_type == InputHelper.FocusType.TOUCH_SCREEN:
			#if InputHelper.is_point_inside_box(self, event.position):
				#pass


func hide_them() -> void:
	pass

func show_description() -> void:
	pass

func show_complement() -> void:
	pass
