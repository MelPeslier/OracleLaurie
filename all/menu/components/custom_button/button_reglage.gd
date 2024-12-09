class_name ButtonReglage
extends BaseCustomButton

@onready var label: Label = %Label
@onready var visual: PanelContainer = %Visual
@onready var main: TextureRect = %Main


func _ready() -> void:
	super()
	_set_apply(true)


func _set_apply(_apply: bool) -> void:
	if not is_inside_tree(): return
	label.text = text
	main.texture = texture
