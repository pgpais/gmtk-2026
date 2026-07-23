class_name Enemy
extends Entity

var _enemy_data : EnemyData

@export var ranged : bool # if it attacks at a distance
var range : int

func _ready() -> void:
	team = TEAMS.ENEMY
	super._ready() 

func set_data(data):
	_enemy_data = data

func trigger():
	if ranged:
		for tile in current_tile.tiles_in_range(range):
			if tile.entity.team == TEAMS.ALLY:
				is_attacking = true
	
	if not is_attacking: # if it attacked someone, stop doing actions. else, move
		perform_movement()
