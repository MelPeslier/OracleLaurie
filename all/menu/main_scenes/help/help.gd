extends ControlFocus

signal help_opened(_opened: bool)


const INFO_DISPLAY = preload("res://all/menu/main_scenes/help/info_display.tscn")


@export var infos: Node
@export var input_handler: Node

@onready var tap_input_info: InputInfo = %TapInputInfo
@onready var v_box: VBoxContainer = %VBox


func _ready() -> void:
	set_process_input(false)
	for info: Info in infos.get_children():
		create_info_display(info)
	
	for input_info: InputInfo in input_handler.get_children():
		create_info_display(input_info)
	
	create_info_display(tap_input_info)


func _input(event: InputEvent) -> void:
	tap_input_info.custom_input( event )


func create_info_display(_info: Info) -> void:
	var info_display: InfoDisplay = INFO_DISPLAY.instantiate()
	v_box.add_child(info_display)
	info_display.update_infos(_info)


func focus(_time_scale : float = 1.0) -> void:
	help_opened.emit(true)
	set_process_input(true)
	super(_time_scale)


func unfocus(_time_scale: float = 1.0) -> void:
	help_opened.emit(false)
	set_process_input(false)
	super(_time_scale)


func _on_tap_input_info_emitted() -> void:
	unfocus()
