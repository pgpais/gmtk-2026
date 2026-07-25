shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// --- Wave settings ---
uniform float wave_speed : hint_range(0.0, 5.0) = 1.0;
uniform float wave_frequency : hint_range(0.0, 50.0) = 20.0;
uniform float distortion_strength : hint_range(0.0, 0.05) = 0.01;

// --- Color / transparency settings ---
uniform float tint_strength : hint_range(0.0, 1.0) = 0.35; // how much the ColorRect's color shows through
uniform float base_alpha : hint_range(0.0, 1.0) = 0.6;      // overall transparency of the water

// --- Optional highlight/foam on wave crests ---
uniform vec4 highlight_color : source_color = vec4(1.0, 1.0, 1.0, 0.5);
uniform float highlight_strength : hint_range(0.0, 1.0) = 0.15;

void fragment() {
	// Two overlapping sine waves at different angles/speeds = more natural ripple
	float wave_x = sin(UV.y * wave_frequency + TIME * wave_speed) * distortion_strength;
	float wave_y = cos(UV.x * wave_frequency * 0.8 + TIME * wave_speed * 1.3) * distortion_strength;

	vec2 distorted_uv = SCREEN_UV + vec2(wave_x, wave_y);

	// Sample whatever is rendered behind this ColorRect
	vec4 screen_color = texture(SCREEN_TEXTURE, distorted_uv);

	// COLOR here is the ColorRect's "Color" property (times any modulate)
	vec4 water_color = COLOR;

	// Blend the distorted background with the water's own color
	vec3 final_rgb = mix(screen_color.rgb, water_color.rgb, tint_strength);

	// Add a subtle shimmer/highlight on wave peaks
	float crest = sin((UV.x + UV.y) * wave_frequency + TIME * wave_speed * 1.5);
	crest = smoothstep(0.7, 1.0, crest); // only the very top of the wave
	final_rgb = mix(final_rgb, highlight_color.rgb, crest * highlight_strength);

	COLOR = vec4(final_rgb, water_color.a * base_alpha);
}
