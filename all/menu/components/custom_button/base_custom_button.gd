class_name BaseCustomButton
extends PanelContainer

@export var text : String
@export var texture : Texture2D
@export var td : TweenData

@export_group("Action")
@export var action_name : StringName = "tap"
@export var on_release := true

@export_group("Next")
@export var change_scene := false
@export_subgroup("Change")
@export var next_scene: PackedScene
@export var transition_screen_packed: PackedScene
@export_subgroup("Stay")
@export var control_focus : ControlFocus

var t: Tween
var focused := false


func _ready() -> void:
	activate()
	unfocus.call_deferred(0.0)


func _input(event: InputEvent) -> void:
	if not event.is_action_type(): return
	if is_action_just() and InputHelper.is_point_inside_box(self, event.position):
		if focused:
			next()
		else:
			focus()


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
