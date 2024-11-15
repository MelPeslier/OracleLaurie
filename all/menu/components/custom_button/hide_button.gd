class_name HideButton
extends BaseCustomButton

#@export var text_left := false : set = _set_text_left
#@export var angle_left : float = 0.5
#@export var angle_right : float = 0.0

@onready var h_box: HBoxContainer = $HBox
@onready var main: TextureRect = %Main

#@onready var svc: SubViewportContainer = %SVC
#@onready var label: Label = %Label

func _ready() -> void:
	super()
	#text = text
	texture = texture
	#text_left = text_left





#func _set_text_left(_text_left: bool) -> void:
	#text_left = _text_left
	#if not is_inside_tree(): return
	#var mat: ShaderMaterial = svc.material
	#mat.set_shader_parameter("angle_coef", angle_right)
	#if text_left:
		#h_box.move_child(svc, 0)
		#label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		#mat.set_shader_parameter("angle_coef", angle_left)


#func _set_text(_text: String) -> void:
	#super( _text )
	#if not is_inside_tree(): return
	#label.text = _text

func _set_texture(_texture: Texture2D) -> void:
	super( _texture )
	if not is_inside_tree(): return
	main.texture = texture
