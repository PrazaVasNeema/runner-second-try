shader_type spatial;
render_mode unshaded, depth_test_disabled, wireframed;

uniform sampler2D depth_texture : hint_depth_texture;

varying float fragment_depth; // distance from current vertex to the camera

void vertex() {
	vec4 clip_space_pos = MODELVIEW_MATRIX * vec4(VERTEX, 1.0);
	//clip_space_pos = PROJECTION_MATRIX * clip_space_pos;
    fragment_depth = clip_space_pos.z / clip_space_pos.w;
}

void fragment() {
	float depth = texture(depth_texture, SCREEN_UV).x;
	depth = PROJECTION_MATRIX[3][2] / (depth + PROJECTION_MATRIX[2][2]);
	//ALPHA = 0.5;
	ALBEDO = vec3(1,0,0);
	//ALPHA = 0.5;
	
	//ALBEDO = vec3(depth * 0.01);
	//ALBEDO = vec3(depth);
	//ALBEDO = vec3(-fragment_depth);
	
	
	if (depth > -fragment_depth)
		discard;
	
}

void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
}
