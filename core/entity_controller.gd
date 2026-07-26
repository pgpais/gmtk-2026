class_name EntityController
extends Node

enum EntityControllerState {
	WaitingNextAction,
	ActionSelection,
	TileSelection,
	AllySelection,
	EnemySelection,
	ActionPerformed
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
var selectable_entities: Array[Entity] = []
var range_tiles: Array[Tile]

func _ready() -> void:
	EventBus.tick_triggers_finished.connect(_change_to_action_selection_state)
	EventBus.ticker_new_tick.connect(_disable_all_selections)

	EventBus.request_highlight.connect(_change_to_selection_state)
	EventBus.movement_needed.connect(_move_control_entity_to_target_tile)
	
	EventBus.entity_selected.connect(_on_entity_selected)
	EventBus.tile_selected.connect(_on_tile_selected)
	
func _change_to_selection_state(target_type, selection_range, reference_tile, team, highlight) -> void:
	var range_tiles = grid_map.get_tiles_in_range(selection_range, reference_tile)
	var valid_tiles = grid_map.get_valid_tiles(target_type, selection_range, reference_tile, team)
	
	if valid_tiles.is_empty():
		return
	
	for tile in range_tiles:
		if tile in valid_tiles:
			tile.selectable.set_selectable(true)
			if highlight:
				range_highlighter.highlight_tile(tile, true)
		else:
			if highlight:
				range_highlighter.darken_tile(tile)
	
	for selectable_entity in selectable_entities:
		if selectable_entity:
			selectable_entity.set_selectable(false)

	selectable_entities = []
		
	if target_type == Constants.TARGET_TYPES.TILE:
		_change_to_tile_selection_state()
	elif target_type == Constants.TARGET_TYPES.ENTITY:
		_change_to_ally_selection_state()
	elif target_type == Constants.ENTITY_TYPES.ENEMY:
		_change_to_enemy_selection_state()

func _move_control_entity_to_target_tile():
	var tile_path: Array[Tile] = grid_map.get_path_of_tiles(control_entity.current_tile, target_tile)
	control_entity.move(tile_path)

func _change_to_tile_selection_state() -> void:
	print("change to tile selection state")
	state = EntityControllerState.TileSelection
	
	for selectable_entity in selectable_entities:
		if selectable_entity:
			selectable_entity.set_selectable(false)

	selectable_entities = []
	
func _change_to_ally_selection_state() -> void:
	print("change to ally selection state")
	state = EntityControllerState.AllySelection
	
func _change_to_enemy_selection_state() -> void:
	print("change to enemy selection state")
	state = EntityControllerState.EnemySelection

func _change_to_action_selection_state() -> void:
	print("change to action selection state")
	state = EntityControllerState.WaitingNextAction

	var allies = get_tree().get_nodes_in_group("allies")

	for ally in allies:
		ally.set_selectable(true)
		selectable_entities.append(ally)

func _change_to_action_performed_state() -> void:
	print("change to action performed state")
	state = EntityControllerState.ActionPerformed

func _on_entity_selected(entity: Entity) -> void:
	if !is_active: return
	
	if state == EntityControllerState.WaitingNextAction:
		if entity.team == Entity.TEAMS.NEUTRAL:
			entity.activate(true)
			entity.set_selectable(false)
			
		elif entity.team == Entity.TEAMS.ALLY:
			EventBus.ally_selected.emit(entity)
	
	elif state == EntityControllerState.AllySelection:
		if entity.team == Entity.TEAMS.ALLY:
			target_entity = entity
			target_entity_changed.emit(entity)
	
	elif state == EntityControllerState.EnemySelection:
		if entity.team == Entity.TEAMS.ENEMY:
			target_entity = entity
			target_entity_changed.emit(entity)
			
	else:
		_cancel_interaction()
		return

	# _change_to_tile_selection_state()

func _on_tile_selected(tile: Tile) -> void:
	if !is_active: return
	if state != EntityControllerState.TileSelection: return

	print("selected tile: ", tile)
	
	if (tile not in range_tiles):
		_cancel_interaction()
		return
	
	target_tile_changed.emit(tile)
	
	range_highlighter.hide_highlight_tiles(range_tiles)
	
	grid_map.make_all_tiles_not_selectable()
		
	EventBus.player_action_performed.emit()

	#ability_performed.emit()

	_change_to_action_performed_state()

	
func _cancel_interaction() -> void:
	range_highlighter.hide_highlight_tiles(range_tiles)

	state = EntityControllerState.WaitingNextAction

func _disable_all_selections(count: int) -> void:
	var allies = get_tree().get_nodes_in_group("allies")
	for ally in allies:
		ally.set_selectable(false)
