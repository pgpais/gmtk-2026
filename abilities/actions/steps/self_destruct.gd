class_name SelfDestruct
extends Action

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	entity.queue_free()

func enable_preview(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	var current_tile = entity.preview_tile

	current_tile.show_negative_highlight()

func disable_preview(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	var current_tile = entity.preview_tile

	current_tile.hide_negative_highlight()