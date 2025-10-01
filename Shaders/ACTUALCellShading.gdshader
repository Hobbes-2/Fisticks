shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_disabled, diffuse_toon, specular_toon;

uniform vec4 albedo : source_color;
uniform sampler2D color_gradiant;
uniform sampler2D frensel_gradiant;


float frensel(float amount, vec3 normal, vec3 view)
{
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0)), amount);
}

void vertex() {
	
}

void fragment() {
	float basic_frensel = frensel(4.0, NORMAL, VIEW);
	ALBEDO = albedo.rgb + (basic_frensel * texture(frensel_gradiant, vec2(basic_frensel, 0.0)).rgb * 1.0);
}

void light() {
	float dotproduct = clamp(dot(NORMAL, LIGHT), -0.9, 0.9);
	float sample = clamp((dotproduct + 1.0) * ATTENUATION / 2.1, 0.05, 0.95);
	vec4 shaded = texture(color_gradiant, vec2(sample, 0.0));
	DIFFUSE_LIGHT += clamp((shaded.rgb * LIGHT_COLOR), 0.0, 1.0);
	//DIFFUSE_LIGHT += (shaded_rgb * LIGHT_COLOR);
}
