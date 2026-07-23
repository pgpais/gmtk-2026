class_name Entity
extends Node2D

@onready var grid_map : LayerGridMap = %LayerGridMap 

#region node references
@export var sprite : Sprite2D
@export var animator : AnimationPlayer
#endregion

#region properties
var entity_id : int # important to make combinations (e.g., id 5 + id 9 = instantiate entity with id 14)
enum TEAMS {
	PLAYER,
	ENEMY,
	NEUTRAL,
}
var team = TEAMS.NEUTRAL
var time_to_move : float # to configure the move tween
#endregion

#region state control
@export var hp : int = 10 

var is_busy : bool:
	get: 
		return is_moving and is_attacking
var is_moving : bool = false
var is_attacking : bool = false
#endregion

var current_tile : Tile = null

func _ready() -> void:
	if not current_tile:
		var start_layer = 0 if team == TEAMS.ENEMY else len(grid_map.layers) - 1	
		grid_map.get_random_empty_tile(start_layer) # get a random start tile

func click():
	pass

func trigger():
	pass

# directly move to position
func _set_position(position):
	global_position = position

func _move_to_tile(target_tile):
	var tween = create_tween()
	tween.tween_method(_set_position, current_tile.global_position, target_tile.global_position, time_to_move).set_delay(1.0)
	
func move(x, y):
	if is_moving: # if it's already moving do not move
		return
	
	var new_layer_index = 0
	var new_tile_index = 0
	
	new_layer_index = current_tile.layer._index + x
	new_tile_index = current_tile.tile_index + y
	
	if (new_layer_index < 0 or new_layer_index >= len(grid_map.layers)): # if it's already on the left/right edge
		collide(new_layer_index, new_tile_index) # animation colliding but stays in the same tile
		return
	
	var target_tile = grid_map.get_tile(new_layer_index, current_tile.tile_index)
	
	if not target_tile.entity == null: # tile is occupied
		collide(new_layer_index, new_tile_index) # animation colliding but stays in the same tile	
		return	
	
	_move_to_tile(target_tile)
	current_tile = target_tile # attention: updating current tile before animation is completed

func collide(x, y): # animation colliding with the edge / obstacle but not moving
	pass
	
