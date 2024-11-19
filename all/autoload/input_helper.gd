extends Node

signal focus_type_changed(_focus_type: FocusType)
signal drag_progress_changed(drag_progress: Vector2)

enum FocusType{
	TOUCH_SCREEN,
	CONTROLLER,
	KEYBOARD,
}

var focus_type := FocusType.TOUCH_SCREEN : set = _set_focus_type

var focused := true
var _touch_index :int = -1

var drag_distance :float = 175
var button_press_distance : float = 40
var _drag_pos := Vector2.ZERO

var last_button : BaseCustomButton = null

var drag_progress := Vector2.ZERO : set = _set_drag_progress


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			focused = false
		NOTIFICATION_APPLICATION_FOCUS_IN:
			focused = true


func _input(event: InputEvent) -> void:
	track_focus_type(event)
	if not focus_type == FocusType.TOUCH_SCREEN: return
	if event is InputEventScreenTouch:
		if event.pressed:
			Input.action_press("tap")
			_touch_index = event.index
			_drag_pos = event.position
			drag_progress = Vector2.ZERO
		elif event.index == _touch_index:
			var dist : Vector2 = _drag_pos - event.position
			if event.position.distance_to(_drag_pos) < 30:
				Input.action_release("tap")
			
			elif absf( dist.x ) >= drag_distance: # Side
				if dist.x < 0 : # Finger to right
					Input.action_press("left")
					Input.action_release("left")
				else:
					Input.action_press("right")
					Input.action_release("right")
			
			elif absf( dist.y ) >= drag_distance:
				if dist.y < 0 : # Finger to down
					Input.action_press("up")
					Input.action_release("up")
				else:
					Input.action_press("down")
					Input.action_release("down")
			_touch_index = -1
			drag_progress = Vector2.ZERO
			
		#if event.double_tap:
	
	elif event is InputEventScreenDrag:
		
		if event.index == _touch_index:
			var dist : Vector2 = _drag_pos - event.position
			drag_progress = dist / Vector2(drag_distance, drag_distance)


func is_point_inside_box(_node: BaseCustomButton, event: InputEvent) -> bool:
	if not (event is InputEventScreenTouch or event is InputEventMouseButton):
		return _node == InputHelper.last_button
	var _point : Vector2 = event.position
	var _start : Vector2 = _node.global_position
	var _end : Vector2 = _node.global_position + _node.size * _node.scale
	var _inside :bool = _start.x < _point.x and _end.x > _point.x \
					and _start.y < _point.y and _end.y > _point.y
	return _inside


func is_action_just_pressed(action: StringName) -> bool:
	if focused:
		return Input.is_action_just_pressed(action)
	return false


func is_action_just_released(action: StringName) -> bool:
	if focused:
		return Input.is_action_just_released(action)
	return false


func _set_drag_progress(_drag_progress: Vector2) -> void:
	if drag_progress == _drag_progress: return
	drag_progress = _drag_progress
	drag_progress.x = signf(drag_progress.x) * clampf( absf(drag_progress.x), 0.0, 1.0 )
	drag_progress.y = signf(drag_progress.y) * clampf( absf(drag_progress.y), 0.0, 1.0 )
	if absf( drag_progress.x ) > absf( drag_progress.y ):
		drag_progress.y = 0.0
	else:
		drag_progress.x = 0.0
	drag_progress_changed.emit(drag_progress)


func track_focus_type(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventMouse:
		focus_type = FocusType.KEYBOARD
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		focus_type = FocusType.CONTROLLER
	elif event is InputEventScreenTouch or event is InputEventScreenDrag:
		focus_type = FocusType.TOUCH_SCREEN


func _set_focus_type(_focus_type: FocusType) -> void:
	if focus_type == _focus_type : return
	focus_type = _focus_type
	focus_type_changed.emit(focus_type)
