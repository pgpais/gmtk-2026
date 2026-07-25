@tool
class_name LayerGridMap
extends Node2D

static var instance: LayerGridMap

@export_tool_button("Recreate map") var recreate_map = _setup_map

## Maximum number of tiles the map can have
@export var game_settings: GameSettings:
	set(value):
		game_settings = value
		_setup_map()
var columns: Array[MapColumn]


func _ready() -> void:
	instance = self
	
	_setup_map()
	
	EventBus.ticker_new_tick.connect(_on_new_tick)

func get_layer(index: int) -> MapColumn:
	return columns[index]

func get_tile(layer_index: int, tile_index: int) -> Tile:
	if layer_index >= len(columns) or tile_index >= len(columns[layer_index].tiles) or layer_index < 0 or tile_index < 0:
		return null
	return columns[layer_index].get_tile(tile_index)

func get_tile_coordinates(tile: Tile) -> Vector2i:
	return Vector2i(tile.layer.layer_index, tile.tile_index)

func get_empty_tiles_in_column(layer_index: int) -> Array[Tile]:
	return columns[layer_index].get_empty_tiles()

func get_tiles_in_range(ability_range: AbilityRange, reference_tile: Tile) -> Array[Tile]:
	var tiles: Array[Tile] = []
	var base_position = Vector2i(reference_tile.layer.layer_index, reference_tile.tile_index)
	
	for pattern in ability_range.patterns:
		var direction = pattern.get_direction_vector()
		var directions = [direction]

		if pattern.mirror:
			directions.append(-direction)

		for dir in directions:
			for i in range(0, pattern.distance + 1):
				var tile_position = base_position + dir * pattern.area_grid * i
				tiles.append_array(_get_tiles_in_pattern(tile_position, pattern))
	
	return tiles

func _get_tiles_in_pattern(position: Vector2i, pattern) -> Array[Tile]:
	var tiles: Array[Tile] = []
	
	for x in range(pattern.area_grid.x):
		for y in range(pattern.area_grid.y):
			var tile = get_tile(position.x + x + pattern.offset.x, position.y + y + pattern.offset.y)

			if tile:
				tiles.append(tile)
	
	return tiles

func get_random_empty_tile(layer_index: int) -> Tile:
	var order = range(0, len(columns[layer_index].tiles))
	order.shuffle()
	
	var tile
	
	for tile_index in order:
		tile = get_tile(layer_index, tile_index)
		if not tile.entity:
			return tile
			
	return null

func get_tile_path(current_tile: Tile, target_tile: Tile, include_target: bool = true) -> Array[Tile]:
	var path = []
	
	var current_x = current_tile.layer.layer_index
	var current_y = current_tile.tile.tile_index
	
	var target_x = target_tile.layer.layer_index
	var target_y = target_tile.tile.tile_index
	
	while current_x != target_x or current_y != target_y:
		current_x += sign(target_x - current_x)
		current_y += sign(target_y - current_y)
		
		var next_tile = get_tile(current_x, current_y)
		path.append(next_tile)
	
	if include_target:
		path.append(target_tile)
	
	return path

func _setup_map():
	if (!Engine.is_editor_hint() || Engine.is_editor_hint() && get_tree().edited_scene_root == self):
		print("setup map")
		columns = []

		for child in get_children():
			child.queue_free()

		for i in range(game_settings.map_columns):
			var mapColumn = MapColumn.new()
			var layer_size: int = game_settings.tiles_per_column
				
			mapColumn.name = "MapColumn"

			if (!Engine.is_editor_hint() || Engine.is_editor_hint() && get_tree().edited_scene_root == self):
				add_child(mapColumn, true)
				mapColumn.owner = self;
				columns.append(mapColumn)
			
			mapColumn.position.x = game_settings.tile_size.x * i + game_settings.tile_size.x / 2
			mapColumn.setup_layer(layer_size, i, game_settings.tile_size)

func _on_new_tick(count: int):
	var layer = columns[count]
	layer.trigger_tiles()
