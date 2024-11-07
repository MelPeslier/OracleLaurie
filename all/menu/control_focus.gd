class_name ControlFocus
extends Control


func focus(_time_scale : float = 1.0) -> void:
	visible = true
	set_process_input(true)


func unfocus(_time_scale: float = 1.0) -> void:
	visible = false
	set_process_input(false)
