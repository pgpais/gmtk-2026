@tool
class_name LayerGridMap
extends Node2D

## Maximum number of tiles the map can have
@export var map_size: int = 8:
	set(value):
		map_size = value
		_setup_map()

@export var layer_sizes: Array[int]:
	set(value):
		layer_sizes = value
		if (Engine.is_editor_hint()):
			_setup_map()

var layers: Array[Layer]

func get_layer(index: int) -> Layer:
	return layers[index]

func get_tile(layer_index: int, tile_index: int) -> Tile:
	return layers[layer_index].get_tile(tile_index)

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
	layers = []

	for child in get_children():
		child.queue_free()

	for i in range(layer_sizes.size()):
		var layer = Layer.new()
		var layer_size: int = layer_sizes[i]
			
		layer.name = "Layer"

		add_child(layer, true)
		if (Engine.is_editor_hint()):
			layer.owner = get_tree().edited_scene_root

		layer.position.x = 64 * i + 32
		layer.setup_layer(layer_size, map_size / layer_size)

		layers.append(layer)

	_connect_tiles()

func _connect_tiles():
	for i in range(layers.size() - 1):
		var current_layer = layers[i]
		var tile_number: int = current_layer.number_of_tiles
		for j in range(tile_number):
			var current_tile = current_layer.get_tile(j)
			var next_layer = layers[i + 1]
			var size_ratio = next_layer.number_of_tiles / (current_layer.number_of_tiles * 1.0)
			var next_tile_index: int = j * size_ratio
			var next_tile = next_layer.get_tile(next_tile_index)
			current_tile.next_tile = next_tile
