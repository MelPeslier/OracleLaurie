class_name HideButton
extends BaseCustomButton

@export var text_left := false : set = _set_text_left


@onready var h_box: HBoxContainer = $HBox
@onready var main: TextureRect = %Main

@onready var svc: SubViewportContainer = %SVC
@onready var label: Label = %Label

func _ready() -> void:
	super()
	text = text
	texture = texture
	text_left = text_left


func update_size() -> void:
	svc.custom_minimum_size = label.size
	print(label.position)
	label.position = Vector2.ZERO


func _set_text_left(_text_left: bool) -> void:
	text_left = _text_left
	if not is_inside_tree(): return
	if text_left:
		h_box.move_child(svc, 0)
		print("moved")

func _set_text(_text: String) -> void:
	super( _text )
	if not is_inside_tree(): return
	label.text = _text
	#label.set_anchors_preset.call_deferred(Control.PRESET_CENTER)
	update_size.call_deferred()

func _set_texture(_texture: Texture2D) -> void:
	super( _texture )
	if not is_inside_tree(): return
	main.texture = texture
