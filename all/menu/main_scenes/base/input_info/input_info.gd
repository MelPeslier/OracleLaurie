class_name InputInfo
extends Info

signal emitted()

@export var action_name : StringName
@export var on_release :bool = false


func custom_input(event: InputEvent) -> void:
	if not event.is_action_type(): return
	if on_release:
		if InputHelper.is_action_just_released(action_name):
			emitted.emit()
		return
	if InputHelper.is_action_just_pressed(action_name):
		emitted.emit()
