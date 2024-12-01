shader_type canvas_item;
uniform float slider : hint_range(0.0, 1.0) = 0.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 final_color = vec4(0.0, 0.0, 0.0, 1.0);
	vec4 black = vec4(0.0, 0.0, 0.0, 1.0);
	
	vec4 Texture = texture(TEXTURE, UV);
	
	float gradient = floor(UV.y + slider);
	final_color = Texture;
	final_color.rgb = mix(black.rgb, Texture.rgb, gradient);
	
	COLOR = final_color;
	
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
