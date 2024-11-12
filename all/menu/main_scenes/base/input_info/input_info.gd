class_name InputInfo
extends Node

signal emitted()

@export var action_name : StringName
@export var on_release :bool = false
@export var description: String


func custom_input(event: InputEvent) -> void:
	if on_release:
		if InputHelper.is_action_just_released(action_name):
			emitted.emit()
		return
	if InputHelper.is_action_just_pressed(action_name):
		emitted.emit()
