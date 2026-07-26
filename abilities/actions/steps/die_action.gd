class_name DieAction
extends Action

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	entity.die()
	entity.queue_free()

func enable_preview(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	var entity_tile = entity.preview_tile

	entity_tile.show_negative_highlight()

func disable_preview(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	var entity_tile = entity.preview_tile

	entity_tile.hide_negative_highlight()