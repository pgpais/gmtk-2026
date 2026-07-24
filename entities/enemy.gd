class_name Enemy
extends Entity

var _enemy_data : EnemyData

@export var ranged : bool # if it attacks at a distance
var range : int

func _ready() -> void:
	team = TEAMS.ENEMY

func set_data(data):
	_enemy_data = data

func trigger():
	var action = get_best_action()
	ActionHandler.perform_action(action)
	
func get_best_action() -> ActionStrategy:
	var best_action = null

	for action : ActionStrategy in possible_actions:
		pass # to do
	
	return best_action
