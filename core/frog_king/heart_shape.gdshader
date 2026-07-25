shader_type canvas_item;

// Assign this shader in: GPUParticles2D -> CanvasItem -> Material -> New ShaderMaterial
// (this is the node's regular "Material" property, not the Process Material)

uniform vec4 heart_color : source_color = vec4(1.0, 0.25, 0.45, 1.0);
uniform vec4 glow_color : source_color = vec4(1.0, 0.6, 0.75, 1.0);
uniform float glow_amount : hint_range(0.0, 1.0) = 0.5;
uniform float pulse_speed : hint_range(0.0, 10.0) = 2.0;
uniform float pulse_strength : hint_range(0.0, 0.5) = 0.08;

// Signed distance to a heart shape (2D), origin roughly centered
float sd_heart(vec2 p) {
	p.x = abs(p.x);
	if (p.y + p.x > 1.0) {
		vec2 d = p - vec2(0.25, 0.75);
		return sqrt(dot(d, d)) - sqrt(2.0) / 4.0;
	}
	vec2 a = p - vec2(0.0, 1.0);
	vec2 b = p - 0.5 * max(p.x + p.y, 0.0);
	return sqrt(min(dot(a, a), dot(b, b))) * sign(p.x - p.y);
}

void fragment() {
	vec2 uv = (UV - 0.5) * 2.4;
	uv.y = -uv.y + 0.35; // flip Y and recenter (heart formula sits low in its own space)

	float pulse = 1.0 + sin(TIME * pulse_speed) * pulse_strength;
	uv /= pulse;

	float d = sd_heart(uv);

	float shape = 1.0 - smoothstep(0.0, 0.04, d);
	float glow = 1.0 - smoothstep(0.0, 0.6, d);

	vec3 col = mix(glow_color.rgb, heart_color.rgb, shape);
	float alpha = max(shape, glow * glow_amount * 0.6);

	COLOR = vec4(col, alpha) * COLOR.a; // COLOR.a carries the particle's fade from the process shader
}
