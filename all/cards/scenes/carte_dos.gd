class_name CarteDos
extends Control

signal choosen(_card_ref : CardRef)

@export var card_ref : CardRef
@export var td: TweenData
@export var target_scale:= Vector2(1.2, 1.2)
@export var shadow_offset_coef : float = 2

var tween: Tween
var activated := false : set = _set_activated
var _touch_index : int = -1
var focused := false

@onready var image: TextureRect = %Image
@onready var shadow: ColorRect = %Shadow
@onready var shadow_offset := shadow.position

func _ready() -> void:
	activated = false


func _input(event: InputEvent) -> void:
	# si input touch, press / drag & is on top of card, focus,
	if event.is_action_type():
		if event is InputEventScreenTouch:
			if event.pressed:
				_touch_index = event.index
			elif focused:
				choosen.emit(card_ref)
				_touch_index = -1
				unfocus()
		return
	# Drag handle :
	if event is InputEventScreenDrag:
		if InputHelper.is_point_inside_box(self, event):
			if not focused:
				focus()
		elif focused:
			unfocus()
	
	# else if not on top of card and focused, unfocus
	
	#TODO:  ajouter un mouvement de skew à la carte, ainsi que son ombre qui suit,
	#  et q'ui s'offset en fonction de l'endroit appuyé


func focus() -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween().set_parallel()
	td.set_data(tween)
	tween.tween_property(self, "scale", target_scale, td.duration)
	tween.tween_property(shadow, "position", shadow_offset * shadow_offset_coef, td.duration)
	focused = true

func unfocus() -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween().set_parallel()
	td.set_data(tween)
	tween.tween_property(self, "scale", Vector2.ONE, td.duration * 0.5)
	tween.tween_property(shadow, "position", shadow_offset, td.duration * 0.5)
	focused = false


func _set_activated(_activated: bool) -> void:
	activated = _activated
	set_process_input(activated)



func init_type(_image: Texture2D, _card_ref: CardRef) -> void:
	image.texture = _image
	card_ref = _card_ref
