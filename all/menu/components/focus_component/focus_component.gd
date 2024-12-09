class_name FocusComponent
extends Node

@export var td_focus: TweenData
@export var td_unfocus: TweenData

var tween: Tween

@onready var parent : CanvasItem = get_parent()


func focus(_time_scale: float = 1.0) -> void:
	pass

func unfocus(_time_scale: float = 1.0) -> void:
	pass
