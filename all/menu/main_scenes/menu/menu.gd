extends ControlFocus

@onready var quit: CustomButton = %Quit

func _ready() -> void:
	InputHelper.input_back_emitted.connect( quit.next_step )
