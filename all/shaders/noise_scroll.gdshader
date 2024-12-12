shader_type canvas_item;

uniform sampler2D noise_1 : repeat_enable, hint_default_white;
uniform sampler2D noise_2 : repeat_enable, hint_default_white;
uniform vec2 dir = vec2(1.0, 0.0);
uniform vec2 speed_1 = vec2(0.3, 0.5);
uniform vec2 speed_2 = vec2(0.1, 0.5);

uniform float tex_tiling = 1.0;
uniform vec2 tex_size = vec2(250.0);

varying vec2 world_pos; // Keep the variable for the fragment shader

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy; // Get world position
}


void fragment() {
	vec2 tex_uv = tex_tiling / tex_size;
	vec2 world_uv = tex_uv * world_pos;
	vec2 uv = world_uv;
	// Scroll
	vec2 uv_1 = uv + speed_1 * dir * TIME;
	vec2 uv_2 = uv + speed_2 * dir * TIME;
	// Textures read
	vec4 n1 = texture(noise_1, uv_1);
	vec4 n2 = texture(noise_2, uv_2);
	vec4 intensity = n1 * n2;
	
	intensity.a *= COLOR.a;
	COLOR = intensity;
}