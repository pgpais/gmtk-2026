class_name ForAction
extends Action

@export var loop_max: int
#@export var parameter_name: String = "loopCount" 

@export var action_sequence: ActionSequence

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	#var loopCount = action_handler.get_parameter(parameter_name)
	for i in loop_max:
		action_handler.insert_actions(action_sequence)
		

func enable_preview(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	for i in loop_max:
		for action in action_sequence.actions:
			await action.enable_preview(action_handler, entity, grid_map)

func disable_preview(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	for i in loop_max:
		for action in action_sequence.actions:
			await action.disable_preview(action_handler, entity, grid_map)