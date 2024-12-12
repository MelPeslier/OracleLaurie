class_name BaseCustomButton
extends PanelContainer

signal focused
signal unfocused
signal clicked

@export var focus_component : FocusComponent
@export var text : String : set = _set_text
@export var texture : Texture2D : set = _set_texture
@export var td : TweenData

@export_group("Action")
@export var action_name : StringName = &"tap"
@export var on_release := true

@export_group("ToDo")
@export var change_scene := false
@export_subgroup("Change")
@export var use_path := true
@export var next_scene: PackedScene
@export_file("*.tscn") var next_scene_path: String
@export var transition_screen_packed: PackedScene
@export_subgroup("Stay")
@export var control_focus : ControlFocus

@export_group("NextButton")
@export var button_up : BaseCustomButton
@export var button_down : BaseCustomButton
@export var button_left : BaseCustomButton
@export var button_right : BaseCustomButton

var t: Tween
var is_focused := false : set = _set_focused
func _set_focused(_is_focused: bool) -> void:
	is_focused = _is_focused
	if is_focused:
		focused.emit()
	else:
		unfocused.emit()


func _ready() -> void:
	activate()
	unfocus.call_deferred(0.0)
	InputHelper.input_tap_released_emitted.connect( _on_input_tap_released_emitted )


func _on_input_tap_released_emitted(_event: InputEvent):
	if InputHelper.is_point_inside_box(self, _event):
		next_step()
		return
	if is_focused:
		unfocus()

func next_step() -> void:
		if is_focused:
			next()
		else:
			focus()


#func _input(event: InputEvent) -> void:
	#if not event.is_action_type(): return
	#
	#if InputHelper.is_point_inside_box(self, event):
		#if Input.is_action_just_released("tap"):
			#if is_focused:
				#next()
			#else:
				#focus()
		#return
	#
	#if not is_focused: return
	#if Input.is_action_just_released("up") and button_up:
		#button_up.focus()
	#elif Input.is_action_just_released("down") and button_down:
		#button_down.focus()
	#elif Input.is_action_just_released("left") and button_left:
		#button_left.focus()
	#elif Input.is_action_just_released("right") and button_right:
		#button_right.focus()


func next(_time_scale: float = 1.0) -> void:
	clicked.emit()
	if change_scene:
		if use_path:
			SceneTransition.change_scene_to_file(next_scene_path, transition_screen_packed)
		else:
			SceneTransition.change_scene_to_packed(next_scene, transition_screen_packed)
		set_process_input(false)
		return
	if not control_focus:
		print("base button : no focus referred")
		unfocus()
		return
	control_focus.focus()


func focus(_time_scale: float = 1.0) -> void:
	if InputHelper.last_button and is_instance_valid( InputHelper.last_button ):
		InputHelper.last_button.unfocus()
	InputHelper.last_button = self
	is_focused = true
	if focus_component:
		focus_component.focus(_time_scale)


func unfocus(_time_scale: float = 1.0) -> void:
	is_focused = false
	if focus_component:
		focus_component.unfocus(_time_scale)


func activate() -> void:
	set_process_input(true)


func _set_text(_text: String) -> void:
	text = _text

func _set_texture(_texture: Texture2D) -> void:
	texture = _texture
