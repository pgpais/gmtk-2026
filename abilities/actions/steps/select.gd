extends Action
class_name Select

@export var target_type: Constants.TARGET_TYPES
@export var selection_range: AbilityRange
@export var highlight_selection_range: bool = true

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	if highlight_selection_range:
		EventBus.request_highlight.emit(target_type, selection_range, entity.current_tile)

	var tiles: Array[Tile] = grid_map.get_tiles_in_range(selection_range, entity.current_tile)

	set_selectable_tiles(tiles, true)
	var selected_tile: Tile = await EventBus.tile_selected
	set_selectable_tiles(tiles, false)

	match target_type:
		Constants.TARGET_TYPES.TILE:
			action_handler.set_parameter("selected_tile", selected_tile)
		Constants.TARGET_TYPES.ENTITY:
			var selected_entity = selected_tile.get_entity()
			action_handler.set_parameter("selected_entity", selected_entity)
		Constants.TARGET_TYPES.DIRECTION:
			var distance_to_selected_tile = grid_map.get_tile_coordinates(selected_tile) - grid_map.get_tile_coordinates(entity.current_tile)
			var selected_direction = distance_to_selected_tile.normalized()
			action_handler.set_parameter("selected_direction", selected_direction)

func set_selectable_tiles(tiles: Array[Tile], state: bool):
	for tile in tiles:
		if tile.selectable:
			tile.selectable.set_selectable(state)