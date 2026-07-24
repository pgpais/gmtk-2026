@tool
class_name LayerGridMap
extends Node2D

static var instance : LayerGridMap

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
	instance = self
	
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

func get_tiles_in_ability_range(ability_range: AbilityRange, starting_tile: Tile) -> Array[Tile]:
	var tile_position: Vector2 = Vector2(starting_tile.layer.layer_index, starting_tile.tile_index)

	var tiles: Array[Tile] = []
	
	if ability_range.range_type == AbilityRange.range_types.distance:
		pass
	
	elif ability_range.range_type == AbilityRange.range_types.directional:

		for i in range(ability_range.left_min_range, ability_range.left_max_range + 1):
			var tile = get_tile(tile_position.x - i, tile_position.y)
			if tile:
				tiles.append(tile)
		
		for i in range(ability_range.right_min_range, ability_range.right_max_range + 1):
			var tile = get_tile(tile_position.x + i, tile_position.y)
			if tile:
				tiles.append(tile)
		
		for i in range(ability_range.up_min_range, ability_range.up_max_range + 1):
			var tile = get_tile(tile_position.x, tile_position.y + i)
			if tile:
				tiles.append(tile)
		
		for i in range(ability_range.down_min_range, ability_range.down_max_range + 1):
			var tile = get_tile(tile_position.x, tile_position.y - i)
			if tile:
				tiles.append(tile)

		for i in range(ability_range.top_left_min_range, ability_range.top_left_max_range + 1):
			var tile = get_tile(tile_position.x - i, tile_position.y + i)
			if tile:
				tiles.append(tile)
		
		for i in range(ability_range.top_right_min_range, ability_range.top_right_max_range + 1):
			var tile = get_tile(tile_position.x + i, tile_position.y + i)
			if tile:
				tiles.append(tile)
		
		for i in range(ability_range.bottom_left_min_range, ability_range.bottom_left_max_range + 1):
			var tile = get_tile(tile_position.x - i, tile_position.y - i)
			if tile:
				tiles.append(tile)
		
		for i in range(ability_range.bottom_right_min_range, ability_range.bottom_right_max_range + 1):
			var tile = get_tile(tile_position.x + i, tile_position.y - i)
			if tile:
				tiles.append(tile)
	
	elif ability_range.range_type == AbilityRange.range_types.path:
		pass
	
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

func get_tile_path(current_tile : Tile, target_tile : Tile, include_target : bool = true) -> Array[Tile]:
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
	if (!Engine.is_editor_hint() || Engine.is_editor_hint() && get_tree().current_scene == self):
		columns = []

		for child in get_children():
			child.queue_free()

		for i in range(map_size):
			var mapColumn = MapColumn.new()
			var layer_size: int = tiles_per_column
				
			mapColumn.name = "MapColumn"

			if (!Engine.is_editor_hint() || Engine.is_editor_hint() && get_tree().current_scene == self):
				add_child(mapColumn, true)
				mapColumn.owner = self;
				columns.append(mapColumn)
			
			mapColumn.position.x = game_settings.tile_size.x * i + game_settings.tile_size.x / 2
			mapColumn.setup_layer(layer_size, i)

func _on_new_tick(count: int):
	var layer = columns[count]
	layer.trigger_tiles()
