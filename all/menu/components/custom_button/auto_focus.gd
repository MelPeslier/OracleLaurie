extends Node

func _ready() -> void:
	print("focus call")
	get_parent().focus.call_deferred()
