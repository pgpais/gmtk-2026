@tool
class_name LayerGridMap
extends Node2D

## Maximum number of tiles the map can have
@export var game_settings: GameSettings:
	set(value):
		game_settings = value
		map_size = game_settings.map_columns
		tiles_per_column = game_settings.tiles_per_column
		_setup_map()
		
var map_size: int = 8
var tiles_per_column: int = 8
var columns: Array[MapColumn]


func _ready() -> void:
	_setup_map()
	
	EventBus.ticker_new_tick.connect(_on_new_tick)

func get_layer(index: int) -> MapColumn:
	return columns[index]

func get_tile(layer_index: int, tile_index: int) -> Tile:
	return columns[layer_index].get_tile(tile_index)

func get_empty_tiles_in_column(layer_index: int) -> Array[Tile]:
	return columns[layer_index].get_empty_tiles()

## Gets all tiles in range. Range is calculated as a straight line distance from the starting tile
func get_tiles_in_range(range_distance: Vector2, starting_tile: Tile) -> Array[Tile]:
	var result: Array[Tile] = []

	var tilePosition: Vector2 = Vector2(starting_tile.layer.layer_index, starting_tile.tile_index)
	for i in range(1, range_distance.x + 1):
		result.append(get_tile(tilePosition.x + i, tilePosition.y))
		result.append(get_tile(tilePosition.x - i, tilePosition.y))

	for i in range(1, range_distance.y + 1):
		result.append(get_tile(tilePosition.x, tilePosition.y + i))
		result.append(get_tile(tilePosition.x, tilePosition.y - i))

	return result


func _setup_map():
	columns = []

	for child in get_children():
		child.queue_free()

	for i in range(map_size):
		var mapColumn = MapColumn.new()
		var layer_size: int = tiles_per_column
			
		mapColumn.name = "MapColumn"

		add_child(mapColumn, true)
		if (Engine.is_editor_hint()):
			mapColumn.owner = get_tree().edited_scene_root
		columns.append(mapColumn)
		
		mapColumn.position.x = game_settings.tile_size.x * i + game_settings.tile_size.x / 2
		mapColumn.setup_layer(layer_size, i)

func _on_new_tick(count: int):
	var layer = columns[count]
	layer.trigger_tiles()
