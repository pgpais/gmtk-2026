extends Control

@export var start_button: Button
@export var quit_button: Button
@export var game_scene: PackedScene

func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)
	quit_button.pressed.connect(get_tree().quit)

func _on_start_pressed():
	get_tree().change_scene_to_packed(game_scene)