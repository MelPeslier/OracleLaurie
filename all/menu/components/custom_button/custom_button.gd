class_name CustomButton
extends PanelContainer

@export var next_control : ControlFocus
@export var td : TweenData


var t: Tween
var focused := true
var focus_coef : float = 0.0 : set = _set_focus_coef

@onready var hbc: HBoxContainer = %HBC
@onready var border: TextureRect = %Border

@onready var main: TextureRect = %Main
@onready var main_particles: GPUParticles2D = %MainParticles


@onready var svc: SubViewportContainer = %SVC
@onready var label: Label = %Label


func _ready() -> void:
	update_gpu_scale()
	unfocus(0.0)
	activate()


func _input(event: InputEvent) -> void:
	if InputHelper.is_action_just_released("tap") and _is_point_inside_area(event.position):
		if focused:
			next()
		else:
			if InputHelper.last_button:
				InputHelper.last_button.unfocus()
			focus()


func activate() -> void:
	set_process_input(true)


func next(_time_scale: float = 1.0) -> void:
	if not next_control : 
		unfocus()
		return
	next_control.focus()
	set_process_input(false)


func focus(_time_scale: float = 1.0) -> void:
	InputHelper.last_button = self
	main_particles.emitting = true
	focused = true
	if t and t.is_running():
		t.kill()
	t = create_tween().set_parallel()
	td.set_data(t)
	var duration : float = td.duration * _time_scale * (1.0 - focus_coef)
	var target_pos : float = 0.0
	t.tween_property(border, "position:x", target_pos, duration)
	t.tween_property(self, "focus_coef", 1.0, duration)


func unfocus(_time_scale: float = 1.0) -> void:
	focused = false
	if t and t.is_running():
		t.kill()
	t = create_tween().set_parallel()
	td.set_data(t)
	var duration : float = td.duration * _time_scale * focus_coef
	var target_pos : float = ( hbc.size.x - border.size.x ) / 2.0
	t.tween_property(border, "position:x", target_pos, duration)
	t.tween_property(self, "focus_coef", 0.0, duration)
	t.chain().tween_property(main_particles, "emitting", false, 0.0)


func _is_point_inside_area(point: Vector2) -> bool:
	var _start := global_position
	var _end := global_position + size * scale
	var _inside :bool = _start.x < point.x and _end.x > point.x \
					and _start.y < point.y and _end.y > point.y
	return _inside



func update_gpu_scale() -> void:
	var mat : ParticleProcessMaterial = main_particles.process_material
	var target_scale : float = main.size.x / float( main.texture.get_width() )
	mat.emission_shape_scale.x = target_scale
	mat.emission_shape_scale.y = target_scale


func _set_focus_coef(_focus_coef: float) -> void:
	focus_coef = _focus_coef
	if not is_inside_tree(): return
	main_particles.amount_ratio = focus_coef
	var mat : ShaderMaterial = svc.material
	mat.set_shader_parameter("visibility", focus_coef)
