class_name ShockAction
extends Action

@export var parameter_name: String = "willShock"
@export var toggle: bool = false

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	var toggle: bool = action_handler.get_parameter(parameter_name)
	entity.shock(toggle)

func enable_preview(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	var current_tile: Tile = entity.preview_tile

	if current_tile:
		current_tile.show_danger_highlight()

func disable_preview(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	var current_tile: Tile = entity.preview_tile

	current_tile.hide_danger_highlight()