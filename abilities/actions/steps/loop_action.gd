class_name LoopAction
extends Action

@export var loop_from: int


func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
		action_handler.loopActionsFrom(loop_from)

		
