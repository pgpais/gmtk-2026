extends Control

@export var victory_menu: Control
@export var defeat_menu: Control

@export var quit_button: Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	quit_button.pressed.connect(get_tree().quit)

	EventBus.game_ended.connect(_on_game_ended)

func _on_game_ended(win: bool):
	visible = true

	if win:
		victory_menu.show()
		defeat_menu.hide()
	else:
		defeat_menu.show()
		victory_menu.hide()
