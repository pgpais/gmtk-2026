extends Node2D

@export var custom_material: Material

func set_highlight(is_highlighted):
	if is_highlighted == false:
		custom_material.shader_parameter.aura_width = 0
	else:
		custom_material.shader_parameter.aura_width = 4
