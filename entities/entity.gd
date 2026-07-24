class_name Entity
extends Node2D

var entity_data : EntityData

@onready var grid_map : LayerGridMap = LayerGridMap.instance
signal finished_movement()

@export var possible_actions : Array[ActionStrategy]

#region node references
#@export var sprite : Sprite2D
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
var is_busy : bool:
	get: 
		return is_moving and is_attacking
var is_moving : bool = false
var is_attacking : bool = false
#endregion

var current_tile : Tile = null

func set_data(data):
	entity_data = data

func set_tile(tile):
	current_tile = tile

func add_new_possible_action(action: ActionStrategy):
	self.possible_actions.append(action)

# directly move to position
func set_new_position(position):
	global_position = position

func move(tile_path):
	if animator.has_animation("move"):
		animator.play("move")
		
	if tile_path.is_empty():
		finished_movement.emit()
		return
	
	for tile in tile_path:
		await move_to_tile(tile, true)
		
	if animator.has_animation("idle"):
		animator.play("idle")
	else:
		animator.stop()
	
	finished_movement.emit()
	EventBus.action_step_performed.emit()

func move_to_tile(tile : Tile, compound_movement : bool = false):
	if !compound_movement:
		if animator.has_animation("move"):
			animator.play("move")
	
	var current_pos = current_tile.global_position
	
	var tween = create_tween()
	tween.tween_method(set_new_position, current_pos, tile.global_position, time_to_move)
	
	await tween.finished
	
	if global_position != tile.global_position:
		global_position = tile.global_position

	if current_tile != null:
		current_tile.set_entity(null)
	current_tile = tile
	current_tile.set_entity(self)
	
	if !compound_movement:
		if animator.has_animation("idle"):
			animator.play("idle")
		else:
			animator.stop()

func collide(x, y): # animation colliding with the edge / obstacle but not moving
	pass

func trigger():
	pass
	
func act():
	pass
