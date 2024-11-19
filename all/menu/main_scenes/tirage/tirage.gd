extends Control

const MY_SCROLL = preload("res://all/menu/main_scenes/cartes/my_scroll.tscn")



@onready var drag_preview: DragPreview = %DragPreview


func _ready() -> void:
	for i: int in Data.card_group_datas.size():
		# Add Scroll
		var my_scroll : MyScroll = MY_SCROLL.instantiate()
		add_child(my_scroll)
		my_scroll.drag_preview = drag_preview
		
		# Add Tirage Group to Scroll
		



func _on_input_left_emitted() -> void:
	pass # Replace with function body.


func _on_input_right_emitted() -> void:
	pass # Replace with function body.


func _on_input_up_emitted() -> void:
	pass # Replace with function body.


func _on_input_down_emitted() -> void:
	pass # Replace with function body.


func _on_input_tap_pressed_emitted() -> void:
	pass # Replace with function body.


func _on_input_tap_released_emitted() -> void:
	pass # Replace with function body.
