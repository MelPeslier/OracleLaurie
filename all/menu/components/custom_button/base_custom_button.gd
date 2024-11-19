class_name BaseCustomButton
extends PanelContainer

@export var auto_focus :bool = false
@export var text : String : set = _set_text
@export var texture : Texture2D : set = _set_texture
@export var td : TweenData

@export_group("Action")
@export var action_name : StringName = "tap"
@export var on_release := true

@export_group("ToDo")
@export var change_scene := false
@export_subgroup("Change")
@export var next_scene: PackedScene
@export var transition_screen_packed: PackedScene
@export_subgroup("Stay")
@export var control_focus : ControlFocus

@export_group("NextButton")
@export var button_up : BaseCustomButton
@export var button_down : BaseCustomButton
@export var button_left : BaseCustomButton
@export var button_right : BaseCustomButton

var t: Tween
var focused := false


func _ready() -> void:
	activate()
	if auto_focus:
		focus.call_deferred()
	else:
		unfocus.call_deferred(0.0)


func _input(event: InputEvent) -> void:
	if not event.is_action_type(): return
	if not InputHelper.is_point_inside_box(self, event): return
	
	if is_action_just():
		if focused:
			next()
		else:
			focus()
	
	if not focused: return
	
	if InputHelper.is_action_just_released("up") and button_up:
		button_up.focus()
	elif InputHelper.is_action_just_released("down") and button_down:
		button_down.focus()
	elif InputHelper.is_action_just_released("left") and button_left:
		button_left.focus()
	elif InputHelper.is_action_just_released("right") and button_right:
		button_right.focus()


func next(_time_scale: float = 1.0) -> void:
	if change_scene:
		SceneTransition.change_scene_to_packed(next_scene, transition_screen_packed)
		set_process_input(false)
		return
	control_focus.focus()


func focus(_time_scale: float = 1.0) -> void:
	if InputHelper.last_button:
		InputHelper.last_button.unfocus()
	InputHelper.last_button = self
	focused = true


func unfocus(_time_scale: float = 1.0) -> void:
	focused = false


func activate() -> void:
	set_process_input(true)


func is_action_just() -> bool:
	if on_release:
		return InputHelper.is_action_just_released( action_name )
	return InputHelper.is_action_just_pressed( action_name )


func _set_text(_text: String) -> void:
	text = _text

func _set_texture(_texture: Texture2D) -> void:
	texture = _texture
