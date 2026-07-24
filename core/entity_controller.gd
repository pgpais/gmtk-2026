class_name EntityController
extends Node

enum EntityControllerState {WaitingEntitySelection, AbilitySelection, TileSelection}

signal selected_entity_changed(entity: Entity)

signal ability_performed()

@export var selected_entity: Entity

@onready var range_highlighter: RangeHighlighter = RangeHighlighter.instance

@onready var grid_map: LayerGridMap = LayerGridMap.instance

var is_active: bool = true

var state: EntityControllerState = EntityControllerState.WaitingEntitySelection

var is_movement: bool = true
var range_tiles: Array[Tile]

func _ready() -> void:
	EventBus.entity_selected.connect(_on_entity_selected)
	EventBus.tile_selected.connect(_on_tile_selected)
	
func _on_entity_selected(entity: Entity) -> void:
	if !is_active: return
	if state != EntityControllerState.WaitingEntitySelection: return

	print("selected entity: ", entity)
	selected_entity = entity
	selected_entity_changed.emit(entity)

	range_tiles = entity.movement_strategy.tiles_to_highlight(entity, grid_map)
	range_highlighter.show_highlight_tiles(range_tiles)

	_change_to_tile_selection_state()

func _change_to_tile_selection_state() -> void:
	print("change to tile selection state")
	state = EntityControllerState.TileSelection

func _on_tile_selected(tile: Tile) -> void:
	if !is_active: return
	if state != EntityControllerState.TileSelection: return

	
	print("selected tile: ", tile)
	if (tile not in range_tiles):
		_cancel_interaction()
		return
	
	range_highlighter.hide_highlight_tiles(range_tiles)

	if is_movement:
		##TODO: perform movement
		pass
	else:
		##TODO: perform ability
		pass

	ability_performed.emit()
	state = EntityControllerState.WaitingEntitySelection

func _cancel_interaction() -> void:
	range_highlighter.hide_highlight_tiles(range_tiles)
	state = EntityControllerState.WaitingEntitySelection