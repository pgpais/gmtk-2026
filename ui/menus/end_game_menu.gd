extends Control

@export var title_text: Label
@export var replay_button: Button
@export var main_menu_button: Button
@export var quit_button: Button
@onready var main_menu_scene: PackedScene = preload("uid://cr2odqe6nec73")

func _ready() -> void:
	EventBus.game_ended.connect(_on_game_ended)

	replay_button.pressed.connect(_on_replay_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	quit_button.pressed.connect(get_tree().quit)

	self.visible = false

func _on_game_ended(win: bool):
	visible = true

	if win:
		title_text.text = "YOU WIN!"
	else:
		title_text.text = "YOU LOSE!"

func _on_replay_pressed():
	get_tree().reload_current_scene()

func _on_main_menu_pressed():
	get_tree().change_scene_to_packed(main_menu_scene)
