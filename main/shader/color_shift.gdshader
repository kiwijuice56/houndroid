shader_type canvas_item;

uniform vec4 color : hint_color = vec4(0);

void fragment() {
	float x = 1.0 - abs(UV.y - 0.5);
	COLOR.rgb = vec3(dot(texture(SCREEN_TEXTURE, SCREEN_UV).rgb, vec3(x, x, x))) * color.rgb;
}