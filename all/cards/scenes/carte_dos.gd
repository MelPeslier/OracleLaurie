class_name CarteDos
extends Control

signal choosen(_card_ref : CardRef)

@export var card_ref : CardRef
@export var td: TweenData
@export var target_scale:= Vector2(1.2, 1.2)
@export var shadow_offset_coef : float = 2

@export_group("fake_3D")
@export var y_rot_max: float = 20
@export var x_rot_max: float = 20

var x_rot: float = 0 : set = _set_x_rot

func _set_x_rot(_rot: float) -> void:
	x_rot = _rot
	var mat : ShaderMaterial = material
	mat.set_shader_parameter("x_rot", x_rot * x_rot_max)

var y_rot: float = 0 : set = _set_y_rot

func _set_y_rot(_rot: float) -> void:
	y_rot = _rot
	var mat : ShaderMaterial = material
	mat.set_shader_parameter("y_rot", y_rot * y_rot_max)


var tween: Tween
var activated := false : set = _set_activated
var _touch_index : int = -1
var focused := false

@onready var image: TextureRect = %Image
@onready var shadow: PanelContainer = %Shadow
@onready var shadow_offset := shadow.position
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer

func _ready() -> void:
	activated = false


func _input(event: InputEvent) -> void:
	# si input touch, press / drag & is on top of card, focus,
	if event is InputEventScreenTouch:
		if event.pressed:
			_touch_index = event.index
		elif focused:
			choosen.emit(card_ref)
			_touch_index = -1
			unfocus()
			return
	# Drag handle :
	var just_pressed : bool = event is InputEventScreenTouch and event.pressed and event.index == _touch_index
	if event is InputEventScreenDrag or just_pressed:
		if InputHelper.is_point_inside_box(self, event):
			InputHelper.reset_drag_progress(event.position)
			skew(event.position)
			if not focused:
				focus()
		elif focused:
			unfocus()


func skew(_pos: Vector2) -> void:
	var strength : Vector2 = global_position + pivot_offset - _pos
	var coef := strength / custom_minimum_size * scale

	y_rot = -coef.x
	x_rot = coef.y
	


func focus() -> void:
	if audio_stream_player:
		audio_stream_player.play()
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
	tween.tween_property(self, "x_rot", 0.0, td.duration)
	tween.tween_property(self, "y_rot", 0.0, td.duration)
	focused = false


func _set_activated(_activated: bool) -> void:
	activated = _activated
	set_process_input(activated)



func init_type(_image: Texture2D, _card_ref: CardRef) -> void:
	image.texture = _image
	card_ref = _card_ref
