class_name SpawnEntity
extends Action

@export var enemy_data: EnemyData

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	var tile: Tile = action_handler.get_parameter("selected_tile")

	EventBus.request_enemy_spawn.emit(tile, enemy_data)