class_name TransitionScreen
extends Control

signal appeared
signal disappeared


@onready var animation_player: AnimationPlayer = %AnimationPlayer


func appear() -> void:
	animation_player.play("appear")
	await animation_player.animation_finished
	appeared.emit()


func disappear() -> void:
	animation_player.play_backwards("appear")
	await animation_player.animation_finished
	disappeared.emit()
