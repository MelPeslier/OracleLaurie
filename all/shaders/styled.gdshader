shader_type canvas_item;

uniform float repeat = 0.955;
uniform float scale = 3.0;

uniform float edge_low = 0.235;
uniform float edge_high = 1.0;

uniform float shade_start = 0.05;
uniform float shade_end = 0.15;

uniform sampler2D noise_1 : repeat_enable, hint_default_white;
uniform sampler2D noise_2 : repeat_enable, hint_default_white;
uniform vec2 speed_1 = vec2(0.3, 0.5);
uniform vec2 speed_2 = vec2(0.1, 0.5);
uniform float color_instensity = 5.0;
uniform sampler2D color_ramp : hint_default_white, repeat_disable;



void fragment() {
	// Polar
	vec2 uv = UV ;
	vec2 toCenter = vec2(0.5) - uv;
	float angle = atan(toCenter.y,toCenter.x);
	float radius = length(toCenter);
	vec2 polar_uv = vec2(angle * repeat, radius * scale);

	// Scroll
	vec2 uv_1 = polar_uv + speed_1 * TIME;
	vec2 uv_2 = polar_uv + speed_2 * TIME;
	// Textures read
	float n1 = texture(noise_1, uv_1).r;
	float n2 = texture(noise_2, uv_2).r;
	float intensity = n1 * n2;

	// Circle
	float circle = distance(uv, vec2(0.5));
	float circle_shade = smoothstep(shade_start, shade_end, circle);

	// Output
	float output = smoothstep(edge_low, edge_high, intensity);
	output *= circle_shade;
	vec4 output_colored = texture(color_ramp, polar_uv.yx) * color_instensity * output;
	vec4 bg_colored = texture( color_ramp, vec2( circle ) );

	COLOR = bg_colored + output_colored;
}
