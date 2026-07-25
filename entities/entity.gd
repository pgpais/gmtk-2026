class_name Entity
extends Node2D

var entity_data: EntityData

@onready var grid_map: LayerGridMap = LayerGridMap.instance
signal finished_movement()
signal animation_finished(animation_name)
signal direction_selected(direction : String)
signal rotated

@export var action_sequence: ActionSequence
@export var action_handler: ActionHandler
@export var _selectable: Selectable

#region node references
#@export var sprite : Sprite2D
@export var animator: AnimationPlayer
#endregion

#region properties
var entity_id: int # important to make combinations (e.g., id 5 + id 9 = instantiate entity with id 14)
enum TEAMS {
	ALLY,
	ENEMY,
	NEUTRAL,
	BEETLE,
}
var team = TEAMS.NEUTRAL
## to configure the move tween
var time_to_move: float = 1
#endregion

#region state control
#@export var hp : int = 10 

var is_busy: bool:
	get:
		return is_moving and is_attacking
var is_moving: bool = false
var is_attacking: bool = false
var is_shock : bool = false
#endregion

var current_tile: Tile = null
@export var movement_strategy: MovementStrategy

func _ready() -> void:
	finished_movement.connect(finish_movement)
	action_handler.set_entity(self)
	#if not current_tile:
		#var start_layer = 0 if team == TEAMS.ENEMY else len(grid_map.columns) - 1	
		#current_tile = grid_map.get_random_empty_tile(start_layer) # get a random start tile
		#global_position = current_tile.global_position
		#current_tile.set_entity(self)

func set_data(data):
	entity_data = data

func set_tile(tile):
	current_tile = tile

# directly move to position
func set_new_position(position):
	global_position = position

	if animator.has_animation("move"):
		animator.play("move")

func move(tile_path):
	if animator.has_animation("move"):
		animator.play("move")
		
	if tile_path.is_empty():
		finished_movement.emit()
		return
	
	for tile in tile_path:
		await _move_to_tile(tile)
		
	if animator.has_animation("idle"):
		animator.play("idle")
	else:
		animator.stop()
	
	finished_movement.emit()
	EventBus.action_step_performed.emit()

func _move_to_tile(target_tile):
	if animator.has_animation("move"):
		animator.play("move")

	var tween = create_tween()
	tween.tween_method(set_new_position, current_tile.global_position, target_tile.global_position, time_to_move)
	await tween.finished
	
	print("checking overwatches at tile ", target_tile.tile_index, ", ", target_tile.column.column_index)
	await target_tile.check_overwatches(self)

	current_tile.set_entity(null)
	current_tile = target_tile # attention: updating current tile before animation is completed
	current_tile.set_entity(self)

func perform_movement():
	if movement_strategy:
		movement_strategy.move(self)
	elif team == TEAMS.ENEMY:
		_move(-1, 0)
	elif team == TEAMS.ALLY:
		_move(1, 0)

func _move(x, y):
	var new_layer_index = 0
	var new_tile_index = 0
	
	new_layer_index = current_tile.column.column_index + x
	new_tile_index = current_tile.tile_index + y
	
	if (new_layer_index < 0 or new_layer_index >= len(grid_map.columns)): # if it's already on the left/right edge
		collide(new_layer_index, new_tile_index) # animation colliding but stays in the same tile
		return
	
	if (new_tile_index < 0 or new_tile_index >= len(grid_map.columns[new_layer_index].tiles)): # if it's already on the top/bottom edge
		collide(new_layer_index, new_tile_index) # animation colliding but stays in the same tile
		return
		
	var target_tile = grid_map.get_tile(new_layer_index, new_tile_index)
	
	if not target_tile.entity == null: # tile is occupied
		collide(new_layer_index, new_tile_index) # animation colliding but stays in the same tile
		return
	
	await _move_to_tile(target_tile)
	
	finished_movement.emit()

func finish_movement():
	if animator.has_animation("idle"):
		animator.play("idle")
	else:
		animator.stop()

func rotate_to_direction(direction : String):
	#might change to play an animation?
	match direction:
		"up":
			scale = Vector2(1,1)
			rotation = -70
		"right":
			scale = Vector2(1,1)
			rotation = 0
		"down":
			scale = Vector2(1,1)
			rotation = 105
		"left":
			scale = Vector2(-1,1)
			rotation = 0
			
	rotated.emit() # to accomodate the possibility of only finishing when animation finishes

func shock(toggle):
	is_shock = toggle
	modulate = Color.AQUAMARINE if toggle else Color.WHITE

func shoot_at(tile_position : Vector2):
	var target_tile = grid_map.get_tile(tile_position.x, tile_position.y)
	
	var entity_on_tile = target_tile.entity
	
	var valid_target = (entity_on_tile
					and ((team == Entity.TEAMS.ALLY and entity_on_tile.team == Entity.TEAMS.ENEMY) 
					or (team == Entity.TEAMS.ENEMY and entity_on_tile.team == Entity.TEAMS.ALLY)))
	
	if valid_target:
		entity_on_tile.die()
		
func die():
	# to do
	modulate = Color.RED
	queue_free()
	print("entity ", name, " died - IT WAS DELETED FROM THE SCENE")

func pop_direction_buttons(toggle):
	current_tile.pop_direction_buttons(toggle)

func collide(x, y): # animation colliding with the edge / obstacle but not moving
	finished_movement.emit()

func trigger():
	pass
	
func act():
	pass

func play_animation(animation, backwards = false):
	if animator.has_animation(animation):
		if ! backwards:
			animator.play(animation)
		else:
			animator.play_backwards(animation)

		while (true):
			var finished_animation = await animator.animation_finished
			if finished_animation == animation:
				animation_finished.emit(animation)
				break;
	else:
		print("Animation not found: " + animation)

func set_selectable(is_selectable: bool):
	_selectable.set_selectable(is_selectable)
