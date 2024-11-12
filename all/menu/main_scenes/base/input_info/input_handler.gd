class_name InputHandler
extends Node

@onready var drag_preview: DragPreview = %DragPreview

func _ready() -> void:
	update_available_preview()


func _input(event: InputEvent) -> void:
	for input_info: InputInfo in get_children():
		input_info.custom_input(event)


func update_available_preview() -> void:
	for input_info: InputInfo in get_children():
		match input_info.action_name:
			#&"tap":
				
			&"up":
				drag_preview.change_side_state(Side.SideType.TOP, true)
			&"down":
				drag_preview.change_side_state(Side.SideType.BOT, true)
			&"left":
				drag_preview.change_side_state(Side.SideType.LEFT, true)
			&"right":
				drag_preview.change_side_state(Side.SideType.RIGHT, true)
