class_name PrintAction
extends Action

@export var print_message: String

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
    print(print_message)