class_name Ally
extends Entity

var banked_actions : Array[ActionStrategy]

func _init() -> void:
	team = TEAMS.ALLY

func set_data(data : AllyData):
	entity_data = data

func bank_action(action : ActionStrategy):
	banked_actions.append(action)

func overwatch_tiles(tiles : Array[Tile]):
	pass

func trigger():	
	act()

func act():
	ActionHandler.perform_actions(banked_actions)
