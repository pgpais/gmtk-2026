class_name PrintAction
extends Action

@export var print_message: String

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	print(print_message)

func enable_preview(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	pass

func disable_preview(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	pass