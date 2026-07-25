class_name Ally
extends Entity

var banked_actions: Array[ActionSequence]

func _init() -> void:
	team = TEAMS.ALLY

func set_data(data: AllyData):
	entity_data = data

	var visuals = entity_data.scene.instantiate()
	visuals.name = "Visuals"
	add_child(visuals, true)
	animator = visuals.get_node("AnimationPlayer")

func bank_actions(action_sequence: ActionSequence):
	banked_actions.append(action_sequence)

func overwatch_tiles(tiles: Array[Tile]):
	pass

func trigger():
	act()

func act():
	for action_sequence in banked_actions:
		action_handler.perform_actions(action_sequence)
