extends ControlFocus

signal help_opened(_opened: bool)


const INFO_DISPLAY = preload("res://all/menu/main_scenes/help/info_display.tscn")


@export var infos: Node
@export var input_handler: Node

@onready var v_box: VBoxContainer = %VBox


func _ready() -> void:
	unfocus(0.0)
	for info: Info in infos.get_children():
		create_info_display(info)
	
	for input_info: InputInfo in input_handler.get_children():
		create_info_display(input_info)


func create_info_display(_info: Info) -> void:
	var info_display: InfoDisplay = INFO_DISPLAY.instantiate()
	v_box.add_child(info_display)
	info_display.update_infos(_info)


func focus(_time_scale : float = 1.0) -> void:
	help_opened.emit(true)
	super(_time_scale)
	InputHelper.input_tap_released_emitted.connect( _on_input_tap_released_emitted )


func unfocus(_time_scale: float = 1.0) -> void:
	help_opened.emit(false)
	super(_time_scale)
	if InputHelper.input_tap_released_emitted.is_connected( _on_input_tap_released_emitted ):
		InputHelper.input_tap_released_emitted.disconnect( _on_input_tap_released_emitted )


func _on_input_tap_released_emitted(_event: InputEvent) -> void:
	unfocus()
