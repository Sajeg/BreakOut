shader_type canvas_item;

uniform sampler2D texture_albedo;

void fragment() {
    vec4 tex_color = texture(texture_albedo, UV);
    COLOR.rgb = tex_color.rgb;
    COLOR.a = tex_color.a;
}
