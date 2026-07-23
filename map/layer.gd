@tool
## map/layer.gd
class_name Layer
extends Node2D

@export var tile_scene: PackedScene = preload("uid://bmifyrtst83yc")

## Number of tiles in this layer
@export var number_of_tiles: int

@export var tile_size_multiplier: int


var tiles: Array[Tile]

func get_tile(index: int) -> Tile:
	return tiles[index]

func setup_layer(number_of_tiles: int, tile_size_multiplier: int):
	self.number_of_tiles = number_of_tiles
	self.tile_size_multiplier = tile_size_multiplier

	for child in get_children():
		child.queue_free()

	for i in number_of_tiles:
		var tile: Tile = tile_scene.instantiate()
		add_child(tile, true)
		tiles.append(tile)
		tile.owner = get_tree().edited_scene_root
		tile.tile_size_multiplier = tile_size_multiplier
		tile.initialize(self, i)