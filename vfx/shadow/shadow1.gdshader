shader_type canvas_item;

// Customize the dark energy vibe
uniform vec4 fume_color : source_color = vec4(0.05, 0.0, 0.1, 0.9); // Deep void color
uniform float fume_speed = 1.5; // How fast the smoke rises
uniform float noise_scale = 8.0; // The size of the smoke clumps
uniform float wavy_distortion = 0.15; // How much the smoke wiggles left and right
uniform float dissolve_intensity = 0.5; // How aggressively it fades into smoke

// 1. A built-in pseudo-random number generator
float random(vec2 uv) {
    return fract(sin(dot(uv.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

// 2. A procedural Value Noise function to create the cloudy smoke texture
float noise(vec2 uv) {
    vec2 i = floor(uv);
    vec2 f = fract(uv);
    f = f * f * (3.0 - 2.0 * f); // Smooth interpolation
    
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

void fragment() {
    // Scroll the coordinates upwards over time to make the smoke rise
    vec2 scroll = vec2(0.0, -TIME * fume_speed);
    
    // Generate the scrolling smoke noise
    float n = noise((UV + scroll) * noise_scale);
    
    // Distort the UV coordinates horizontally based on the noise
    // (1.0 - UV.y) ensures the bottom (feet) stays solid, while the top (head) gets wavy
    vec2 distorted_uv = UV;
    distorted_uv.x += (n - 0.5) * wavy_distortion * (1.0 - UV.y);
    
    // Read the original sprite's transparency using the newly distorted, wavy coordinates
    float texture_alpha = texture(TEXTURE, distorted_uv).a;
    
    // Dissolve the top of the shadow so it breaks apart like real smoke
    // UV.y is 0.0 at the top and 1.0 at the bottom.
    float fade_gradient = UV.y + (n * dissolve_intensity);
    
    // smoothstep creates a harsh cut-off, making it look like wispy tendrils of smoke
    float smoke_alpha = texture_alpha * smoothstep(0.1, 0.6, fade_gradient);
    
    // Output the final fuming color
    COLOR = vec4(fume_color.rgb, smoke_alpha * fume_color.a);
}