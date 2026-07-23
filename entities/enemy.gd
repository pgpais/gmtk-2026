class_name Enemy
extends Entity

var ranged : bool # if it attacks at a distance
var range : int 

func spawn():
	team = TEAMS.ENEMY
	# TO DO

func trigger():
	if ranged:
		for tile in current_tile.tiles_in_range(range):
			if tile.entity.team == TEAMS.PLAYER:
				is_attacking = true
	
	if not is_attacking: # if it attacked someone, stop doing actions. else, move
		move(1, 0)
