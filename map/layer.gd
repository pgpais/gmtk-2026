@tool
## map/layer.gd
class_name Layer
extends Node2D

@export var tile_scene: PackedScene = preload("uid://bmifyrtst83yc")

@export var number_of_tiles: int:
	set(value):
		number_of_tiles = value
		_setup_layer()

@export var tile_size_multiplier: int:
	set(value):
		tile_size_multiplier = value
		_setup_layer()


var tiles: Array[Tile]

func init_layer(number_of_tiles: int, tile_size_multiplier: int):
	self.number_of_tiles = number_of_tiles
	self.tile_size_multiplier = tile_size_multiplier

func _ready() -> void:
	_setup_layer()

func _setup_layer():
	if not tile_scene:
		return

	for child in get_children():
		child.queue_free()

	for i in number_of_tiles:
		var tile = tile_scene.instantiate()
		add_child(tile, true)
		tile.owner = get_tree().edited_scene_root
		tile.tile_size_multiplier = tile_size_multiplier
		tile.tile_index = i
