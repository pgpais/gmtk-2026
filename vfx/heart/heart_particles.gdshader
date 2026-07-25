shader_type particles;

uniform float upward_speed : hint_range(10.0, 300.0) = 60.0;
uniform float sway_amount : hint_range(0.0, 100.0) = 25.0;
uniform float sway_speed : hint_range(0.1, 5.0) = 1.5;
uniform float fade_in : hint_range(0.0, 1.0) = 0.15;   // fraction of lifetime spent fading in
uniform float fade_out_start : hint_range(0.0, 1.0) = 0.7; // fraction of lifetime where fade-out begins
uniform float start_scale : hint_range(0.1, 2.0) = 0.6;
uniform float end_scale : hint_range(0.1, 2.0) = 1.0;

void start() {
	CUSTOM.y = 0.0; // normalized age (0 -> 1 over lifetime)
	CUSTOM.z = float(NUMBER) * 12.9898; // per-particle random phase for sway
	VELOCITY = vec3(0.0, -upward_speed, 0.0); // negative Y = up in 2D
}

void process() {
	if (RESTART) {
		CUSTOM.y = 0.0;
		CUSTOM.z = float(NUMBER) * 12.9898;
		VELOCITY = vec3(0.0, -upward_speed, 0.0);
	}

	CUSTOM.y += DELTA / LIFETIME;
	float age = CUSTOM.y;

	// gentle left-right sway as it rises
	float sway = sin(CUSTOM.z + TIME * sway_speed) * sway_amount * DELTA;
	TRANSFORM[3].x += sway;
	TRANSFORM[3].y += VELOCITY.y * DELTA;

	// fade in, hold, then fade out near end of life
	float alpha = smoothstep(0.0, fade_in, age) * (1.0 - smoothstep(fade_out_start, 1.0, age));
	COLOR.a = alpha;

	// slight grow-then-settle scale
	float scale = mix(start_scale, end_scale, smoothstep(0.0, 0.3, age));
	TRANSFORM[0].xyz = normalize(TRANSFORM[0].xyz) * scale;
	TRANSFORM[1].xyz = normalize(TRANSFORM[1].xyz) * scale;

	if (age >= 1.0) {
		ACTIVE = false;
	}
}
