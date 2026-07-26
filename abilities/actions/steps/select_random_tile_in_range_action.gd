extends Action
class_name SelectRandomTileInRangeAction

@export var parameter_name: String = "selected_tile"

@export var select_tile_with_entity: bool = false

@export var selection_range: AbilityRange

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	var tiles: Array[Tile] = grid_map.get_tiles_in_range(selection_range, entity.current_tile)
	
	tiles.shuffle()
	
	var selected_tile = null
	
	for tile in tiles:
		if (tile.entity and select_tile_with_entity) or (!tile.entity and !select_tile_with_entity):
			selected_tile = tile
			break
	
	action_handler.set_parameter(parameter_name, selected_tile)

func enable_preview(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	await execute(action_handler, entity, grid_map)

func disable_preview(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	pass