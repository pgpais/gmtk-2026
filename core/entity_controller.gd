class_name EntityController
extends Node

enum EntityControllerState {
	WaitingNextAction, 
	ActionSelection, 
	TileSelection, 
	AllySelection, 
	EnemySelection
}

signal control_entity_changed(entity: Entity)
signal target_entity_changed(entity: Entity)
signal target_tile_changed(tile: Tile)

signal ability_performed()

@export var control_entity: Entity
@export var target_entity: Entity
@export var target_tile: Entity

@onready var range_highlighter: RangeHighlighter = RangeHighlighter.instance

@onready var grid_map: LayerGridMap = LayerGridMap.instance

var is_active: bool = true

var state: EntityControllerState = EntityControllerState.WaitingNextAction

var is_movement: bool = true
var range_tiles: Array[Tile]

func _ready() -> void:
	EventBus.selection_needed.connect(_change_to_selection_state)
	EventBus.movement_needed.connect(_move_control_entity_to_target_tile)
	
	EventBus.entity_selected.connect(_on_entity_selected)
	EventBus.tile_selected.connect(_on_tile_selected)
	
func _change_to_selection_state(target_type, selection_range, highlight_range) -> void:
	if highlight_range:
		pass
		# highlight range
	
	if target_type == ActionStep.TARGET_TYPES.tile:
		_change_to_tile_selection_state()
	elif target_type == ActionStep.TARGET_TYPES.ally:
		_change_to_ally_selection_state()
	elif target_type == ActionStep.TARGET_TYPES.enemy:
		_change_to_enemy_selection_state()

func _move_control_entity_to_target_tile():
	var tile_path : Array[Tile] = grid_map.get_path_of_tiles(control_entity.current_tile, target_tile) 
	control_entity.move(tile_path)

func _change_to_tile_selection_state() -> void:
	print("change to tile selection state")
	state = EntityControllerState.TileSelection
	
func _change_to_ally_selection_state() -> void:
	print("change to ally selection state")
	state = EntityControllerState.AllySelection
	
func _change_to_enemy_selection_state() -> void:
	print("change to enemy selection state")
	state = EntityControllerState.EnemySelection

func _on_entity_selected(entity: Entity) -> void:
	if !is_active: return
	
	if state == EntityControllerState.WaitingNextAction: 
		if entity.team == Entity.TEAMS.ALLY:
			control_entity = entity
			control_entity_changed.emit(entity)
			# show options for that frog
	
	elif state == EntityControllerState.AllySelection:
		if entity.team == Entity.TEAMS.ALLY:
			target_entity = entity
			target_entity_changed.emit(entity)
	
	elif state == EntityControllerState.EnemySelection: 
		if entity.team == Entity.TEAMS.ENEMY:
			target_entity = entity
			target_entity_changed.emit(entity)
			
	else:
		return

	print("selected entity: ", entity)

	range_tiles = entity.movement_strategy.tiles_to_highlight(entity, grid_map)
	range_highlighter.show_highlight_tiles(range_tiles)

	_change_to_tile_selection_state()

func _on_tile_selected(tile: Tile) -> void:
	if !is_active: return
	if state != EntityControllerState.TileSelection: return

	print("selected tile: ", tile)
	
	if (tile not in range_tiles):
		_cancel_interaction()
		return
	
	target_tile_changed.emit(tile)
	
	range_highlighter.hide_highlight_tiles(range_tiles)

	#if is_movement:
		##TODO: perform movement
		#pass
	#else:
		##TODO: perform ability
		#pass

	EventBus.action_step_performed.emit()

	#ability_performed.emit()
	#state = EntityControllerState.WaitingEntitySelection

func _cancel_interaction() -> void:
	range_highlighter.hide_highlight_tiles(range_tiles)
	state = EntityControllerState.WaitingNextAction
