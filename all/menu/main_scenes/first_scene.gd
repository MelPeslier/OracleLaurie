extends Control

@export var next_scene : PackedScene
@export var trans_screen : PackedScene


func _ready() -> void:
	SceneTransition.change_scene_to_packed(next_scene, trans_screen)
