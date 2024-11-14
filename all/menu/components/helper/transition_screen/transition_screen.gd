class_name TransitionScreen
extends Control

signal appeared
signal disappeared

@export var play_backwards := true

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func appear() -> void:
	animation_player.play("appear")
	await animation_player.animation_finished
	appeared.emit()


func disappear() -> void:
	if play_backwards:
		animation_player.play_backwards("appear")
	else:
		animation_player.play("disappear")
	await animation_player.animation_finished
	disappeared.emit()
