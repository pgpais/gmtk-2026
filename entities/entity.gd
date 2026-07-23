@tool
class_name Entity
extends Node2D

# 
#region node references
@export var sprite : Sprite2D
@export var animator : AnimationPlayer
#endregion

#region properties
var entity_id : int # important to make combinations (e.g., id 5 + id 9 = instantiate entity with id 14)
var time_to_move : float # to configure the move tween
#endregion

#region state control
var is_busy : bool:
	get: 
		return is_moving and is_attacking
var is_moving : bool = false
var is_attacking : bool = false
#endregion

var current_tile : Tile

func trigger():
	pass

# directly move to position
func _set_position(position):
	global_position = position

func _move_to_tile(target_tile):
	var tween = create_tween()
	tween.tween_method(_set_position, current_tile.global_position, target_tile.global_position, time_to_move).set_delay(1.0)
	
func move(backwards = false):
	if is_moving: # if it's already moving do not move
		return
		
	if backwards:
		_move_to_tile(current_tile.previous_tile)
		current_tile = current_tile.previous_tile # attention: updating current tile before animation is completed
	else:
		_move_to_tile(current_tile.next_tile)
		current_tile = current_tile.next_tile # attention: updating current tile before animation is completed
