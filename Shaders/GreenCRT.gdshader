shader_type spatial;
render_mode unshaded, fog_disabled;

uniform sampler2D screen_texture : source_color, hint_screen_texture, filter_nearest;
uniform sampler2D normal_texture : source_color, hint_normal_roughness_texture, filter_nearest;
uniform sampler2D depth_texture : source_color, hint_depth_texture, filter_nearest;

uniform float depth_threshold = 0.05;

//OPTIONAL

vec3 get_original(vec2 screen_uv)
{
	return texture(screen_texture, screen_uv).rgb;
}

vec3 get_normal(vec2 screen_uv)
{
	return texture(normal_texture, screen_uv).rgb * 2.0 - 1.0;
}

float get_depth(vec2 screen_uv, mat4 inv_projection_matrix)
{
	float depth = texture(depth_texture, screen_uv).r;
	vec3 ndc = vec3(screen_uv * 2.0 - 1.0, depth);
	vec4 view = inv_projection_matrix * vec4(ndc, 1.0);
	view.xyz /= -view.w;
	return view.z;
}

void vertex() {
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
	//TEXTURE
	vec3 original = get_original(SCREEN_UV);
	//NORMAL
	vec3 normal = get_normal(SCREEN_UV);
	//DEPTH
	float depth = get_depth(SCREEN_UV, INV_PROJECTION_MATRIX);
	//GET SURROUNDING TEXTURE OF PIXELS
	vec2 texel_size = 1.0 / VIEWPORT_SIZE.xy;
	vec2 uvs[4];
	uvs[0] = vec2(SCREEN_UV.x, SCREEN_UV.y + texel_size.y);
	uvs[1] = vec2(SCREEN_UV.x, SCREEN_UV.y - texel_size.y);
	uvs[2] = vec2(SCREEN_UV.x + texel_size.x, SCREEN_UV.y);
	uvs[3] = vec2(SCREEN_UV.x + texel_size.x, SCREEN_UV.y);
	//EDGE DETECTION TO SEE IF A LINE SHOULD BE DRAWN
	float depth_diff = 0.0;
	float normal_sum = 0.0;
	for(int i = 0; i < 4; i++)
	{
		float d = get_depth(uvs[i], INV_PROJECTION_MATRIX);
		depth_diff += depth - d;
		//DIFFERENCES BEWTEEN NORMALS
		vec3 n = get_normal(uvs[i]);
		vec3 normal_diff = normal - n;

		float screen_roughness = texture(normal_texture, SCREEN_UV).w;
		vec3 screen_normal = texture(normal_texture, SCREEN_UV).xyz;
		screen_normal = screen_normal * 2.0 - 1.0;
		//CALCULATE DOT PRODUCT WITH THE RESULTING NORMALS AND A FILLER ONE (normal_edge_bias)
		vec3 normal_edge_bias = vec3(1.0, 1.0, 1.0);
		float normal_bias_diff = dot(normal_diff, normal_edge_bias);
		float normal_indicator = smoothstep(-0.01, 0.01, normal_bias_diff);

		normal_sum += dot(normal_diff, normal_diff) * normal_indicator;
	}
	float depth_edge = step(depth_threshold, depth_diff);
	float outline = depth_edge + normal_sum;
	//SET THE VISION TO JUST THE WIREFRAME OUTLINE -W- GREEN
	vec3 outline_color = vec3(0.0, 1.0, 0.0); // green
	ALBEDO = pow(outline, 1.2) * vec3(0.0, 1.0, 0.0);
}