class_name Ally
extends Entity

var _ally_data : AllyData

@export var ranged : bool # if it attacks at a distance
var range : int

func _ready() -> void:
	team = TEAMS.ALLY
	super._ready()

func set_data(data):
	_ally_data = data

func trigger():
	if ranged:
		for tile in current_tile.tiles_in_range(range):
			if tile.entity.team == TEAMS.ALLY:
				is_attacking = true
	
	if not is_attacking: # if it attacked someone, stop doing actions. else, move
		move(-1, 0)
