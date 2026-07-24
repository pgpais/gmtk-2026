extends Sprite2D


func trigger_lightning_strike():
	var mat = material as ShaderMaterial
	if mat:
		# Instantly turn the lightning on full blast
		mat.set_shader_parameter("lightning_alpha", 1.0)
		
		# Use a Tween to quickly fade the electricity out over 0.4 seconds
		var tween = create_tween()
		tween.tween_property(mat, "shader_parameter/lightning_alpha", 0.0, 0.4)\
			 .set_trans(Tween.TRANS_SINE)\
			 .set_ease(Tween.EASE_OUT)

# Optional: A function to make it continuously crackle (e.g., charging up)
func set_charging(is_charging: bool):
	var mat = material as ShaderMaterial
	if mat:
		var target_alpha = 1.0 if is_charging else 0.0
		mat.set_shader_parameter("lightning_alpha", target_alpha)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name== "give_hand":
		set_charging(true)
