class_name SpawnEntity
extends Action

@export var target_tile_parameter_name: String = "target_tile"


@export var enemy_data: EnemyData

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	print("trying to spawn")
	var tile: Tile = action_handler.get_parameter(target_tile_parameter_name)
	
	if tile:
		EventBus.request_enemy_spawn.emit(tile, enemy_data)

func enable_preview(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	var tile: Tile = action_handler.get_parameter(target_tile_parameter_name)

	tile.show_danger_highlight()

func disable_preview(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	var tile: Tile = action_handler.get_parameter(target_tile_parameter_name)
	
	tile.hide_danger_highlight()