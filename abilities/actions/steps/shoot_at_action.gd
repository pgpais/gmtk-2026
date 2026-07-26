class_name ShootAtAction
extends Action

@export var tile_position: Vector2i

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	entity.shoot_at(tile_position)

func enable_preview(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	var tile: Tile = grid_map.get_tile(tile_position.x, tile_position.y)
	tile.show_danger_highlight()

func disable_preview(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	var tile: Tile = grid_map.get_tile(tile_position.x, tile_position.y)
	tile.hide_danger_highlight()