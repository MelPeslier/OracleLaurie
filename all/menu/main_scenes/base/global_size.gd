extends HBoxContainer

const MIN_SIZE := Vector2( 360, 640 )
const BASE_SIZE := Vector2( 960, 1280 )

@onready var left: Control = %LeftDummy
@onready var main: Control = %Main
@onready var right: Control = %RightDummy


func _ready() -> void:
	get_window().set_min_size(MIN_SIZE)
	get_viewport().size_changed.connect(_on_viewport_size_changed)

## Update left & right sizes
func _on_viewport_size_changed() -> void:
	var v_size := Vector2( get_viewport().size )
	if v_size.x <= BASE_SIZE.x: 
		_set_sizes(0)
		return
	_set_sizes( (v_size.x - BASE_SIZE.x) / 2.0 )

func _set_sizes(_size: float) -> void:
	left.custom_minimum_size.x = _size
	right.custom_minimum_size.x = _size
