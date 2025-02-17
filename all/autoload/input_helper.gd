extends Node

## Inputs
signal input_tap_pressed_emitted(_event: InputEvent)
signal input_tap_released_emitted(_event: InputEvent)
signal input_left_emitted
signal input_right_emitted
signal input_up_emitted
signal input_down_emitted
signal input_back_emitted

signal drag_progress_changed(drag_progress: Vector2)

var _index : int = -1

var drag_distance :float = 300
var button_press_distance : float = 50
var _drag_pos := Vector2.ZERO

var last_button : BaseCustomButton = null

var drag_progress := Vector2.ZERO : set = _set_drag_progress


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		input_back_emitted.emit()


func _ready() -> void:
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			if not _index == -1: return
			input_tap_pressed_emitted.emit(event)
			_index = event.index
			_drag_pos = event.position
			drag_progress = Vector2.ZERO
		else:
			if not event.index == _index : return
			_index = -1
			var dist : Vector2 = _drag_pos - event.position
			
			if event.position.distance_to(_drag_pos) < button_press_distance:
				input_tap_released_emitted.emit(event)
			
			if absf( dist.x ) >= drag_distance: # Side
				if dist.x < 0 : # Finger to right
					input_left_emitted.emit()
				else:
					input_right_emitted.emit()
			
			elif absf( dist.y ) >= drag_distance:
				if dist.y < 0 : # Finger to down
					input_up_emitted.emit()
				else:
					input_down_emitted.emit()
			drag_progress = Vector2.ZERO
			
	elif event is InputEventScreenDrag:
		var dist : Vector2 = _drag_pos - event.position
		drag_progress = dist / Vector2(drag_distance, drag_distance)


func is_point_inside_box(_node: Control, event: InputEvent) -> bool:
	if not (event is InputEventScreenDrag or event is InputEventScreenTouch): return false
	#if not event is InputEventMouse:
		#if _node is BaseCustomButton:
			#return _node == InputHelper.last_button
	var _point : Vector2 = event.position
	var _start : Vector2 = _node.global_position
	var _end : Vector2 = _node.global_position + _node.size * _node.scale
	var _inside :bool = _start.x < _point.x and _end.x > _point.x \
					and _start.y < _point.y and _end.y > _point.y
	return _inside


func reset_drag_progress(_position: Vector2) -> void:
	_drag_pos = _position


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
