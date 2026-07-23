@tool
class_name LayerGridMap
extends Node2D

## Maximum number of tiles the map can have
@export var game_settings: GameSettings:
	set(value):
		game_settings = value
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

func get_empty_tiles_in_layer(layer_index: int) -> Array[Tile]:
	return columns[layer_index].get_empty_tiles()

func get_random_empty_tile(layer_index : int) -> Tile:
	var order = range(0, len(layers[layer_index].tiles))
	order.shuffle()
	
	var tile 
	
	for tile_index in order:
		tile = get_tile(layer_index, tile_index)
		if not tile.entity:
			return tile
			
	return null

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
