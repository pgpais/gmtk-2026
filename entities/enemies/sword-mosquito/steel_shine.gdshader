shader_type canvas_item;

// Customize your metal properties in the inspector
uniform vec4 steel_tint : source_color = vec4(0.65, 0.75, 0.85, 1.0); // A cold, bluish-silver
uniform float contrast : hint_range(0.5, 3.0) = 1.8; // High contrast looks more metallic
uniform float shine_speed = 1.5; // How fast the glint moves
uniform float shine_width = 0.15; // How wide the glint is
uniform vec4 shine_color : source_color = vec4(1.0, 1.0, 1.0, 0.8); // Bright white shine

void fragment() {
    // Get the original texture pixel
    vec4 tex_color = texture(TEXTURE, UV);
    
    // 1. Convert the original color to grayscale (luminance)
    // We use the standard math for how human eyes perceive brightness
    float luminance = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));
    
    // 2. Boost the contrast to give it that hard, metallic shading
    float adjusted_luma = clamp((luminance - 0.5) * contrast + 0.5, 0.0, 1.0);
    
    // 3. Apply our cold steel tint to the grayscale image
    vec3 base_metal = vec3(adjusted_luma) * steel_tint.rgb;
    
    // 4. Calculate a diagonal shine sweeping across the sprite
    // Adding UV.x and UV.y creates a 45-degree angle
    float diagonal_uv = UV.x + UV.y; 
    
    // Use TIME to move the shine. mod() makes it loop infinitely.
    // The range is stretched (-0.5 to 2.5) so there's a pause between shines
    float shine_pos = mod(TIME * shine_speed, 3.0) - 0.5; 
    
    // Calculate how close the current pixel is to the moving shine line
    float shine_dist = abs(diagonal_uv - shine_pos);
    
    // Turn that distance into a sharp, visible band
    float shine_band = 1.0 - smoothstep(0.0, shine_width, shine_dist);
    
    // 5. Add the shine on top of the base metal color
    vec3 final_color = base_metal + (shine_band * shine_color.rgb);
    
    // Output the final color, keeping the original sprite's transparency (alpha)
    COLOR = vec4(final_color, tex_color.a);
}