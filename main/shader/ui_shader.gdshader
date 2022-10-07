shader_type canvas_item;

uniform sampler2D light_texture;
uniform vec4 color;

void fragment() {
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV) * -texture(light_texture, UV).r * color;
}