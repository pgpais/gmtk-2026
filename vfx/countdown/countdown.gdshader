shader_type canvas_item;

uniform float radius : hint_range(0.0, 0.5) = 0.45;
// Thinner core looks hotter
uniform float thickness : hint_range(0.0, 0.1) = 0.01; 
// New Glow Parameters
uniform float glow_thickness : hint_range(0.0, 0.2) = 0.08;
uniform float glow_opacity : hint_range(0.0, 1.0) = 0.6;

uniform vec4 lightning_color : source_color = vec4(0.1, 0.8, 1.0, 1.0); // Cyan
uniform float arc_length : hint_range(0.0, 1.0) = 0.3; 
uniform float progress : hint_range(0.0, 1.0) = 0.0; 
uniform sampler2D noise_tex : repeat_enable; 

void fragment() {
    vec2 centered_uv = UV - 0.5;
    float r = length(centered_uv); 
    
    float angle = atan(centered_uv.y, centered_uv.x);
    float norm_angle = fract((angle + 3.14159265) / (2.0 * 3.14159265));
    
    // Add moving noise to make it jagged
    float noise = texture(noise_tex, vec2(norm_angle * 3.0, TIME * 3.0)).r;
    float noisy_radius = radius + (noise - 0.5) * 0.04; 
    
    // 1. Calculate the Sharp Core Bolt
    float ring = smoothstep(thickness, thickness - 0.005, abs(r - noisy_radius));
    
    // 2. Calculate the Soft Outer Glow
    float glow = smoothstep(glow_thickness, 0.0, abs(r - noisy_radius)) * glow_opacity;
    
    // Create the rotating mask
    float dist = fract(progress - norm_angle);
    float fade = smoothstep(arc_length, 0.0, dist); 
    
    // Mix colors: Core is 80% white, glow is the pure lightning_color
    vec3 core_color = mix(lightning_color.rgb, vec3(1.0), 0.8);
    vec3 final_color = mix(lightning_color.rgb, core_color, ring);
    
    // Combine core and glow opacities
    COLOR = vec4(final_color, clamp(ring + glow, 0.0, 1.0) * fade);
	
}