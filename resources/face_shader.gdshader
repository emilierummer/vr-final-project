shader_type spatial;

uniform bool is_hovered = false;
uniform bool has_furniture = false;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	if(is_hovered && has_furniture) {
		ALBEDO = vec3(0.9, 0.7, 0.2);
		ALPHA = 0.4;
	} else if(is_hovered) {
		ALBEDO = vec3(0.75, 0.55, 0.1);
		ALPHA = 1.0;
	} else if(has_furniture) {
		ALPHA = 0.0;
	} else {
		ALBEDO = vec3(0.9, 0.7, 0.2);
		ALPHA = 1.0;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
