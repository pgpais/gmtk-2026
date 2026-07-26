@tool
class_name LayerGridMap
extends Node2D

static var instance: LayerGridMap

@export_tool_button("Recreate map") var recreate_map = _setup_map

@export var game_settings: GameSettings:
	set(value):
		game_settings = value
		if is_inside_tree():
			_setup_map()
var columns: Array[MapColumn]


func _ready() -> void:
	instance = self
	
	_setup_map()
	
	EventBus.ticker_new_tick.connect(_on_new_tick)

func get_column(index: int) -> MapColumn:
	return columns[index]

func get_tile(column_index: int, tile_index: int) -> Tile:
	if column_index >= len(columns) or tile_index >= len(columns[column_index].tiles) or column_index < 0 or tile_index < 0:
		return null
	return columns[column_index].get_tile(tile_index)

func get_tile_coordinates(tile: Tile) -> Vector2i:
	return Vector2i(tile.column.column_index, tile.tile_index)

func get_empty_tiles_in_column(column_index: int) -> Array[Tile]:
	return columns[column_index].get_empty_tiles()

func get_tiles_in_range(ability_range: AbilityRange, reference_tile: Tile) -> Array[Tile]:
	var tiles: Array[Tile] = []
	var base_position = get_tile_coordinates(reference_tile)

	for pattern in ability_range.patterns:
		var directions: Array[Vector2i] = [pattern.get_direction_vector()]

		if pattern.mirror:
			directions.append(-pattern.get_direction_vector())

		for dir in directions:
			for i in range(0, pattern.distance):
				var tile_position = (base_position + dir) + dir * pattern.area_grid * i
				tiles.append_array(_get_tiles_in_pattern(tile_position, pattern, dir))

	return tiles

func _get_tiles_in_pattern(reference_position: Vector2i, pattern: RangePattern, direction: Vector2i) -> Array[Tile]:
	var tiles: Array[Tile] = []
	var growth := Vector2i(
		-1 if direction.x < 0 else 1,
		-1 if direction.y < 0 else 1
	)

	for x in range(pattern.area_grid.x):
		for y in range(pattern.area_grid.y):
			var local_offset = (Vector2i(x, y) + pattern.offset) * growth
			var tile = get_tile(reference_position.x + local_offset.x, reference_position.y + local_offset.y)

			if tile:
				tiles.append(tile)

	return tiles

func get_random_empty_tile(column_index: int) -> Tile:
	var order = range(0, len(columns[column_index].tiles))
	order.shuffle()
	
	var tile
	
	for tile_index in order:
		tile = get_tile(column_index, tile_index)
		if not tile.entity:
			return tile
			
	return null

func get_tile_path(current_tile: Tile, target_tile: Tile, include_target: bool = true) -> Array[Tile]:
	var path = []
	
	var current_x = current_tile.column.column_index
	var current_y = current_tile.tile_index
	
	var target_x = target_tile.column.column_index
	var target_y = target_tile.tile_index
	
	while current_x != target_x or current_y != target_y:
		current_x += sign(target_x - current_x)
		current_y += sign(target_y - current_y)
		
		var next_tile = get_tile(current_x, current_y)
		path.append(next_tile)
	
	if include_target:
		path.append(target_tile)
	
	return path

func get_entities_in_column(column_index : int) -> Array[Entity]:
	var entities : Array[Entity] = []
	for tile : Tile in columns[column_index].tiles:
		if tile.entity:
			entities.append(tile.entity)
			
	return entities
	
func is_column_full(column_index : int) -> bool:
	var count = 0
	for tile : Tile in columns[column_index].tiles:
		if tile.entity:
			count += 1
				
	return count >= game_settings.tiles_per_column
	
func _can_modify_tree() -> bool:
	return !Engine.is_editor_hint() || (Engine.is_editor_hint() && get_tree().edited_scene_root == self)

func _setup_map():
	if _can_modify_tree():
		print("setup map")
		columns = []

		for child in get_children():
			remove_child(child)
			child.queue_free()

		for i in range(game_settings.map_columns):
			var mapColumn = MapColumn.new()
			var column_size: int = game_settings.tiles_per_column
				
			mapColumn.name = "MapColumn"

			if _can_modify_tree():
				add_child(mapColumn, true)
				mapColumn.owner = self;
				columns.append(mapColumn)
			
				mapColumn.position.x = (game_settings.tile_size.x + game_settings.tile_spacing.x) * i + game_settings.tile_size.x / 2
				mapColumn.setup_column(column_size, i, game_settings.tile_size, game_settings.tile_spacing)

func _on_new_tick(count: int):
	var column = columns[count]
	await column.trigger_tiles()
	
	EventBus.tick_triggers_finished.emit()

func make_all_tiles_not_selectable():
	for column in columns:
		for tile in column.tiles:
			tile.selectable.set_selectable(false)
