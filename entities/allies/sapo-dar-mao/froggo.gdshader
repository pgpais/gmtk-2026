shader_type canvas_item;

uniform vec4 lightning_color : source_color = vec4(0.3, 0.8, 1.0, 1.0);
uniform float speed = 8.0;         // SLOWED DOWN: Easier to follow
uniform float jaggedness = 5.0;    // SIMPLIFIED: Bigger, slower curves instead of chaotic noise
uniform float thickness = 0.04;    // Thicker, heavier core
uniform float glow = 0.2;
uniform float power = 1.5;         // Strong brightness, but stable
uniform float lightning_alpha : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    vec4 original_color = texture(TEXTURE, UV);
    
    // Slower, smoother movement
    float time_offset = TIME * speed;
    
    // A single, heavy bolt that sways smoothly
    float offset = sin(UV.y * jaggedness - time_offset) * 0.15
                 + sin(UV.y * jaggedness * 2.5 + time_offset * 1.2) * 0.05;

    float dist = abs(UV.x - 0.5 + offset);
    
    // NEW: Make the lightning "breathe" or pulse in thickness, rather than flickering brightness.
    // This makes it feel like it's surging with heavy power.
    float pulse = sin(TIME * 12.0) * 0.015;
    
    float core = 1.0 - smoothstep(0.0, thickness + pulse, dist);
    float halo = 1.0 - smoothstep(0.0, glow + (pulse * 2.0), dist);
    
    // Combine core and halo
    float intensity = (core * 1.5 + halo) * lightning_alpha * power;
    
    // Mask edges so it doesn't cut off sharply
    float mask = smoothstep(0.0, 0.1, UV.y) * smoothstep(1.0, 0.9, UV.y);
    intensity *= mask;
    
    // Keep the white-hot core for that dangerous look
    vec3 hot_core_color = mix(lightning_color.rgb, vec3(1.0, 1.0, 1.0), core);
    
    vec4 final_color = original_color;
    final_color.rgb += hot_core_color * (intensity * original_color.a);
    
    COLOR = final_color;
}