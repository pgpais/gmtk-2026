shader_type canvas_item;

// Customize the friendly vibe. A soft sky blue, golden yellow, or healing green works best!
uniform vec4 aura_color : source_color = vec4(0.2, 0.8, 1.0, 1.0); 

// How thick the glowing outline is
uniform float aura_width : hint_range(0.0, 30.0) = 4.0; 

// How fast the aura breathes in and out
uniform float pulse_speed = 2.0; 
// How much the aura grows and shrinks during the pulse
uniform float pulse_intensity = 0.5; 

void fragment() {
    // Read the original color and transparency of the friendly unit
    vec4 original_color = texture(TEXTURE, UV);
    
    // Calculate the breathing pulse using a sine wave
    // This fluctuates smoothly to make the aura feel alive and calm
    float pulse = (sin(TIME * pulse_speed) * pulse_intensity) + (1.0 - pulse_intensity);
    
    // Convert the aura width into actual pixel coordinates
    vec2 size = TEXTURE_PIXEL_SIZE * aura_width * pulse;
    
    // Sample the pixels surrounding our current pixel to check for the sprite's edge
    float alpha = original_color.a;
    alpha = max(alpha, texture(TEXTURE, UV + vec2(size.x, 0.0)).a);
    alpha = max(alpha, texture(TEXTURE, UV + vec2(-size.x, 0.0)).a);
    alpha = max(alpha, texture(TEXTURE, UV + vec2(0.0, size.y)).a);
    alpha = max(alpha, texture(TEXTURE, UV + vec2(0.0, -size.y)).a);
    
    // Sample the diagonal pixels so the aura is smoothly rounded, not blocky
    alpha = max(alpha, texture(TEXTURE, UV + vec2(size.x, size.y)).a);
    alpha = max(alpha, texture(TEXTURE, UV + vec2(-size.x, size.y)).a);
    alpha = max(alpha, texture(TEXTURE, UV + vec2(size.x, -size.y)).a);
    alpha = max(alpha, texture(TEXTURE, UV + vec2(-size.x, -size.y)).a);
    
    // Create the final aura color based on the detected edges
    vec4 final_aura = vec4(aura_color.rgb, aura_color.a * alpha);
    
    // Mix the original sprite color on top of the glowing aura
    COLOR = mix(final_aura, original_color, original_color.a);
}