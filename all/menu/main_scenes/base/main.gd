extends Control

@onready var hide_button_return: HideButton = $MarginContainer/HideButtonReturn

func _ready() -> void:
	InputHelper.input_back_emitted.connect( hide_button_return.next_step )


func _on_input_back_emitted() -> void:
	hide_button_return.next_step()
