class_name Side
extends ColorRect

enum SideType{
	LEFT,
	RIGHT,
	TOP,
	BOT
}
@export var side_type : SideType : set = _set_side_type
@export var is_available := true : set = _set_is_available
@export var particles_per_100_pixels : float = 20

@onready var particles: GPUParticles2D = %Particles

# TODO : add smooth interpolate when too big of an advance
var visibility : float = 0.0 : set = _set_visibility

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_RESIZED:
			_on_viewport_size_changed()

func _ready() -> void:
	particles.process_material = particles.process_material.duplicate()
	
	InputHelper.drag_progress_changed.connect(_on_drag_progress_changed)
	#get_viewport().size_changed.connect(_on_viewport_size_changed)
	
	is_available = false
	side_type = side_type
	await create_tween().tween_interval(0.2).finished
	_on_viewport_size_changed()


## Update particles ratio
func _on_viewport_size_changed() -> void:
	if not is_inside_tree() : return
	_set_particles_amount()
	_set_particles_box_extent()

func _on_drag_progress_changed(_drag_progress: Vector2) -> void:
	if not is_available: return
	match side_type:
		SideType.LEFT:
			visibility = - min( _drag_progress.x, 0.0)
		SideType.RIGHT:
			visibility = max( _drag_progress.x, 0.0)
		SideType.TOP:
			visibility = - min( _drag_progress.y, 0.0)
		SideType.BOT:
			visibility = max( _drag_progress.y, 0.0)


func _set_side_type(_side_type: SideType) -> void:
	side_type = _side_type
	if not is_inside_tree(): return
	var mat : ParticleProcessMaterial = particles.process_material
	match side_type:
		SideType.LEFT:
			mat.direction = Vector3( 1.0, 0.0, 0.0 )
		SideType.RIGHT:
			mat.direction = Vector3( -1.0, 0.0, 0.0 )
		SideType.TOP:
			mat.direction = Vector3( 0.0, 1.0, 0.0 )
		SideType.BOT:
			mat.direction = Vector3( 0.0, -1.0, 0.0 )


func _set_particles_amount() -> void:
	if not particles: return
	var bigger : float = maxf( size.x, size.y )
	particles.amount = particles_per_100_pixels * (bigger / 100)


func _set_particles_box_extent() -> void:
	if not particles: return
	var mat : ParticleProcessMaterial = particles.process_material
	#var ratio : Vector2 = Vector2( 960.0, 1280.0 ) / Vector2( get_window().size )
	#print("ratio : ", ratio)
	mat.emission_box_extents.x = size.x #* ratio.x
	mat.emission_box_extents.y = size.y #* ratio.y


func _set_is_available(_is: bool) -> void:
	if is_available == _is: return
	is_available = _is
	particles.emitting = _is
	_on_viewport_size_changed()
	if not is_available:
		visibility = 0.0

func _set_visibility(_visibility: float) -> void:
	visibility = clampf( _visibility, 0.0, 1.0)
	self_modulate.a = visibility
	particles.amount_ratio = visibility
