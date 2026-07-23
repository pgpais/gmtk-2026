@tool
extends Node2D

## Maximum number of tiles the map can have
@export var map_size: int = 8:
	set(value):
		map_size = value
		_setup_map()

@export var layers: Array[int]:
	set(value):
		layers = value
		_setup_map()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_map()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _setup_map():
	for child in get_children():
		child.queue_free()

	for i in range(layers.size()):
		var layer = Layer.new()
		var layer_size: int = layers[i]
			
		layer.name = "Layer"
		add_child(layer, true)
		layer.owner = get_tree().edited_scene_root
		layer.position.x = 64 * i + 32
		layer.number_of_tiles = layer_size
		layer.tile_size_multiplier = map_size / layer_size
