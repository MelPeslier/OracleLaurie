extends Node

var focused := true
var _touch_index :int = -1

var drag_distance :float = 175
var _drag_pos := Vector2.ZERO

var last_button : CustomButton = null


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			focused = false
		NOTIFICATION_APPLICATION_FOCUS_IN:
			focused = true


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			Input.action_press("tap")
			_touch_index = event.index
			_drag_pos = event.position
		elif event.index == _touch_index:
			Input.action_release("tap")
	
	elif event is InputEventScreenDrag:
		if event.index == _touch_index:
			var dist : Vector2 = _drag_pos - event.position
			if absf( dist.x ) >= drag_distance: # Side
				if dist.x < 0 : # Finger to right
					Input.action_press("left")
					Input.action_release("left")
				else:
					Input.action_press("right")
					Input.action_release("right")
				_touch_index = -1
			
			elif absf( dist.y ) >= drag_distance:
				if dist.y < 0 : # Finger to down
					Input.action_press("up")
					Input.action_release("up")
				else:
					Input.action_press("down")
					Input.action_release("down")
				_touch_index = -1


func is_action_just_pressed(action: StringName) -> bool:
	if focused:
		return Input.is_action_just_pressed(action)
	return false



func is_action_just_released(action: StringName) -> bool:
	if focused:
		return Input.is_action_just_released(action)
	return false
