shader_type canvas_item;

uniform sampler2D color_ramp : hint_default_white, repeat_disable;
uniform float steps : hint_range(0.0, 50.0, 1.0) = 1.0;

void fragment() {
	vec2 uv = UV;
	float circleSDF = distance(uv, vec2(0.5));
	float output = floor(circleSDF * steps) / steps;
	//COLOR.rgb = vec3( output );
	vec4 output_colored = texture( color_ramp, vec2( output ) );
	COLOR = output_colored;
}
