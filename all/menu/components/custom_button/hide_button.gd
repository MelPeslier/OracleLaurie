class_name HideButton
extends BaseCustomButton

@export var is_anchored_left := false
@export var coef_visible : float = 0.2

@onready var visual: PanelContainer = %Visual
@onready var main: TextureRect = %Main


func _ready() -> void:
	super()
	texture = texture


func focus(_time_scale: float = 1.0) -> void:
	if InputHelper.last_button and is_instance_valid( InputHelper.last_button ):
		InputHelper.last_button.unfocus()
	InputHelper.last_button = self
	t = td.kill_and_create(self, t)
	t.tween_property(visual, "position:x", 0.0, td.duration)
	t.parallel().tween_property(self, "focused", true, 0.0).set_delay(0.3)


func unfocus(_time_scale: float = 1.0) -> void:
	focused = false
	t = td.kill_and_create(self, t)
	var target_pos : float = visual.size.x * (1.0 - coef_visible)
	if is_anchored_left:
		target_pos *= -1
	t.tween_property(visual, "position:x", target_pos, td.duration)



func _set_texture(_texture: Texture2D) -> void:
	super( _texture )
	if not is_inside_tree(): return
	main.texture = texture
