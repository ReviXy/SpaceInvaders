shader_type canvas_item;

uniform sampler2D barrier : repeat_enable, filter_nearest;
uniform sampler2D noise_texture : repeat_enable, filter_nearest;
uniform float proportion;

void vertex() {
	
}

void fragment() {
	COLOR = vec4(mix(texture(noise_texture, UV).rgb, texture(barrier, UV).rgb, proportion) * vec3(0.0, 1.0, 0.0), texture(barrier, UV).a);
	
}
