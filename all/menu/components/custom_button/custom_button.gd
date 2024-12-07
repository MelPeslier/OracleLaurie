@tool
class_name CustomButton
extends BaseCustomButton

const BUTTON_PROCESS_MAT = preload("res://all/menu/components/custom_button/button_process_mat.material")

enum EmissionMaskMode{
	EMISSION_MODE_SOLID,
	EMISSION_MODE_BORDER,
	EMISSION_MODE_BORDER_DIRECTED,
}

@export var apply := false : set = _set_apply
@export_group("Mask")
@export var emode : EmissionMaskMode
@export var use_mask_colors := false
@export var centered := true
@export_range(0, 255, 1) var transparency_threshold : int = 128

var focus_coef : float = 0.0 : set = _set_focus_coef



@onready var hbc: HBoxContainer = %HBC
@onready var border: TextureRect = %Border

@onready var main: TextureRect = %Main
@onready var main_particles: GPUParticles2D = %MainParticles


@onready var svc: SubViewportContainer = %SVC
@onready var label: Label = %Label


func _ready() -> void:
	_set_apply(true)
	if Engine.is_editor_hint(): return
	focus_coef = 0.0
	super()


func focus(_time_scale: float = 1.0) -> void:
	if InputHelper.last_button and is_instance_valid( InputHelper.last_button ):
		InputHelper.last_button.unfocus()
	InputHelper.last_button = self
	main_particles.emitting = true
	if t and t.is_running():
		t.kill()
	t = create_tween().set_parallel()
	td.set_data(t)
	var duration : float = td.duration * _time_scale * (1.0 - focus_coef)
	var target_pos : float = 0.0
	t.tween_property(border, "position:x", target_pos, duration)
	t.tween_property(self, "focus_coef", 1.0, duration)
	t.tween_property(self, "is_focused", true, 0.0).set_delay(0.3)


func unfocus(_time_scale: float = 1.0) -> void:
	is_focused = false
	if t and t.is_running():
		t.kill()
	t = create_tween().set_parallel()
	td.set_data(t)
	var duration : float = td.duration * _time_scale * focus_coef
	var target_pos : float = ( hbc.size.x - border.size.x ) / 2.0
	t.tween_property(border, "position:x", target_pos, duration)
	t.tween_property(self, "focus_coef", 0.0, duration)
	t.chain().tween_property(main_particles, "emitting", false, 0.0)


func update_gpu_scale() -> void:
	var mat : ParticleProcessMaterial = main_particles.process_material
	var target_scale : float = main.size.x / float( main.texture.get_width() )
	mat.emission_shape_scale.x = target_scale
	mat.emission_shape_scale.y = target_scale
	if centered:
		mat.emission_shape_offset.x -= main.size.x / 2.0
		mat.emission_shape_offset.y -= main.size.y / 2.0

func _set_focus_coef(_focus_coef: float) -> void:
	focus_coef = _focus_coef
	if not is_inside_tree(): return
	main_particles.amount_ratio = focus_coef
	var mat : ShaderMaterial = svc.material
	mat.set_shader_parameter("visibility", focus_coef)

func _set_apply(_apply: bool) -> void:
	if not is_inside_tree(): return
	label.text = text
	main.texture = texture
	main_particles.process_material = BUTTON_PROCESS_MAT.duplicate()
	update_gpu_scale()
	generate_emission_mask()


func generate_emission_mask() -> void:
	var pm = main_particles.process_material
	if not pm or not pm is ParticleProcessMaterial: 
		push_warning("Conditions to generate mask aren't meet")
		return
	var p_mat : ParticleProcessMaterial = pm

	var img: Image = texture.get_image()

	var img_size := img.get_size()
	if img_size.x == 0 or img_size.y == 0:
		var grad : GradientTexture1D = GradientTexture1D.new()
		grad.gradient = Gradient.new()
		p_mat.emission_point_count = 0
		p_mat.emission_point_texture = grad
		p_mat.emission_color_texture = grad
		push_warning("Invalide size for the baked texture")
		return
	
	var valid_positions : Array[Vector2] = []
	var valid_normals : Array[Vector2] = []
	var valid_colors : Array[Color] = []

	valid_positions.resize(img_size.x * img_size.y)
	if emode == EmissionMaskMode.EMISSION_MODE_BORDER_DIRECTED:
		valid_normals.resize(img_size.x * img_size.y)
	if use_mask_colors:
		valid_colors.resize(img_size.x * img_size.y)

	var vpc : int = 0
	for i : int in range(img_size.x):
		for j : int in range(img_size.y):
			var alpha: int = img.get_pixel(i, j).a8 # entre 0 & 255
			if alpha > transparency_threshold:
				if emode == EmissionMaskMode.EMISSION_MODE_SOLID:
					# Positions
					valid_positions[vpc] = Vector2(i, j)
					# Colors
					if use_mask_colors:
						valid_colors[vpc] = img.get_pixel(i, j)
					# Increment
					vpc += 1
				else:
					var on_border := false
					for x in range(i - 1, i + 2):
						for y in range(j - 1, j + 2):
							if x < 0 or y < 0 or x >= img_size.x or y >= img_size.y or img.get_pixel(x, y).a8 <= transparency_threshold:
								on_border = true
								break
						if on_border:
							break
					if on_border:
						# Positions
						valid_positions[vpc] = Vector2(i, j)
						# Colors
						if use_mask_colors:
							valid_colors[vpc] = img.get_pixel(i, j)
						# Normals
						if emode == EmissionMaskMode.EMISSION_MODE_BORDER_DIRECTED:
							var normal := Vector2()
							for x in range(i - 2, i + 3):
								for y in range(j - 2, j + 3):
									if x == i and y == j:
										continue
									if x < 0 or y < 0 or x >= img_size.x or y >= img_size.y or img.get_pixel(x, y).a8 <= transparency_threshold:
										normal += Vector2(x - i, y - j).normalized()
							normal = normal.normalized()
							valid_normals[vpc] = normal
						# Increment
						vpc += 1

	if vpc == 0:
		var grad : GradientTexture1D = GradientTexture1D.new()
		grad.gradient = Gradient.new()
		p_mat.emission_point_count = 0
		p_mat.emission_point_texture = grad
		p_mat.emission_color_texture = grad
		print("No pixels with transparency > " + str(transparency_threshold) + " in image...")
		return
	var new_width := floori( sqrt( vpc ) ) + 1
	var final_size := int( new_width * new_width )
	#var w : int = 2048;
	#var h : int = (vpc / 2048) + 1;

	var bytes := PackedByteArray()
	# Resize depending on maximum capacity and on the byte format that will be passed to the image
	# Image.FORMAT_RGF = *4 for the size of a float, and * 2 because Vector2 components
	# Image.FORMAT_RGBA8 = *4 for the size of 4 different values, each of type uint_8, (0-255) so 1 byte
	
	p_mat.emission_point_count = vpc
	# Positions
	# Resize
	bytes.resize(final_size * 8)
	# Fill
	for i: int in final_size - 8:
		bytes.encode_float(i * 8 + 0, valid_positions[i % vpc].x)
		bytes.encode_float(i * 8 + 4, valid_positions[i % vpc].y)
	var new_img_positions := Image.create_from_data(new_width, new_width, false, Image.FORMAT_RGF, bytes)
	p_mat.emission_point_texture = ImageTexture.create_from_image(new_img_positions)
	
	# Colors
	if use_mask_colors:
		# Resize
		bytes.resize(final_size * 4)
		# Fill
		for i: int in final_size - 4:
			bytes.encode_u8(i * 4 + 0, valid_colors[i % vpc].r8)
			bytes.encode_u8(i * 4 + 1, valid_colors[i % vpc].g8)
			bytes.encode_u8(i * 4 + 2, valid_colors[i % vpc].b8)
			bytes.encode_u8(i * 4 + 3, valid_colors[i % vpc].a8)
		var new_img_colors := Image.create_from_data(new_width, new_width, false, Image.FORMAT_RGBA8, bytes)
		p_mat.emission_color_texture = ImageTexture.create_from_image(new_img_colors)
	else:
		p_mat.emission_color_texture = null
	
	# Normals
	# WARNING : not implemented 
	if emode == EmissionMaskMode.EMISSION_MODE_BORDER_DIRECTED:
		# Resize
		bytes.resize(final_size * 8)
		# Fill
		for i: int in final_size - 8 :
			bytes.encode_float(i * 8 + 0, valid_normals[i % vpc].x)
			bytes.encode_float(i * 8 + 4, valid_normals[i % vpc].y)
		var new_img_normals := Image.create_from_data(new_width, new_width, false, Image.FORMAT_RGF, bytes)
		p_mat.set_shader_parameter("emission_texture_normal", ImageTexture.create_from_image(new_img_normals))
