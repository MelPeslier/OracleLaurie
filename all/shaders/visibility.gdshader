shader_type canvas_item;

uniform float visibility : hint_range(0.0, 1.0) = 0.5;
uniform float angle_coef : hint_range(0.0, 1.0, 0.01);

void fragment() {
	float angle = angle_coef * TAU;
	float vis = visibility * 1.5 - 0.75;
	vec2 dir = vec2( cos(angle), sin(angle));
	vec2 uv = UV - vec2(0.5);
	float formula = dot(uv, dir);

	float output = step(formula, vis);
	COLOR.a *= output;
}