extends Node2D

@export var custom_material: ShaderMaterial
@export var audioPlayer: AudioStreamPlayer2D #Highlight_Sound

func _ready():
	set_highlight(false)

func set_highlight(is_highlighted):
	if is_highlighted == false:
		custom_material.set_shader_parameter("aura_width", 0)
		# custom_material.shader_parameter.aura_width = 0
	else:
		custom_material.set_shader_parameter("aura_width", 16)
		audioPlayer.play()
		# custom_material.shader_parameter.aura_width = 4
