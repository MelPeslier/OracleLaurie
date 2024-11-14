extends ControlFocus

signal help_opened(_opened: bool)

func focus(_time_scale : float = 1.0) -> void:
	help_opened.emit(true)
	set_process_input(true)
	super(_time_scale)


func unfocus(_time_scale: float = 1.0) -> void:
	help_opened.emit(false)
	set_process_input(false)
	super(_time_scale)

# TODO write the list of things to know
