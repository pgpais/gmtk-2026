shader_type canvas_item;

// Customize the look of the lightning
uniform vec4 lightning_color : source_color = vec4(1.0, 0.45, 0.0, 1.0); // Electric Orange
uniform float max_radius = 0.45; // How far it spreads before hitting the edge of the texture
uniform float thickness = 0.008; // Thickness of the lightning bolt
uniform float amplitude = 0.04; // How wild and jagged the lightning is
uniform float frequency = 15.0; // Number of lightning spikes

// Animate this from 0.0 to 1.0 via AnimationPlayer or GDScript to trigger the shockwave
uniform float progress : hint_range(0.0, 1.0) = 0.5; 

void fragment() {
    // 1. Center the coordinates (from 0.0 -> 1.0  to  -0.5 -> 0.5)
    vec2 uv = UV - 0.5;
    
    // 2. Convert coordinates to angle and distance (Polar coordinates)
    float angle = atan(uv.y, uv.x);
    float radius = length(uv);
    
    // 3. The current size of the shockwave ring based on our progress
    float current_radius = max_radius * progress;
    
    // 4. Generate the jagged "electricity" math
    // We use absolute sine waves moving rapidly over TIME to create sharp, chaotic peaks
    float jitter = abs(sin(angle * frequency + TIME * 30.0)) 
                 + abs(cos(angle * frequency * 1.5 - TIME * 20.0)) * 0.5;
                 
    // Apply the jitter to the ring's radius
    float displaced_radius = current_radius + (jitter * amplitude * progress);
    
    // 5. Calculate how far the current pixel is from the jagged lightning ring
    float dist = abs(radius - displaced_radius);
    
    // 6. Draw the lightning
    float core = 1.0 - smoothstep(0.0, thickness, dist); // The bright solid center
    float glow = 1.0 - smoothstep(0.0, thickness * 6.0, dist); // The soft orange glow
    
    // 7. Fade the shockwave out as it gets bigger (progress reaches 1.0)
    // We also fade it in right at the start so it doesn't pop instantly
    float fade_out = 1.0 - pow(progress, 2.0); 
    float fade_in = smoothstep(0.0, 0.1, progress);
    float active_fade = fade_in * fade_out;
    
    // 8. Combine colors and output
    vec3 final_color = (lightning_color.rgb * core * 2.0) + (lightning_color.rgb * glow * 0.8);
    float final_alpha = clamp((core + glow) * active_fade * lightning_color.a, 0.0, 1.0);
    
    COLOR = vec4(final_color, final_alpha);
}