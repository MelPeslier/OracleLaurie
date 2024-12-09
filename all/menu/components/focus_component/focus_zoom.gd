class_name FocusZoom
extends FocusComponent

const FOCUS_ZOOM_TD_IN = preload("res://all/menu/components/focus_component/focus_zoom_td_in.tres")
const FOCUS_ZOOM_TD_OUT = preload("res://all/menu/components/focus_component/focus_zoom_td_out.tres")

@export var focused_scale := Vector2( 1.2, 1.2 )
@export var change_pivot_offset := true

func _ready() -> void:
	if not td_focus:
		td_focus = FOCUS_ZOOM_TD_IN
	if not td_unfocus:
		td_unfocus = FOCUS_ZOOM_TD_OUT
	if change_pivot_offset:
		parent.pivot_offset = parent.size/2


func focus(_time_scale: float = 1.0) -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	td_focus.set_data( tween )
	var duration : float = td_focus.duration * _time_scale
	tween.tween_property(parent, "scale", focused_scale, duration)

func unfocus(_time_scale: float = 1.0) -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	td_unfocus.set_data( tween )
	var duration : float = td_unfocus.duration * _time_scale
	tween.tween_property(parent, "scale", Vector2.ONE, duration)
