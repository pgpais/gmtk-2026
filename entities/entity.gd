class_name Entity
extends Node2D

@onready var grid_map : LayerGridMap = %LayerGridMap 
signal finished_movement()

#region node references
@export var sprite : Sprite2D
@export var animator : AnimationPlayer
#endregion

#region properties
var entity_id : int # important to make combinations (e.g., id 5 + id 9 = instantiate entity with id 14)
enum TEAMS {
	ALLY,
	ENEMY,
	NEUTRAL,
}
var team = TEAMS.NEUTRAL
## to configure the move tween
var time_to_move : float = 1  
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
@export var movement_strategy: MovementStrategy

func _ready() -> void:
	if not current_tile:
		var start_layer = 0 if team == TEAMS.ENEMY else len(grid_map.columns) - 1	
		current_tile = grid_map.get_random_empty_tile(start_layer) # get a random start tile
		global_position = current_tile.global_position
		current_tile.set_entity(self)

func click():
	pass

func trigger():
	pass

func set_movement_strategy(movement_strategy: MovementStrategy):
	self.movement_strategy = movement_strategy

# directly move to position
func _set_position(position):
	global_position = position

func _move_to_tile(target_tile):
	var tween = create_tween()
	tween.tween_method(_set_position, current_tile.global_position, target_tile.global_position, time_to_move)
	tween.tween_callback(finished_movement.emit)
	
func perform_movement():
	if movement_strategy:
		movement_strategy.move(self)
	else:
		move(1, 0)

func move(x, y):
	var new_layer_index = 0
	var new_tile_index = 0
	
	new_layer_index = current_tile.layer.layer_index + x
	new_tile_index = current_tile.tile_index + y
	
	if (new_layer_index < 0 or new_layer_index >= len(grid_map.columns)): # if it's already on the left/right edge
		collide(new_layer_index, new_tile_index) # animation colliding but stays in the same tile
		return
	
	var target_tile = grid_map.get_tile(new_layer_index, current_tile.tile_index)
	if (new_tile_index < 0 or new_tile_index >= len(grid_map.columns[new_layer_index].tiles)): # if it's already on the top/bottom edge
		collide(new_layer_index, new_tile_index) # animation colliding but stays in the same tile
		return
		
	var target_tile = grid_map.get_tile(new_layer_index, new_tile_index)
	
	if not target_tile.entity == null: # tile is occupied
		collide(new_layer_index, new_tile_index) # animation colliding but stays in the same tile	
		return	
	
	_move_to_tile(target_tile)
	current_tile.set_entity(null)
	current_tile = target_tile # attention: updating current tile before animation is completed
	current_tile.set_entity(self)

func collide(x, y): # animation colliding with the edge / obstacle but not moving
	pass
	
