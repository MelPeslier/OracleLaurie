class_name Side
extends ColorRect

enum SideType{
	LEFT,
	RIGHT,
	TOP,
	BOT
}
@export var side_type : SideType : set = _set_side_type
@export var is_available := true
@export var particles_per_100_pixels : float = 10
@onready var particles: GPUParticles2D = $Particles

# TODO : add smooth interpolate when too big of an advance
var visibility : float = 0.0

func _ready() -> void:
	side_type = side_type
	if Engine.is_editor_hint(): return
	InputHelper.drag_progress_changed.connect(_on_drag_progress_changed)


func _on_drag_progress_changed(_drag_progress: Vector2) -> void:
	if not is_available: return
	match side_type:
		SideType.LEFT:
			visibility = max( _drag_progress.x, 0.0)
		SideType.RIGHT:
			visibility = - min( _drag_progress.x, 0.0)
		SideType.TOP:
			visibility = max( _drag_progress.y, 0.0)
		SideType.BOT:
			visibility = - max( _drag_progress.y, 0.0)


func _set_side_type(_side_type: SideType) -> void:
	side_type = _side_type
