shader_type canvas_item;

// Customize the vibe of your scent cloud
uniform vec4 smell_color : source_color = vec4(0.5, 1.0, 0.5, 1.0); // Bright fresh green
uniform float max_radius = 0.5; // How far the scent travels
uniform float particle_density = 60.0; // How packed together the particles are
uniform float twinkle_speed = 4.0; // How fast they blink
uniform float glow_intensity = 2.0; // How bright the particles shine

// Animate this via GDScript just like the lightning!
uniform float progress : hint_range(0.0, 1.0) = 0.0;

// A standard pseudo-random number generator function
float rand(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

void fragment() {
    // 1. Center coordinates (from -0.5 to 0.5)
    vec2 uv = UV - 0.5;
    float radius = length(uv);
    float angle = atan(uv.y, uv.x);

    // 2. Calculate the expanding ring based on progress
    float current_radius = max_radius * progress;
    
    // We want a thick cloud, not a thin line. The cloud expands over time.
    float cloud_thickness = 0.2 * progress; 

    // 3. Create a grid for the particles using our polar coordinates
    // Multiplying by density scales the grid up so we get lots of tiny cells
    vec2 polar_grid = vec2(angle * particle_density, radius * particle_density);

    // 4. Generate random twinkling noise for each cell in the grid
    // floor() ensures each cell gets a solid value, and TIME makes it animate
    float noise = rand(floor(polar_grid) + floor(TIME * twinkle_speed));

    // 5. Turn the noise into sharp, distinct bright dots (the particles)
    // Only noise values between 0.95 and 1.0 become visible
    float particle = smoothstep(0.95, 1.0, noise);

    // 6. Mask the particles so they only appear inside the expanding scent cloud
    float distance_from_center = abs(radius - current_radius);
    float cloud_mask = 1.0 - smoothstep(0.0, cloud_thickness, distance_from_center);

    // 7. Smoothly fade the whole effect in and out
    float fade_in = smoothstep(0.0, 0.1, progress); // Quick fade in
    float fade_out = 1.0 - pow(progress, 3.0);      // Slower fade out at the end
    float overall_fade = fade_in * fade_out;

    // 8. Combine everything for the final alpha
    float final_alpha = particle * cloud_mask * overall_fade * glow_intensity;

    COLOR = vec4(smell_color.rgb, final_alpha * smell_color.a);
}