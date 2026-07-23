@tool
extends Node2D

@export var number_of_layers: int = 2:
	set(value):
		number_of_layers = value
		_setup_map()
@export var starting_number_of_tiles: int = 2:
	set(value):
		starting_number_of_tiles = value
		_setup_map()
@export var tile_size_multiplier: int = 2:
	set(value):
		tile_size_multiplier = value
		_setup_map()

@export var

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_setup_map()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _setup_map():
	for child in get_children():
		child.queue_free()

	for i in number_of_layers:
		var layer = Layer.new()
		var number_of_tiles: float

		number_of_tiles = starting_number_of_tiles / pow(2, i)
		print(number_of_tiles)

		if number_of_tiles < 1:
			printerr("Too many layers")
			break
			
		layer.name = "Layer"
		add_child(layer, true)
		layer.owner = get_tree().edited_scene_root
		layer.position.x = 64 * i + 32
		layer.number_of_tiles = number_of_tiles
		layer.tile_size_multiplier = pow(2, i)
