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
var power : int = 1
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

var visuals: Node2D
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

func set_data(data, hidden = false):
	entity_data = data
	play_animation("spawn")

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

func _move_to_tile(target_tile: Tile):
	target_tile.show_positive_highlight()
	if animator.has_animation("move"):
		animator.play("move")

	var tween = create_tween()
	tween.tween_method(set_new_position, current_tile.global_position, target_tile.global_position, time_to_move)
	await tween.finished

	target_tile.hide_positive_highlight()
	
	if target_tile.entity and target_tile.entity.is_shock:
		await die()
	else:
		print("checking overwatches at tile ", target_tile.tile_index, ", ", target_tile.column.column_index)
		await target_tile.check_overwatches(self)
	
	if target_tile.entity:
		await target_tile.entity.die()

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
	clear_overwatches()

	var new_layer_index = 0
	var new_tile_index = 0
	
	new_layer_index = current_tile.column.column_index + x
	new_tile_index = current_tile.tile_index + y
	
	if (new_layer_index < 0):
		# Next to frog king
		# TODO: play frog king attack animation
		EventBus.enemy_attacked_frog_king.emit(self)
		#action_handler.reset()
		#finished_movement.emit()
		queue_free()
		return true
	
	if (new_layer_index >= len(grid_map.columns)): # if it's already on the left/right edge
		collide(new_layer_index, new_tile_index) # animation colliding but stays in the same tile
		return false
	
	if (new_tile_index < 0 or new_tile_index >= len(grid_map.columns[new_layer_index].tiles)): # if it's already on the top/bottom edge
		collide(new_layer_index, new_tile_index) # animation colliding but stays in the same tile
		return false
		
	var target_tile = grid_map.get_tile(new_layer_index, new_tile_index)
	
	var will_collide_with_entity : bool = not target_tile.entity == null
	
	if will_collide_with_entity and team == target_tile.entity:
		if team == TEAMS.ALLY:
			return false
		elif team == TEAMS.ENEMY:
			#TODO CASCADING EFFECT
			if ! target_tile.entity._move(x, y):
				return false
	
	await _move_to_tile(target_tile)
	
	finished_movement.emit()
	
	return true

func finish_movement():
	if animator.has_animation("idle"):
		animator.play("idle")
	else:
		animator.stop()

func rotate_to_direction(direction_vector : Vector2):
	#might change to play an animation?
	if direction_vector.is_zero_approx():
		return
		
	var target_angle = snapped(direction_vector.angle(), PI / 4.0)
	
	rotation = target_angle
	
	if abs(target_angle) > PI / 2.0:
		scale.y = -1
	else:
		scale.y = 1
	
	rotated.emit() # to accomodate the possibility of only finishing when animation finishes

func shock(toggle):
	is_shock = toggle
	play_animation("shock")
	modulate = Color.AQUAMARINE if toggle else Color.WHITE

func shoot_at(tile_position : Vector2):
	var target_tile = grid_map.get_tile(tile_position.x, tile_position.y)
	var entity_on_tile = target_tile.entity
	
	play_animation("leek")
	
	if entity_on_tile:
		if entity_on_tile.is_shock:
			await die()
	
	var valid_target = team != entity_on_tile.team and entity_on_tile.team != TEAMS.BEETLE 
	
	if valid_target:
		await kill_other_entity(entity_on_tile)
		power_action()
	else:
		# fails
		# super hard coded! careful
		reset_power()
		action_handler._finish_performing()
		
	play_animation("leek", true)

func reset_power():
	power = 1
	entity_data.action_sequence.actions = entity_data.action_sequence.actions.slice(0, 1)

func power_action():
	power += 1
	entity_data.action_sequence.actions.append(entity_data.action_sequence.actions[0])

func kill_other_entity(entity : Entity):
	await entity.die()

func die():
	clear_overwatches()
	await play_animation("dismiss")
	current_tile.set_entity(null)
	queue_free()

func pop_direction_buttons(toggle):
	current_tile.pop_direction_buttons(toggle)

func collide(x, y): # animation colliding with the edge / obstacle but not moving
	finished_movement.emit()

func trigger():
	pass

func play_animation(animation, backwards = false):
	animator.play("RESET")
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

func clear_overwatches():
	var overwatches = grid_map.get_overwatches_of_entity(self)
	for overwatch in overwatches:
			overwatch.tile.remove_overwatch(overwatch)

func set_highlight(is_highlighted):
	if visuals.has_method("set_highlight"):
		visuals.set_highlight(is_highlighted)
