class_name BranchAction
extends Action

@export var condition: ActionCondition

@export var true_action_sequence: ActionSequence
@export var false_action_sequence: ActionSequence

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	if condition.evaluate(action_handler, entity, grid_map):
		action_handler.insert_actions(true_action_sequence)
	else:
		action_handler.insert_actions(false_action_sequence)

func enable_preview(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	if condition.preview_evaluate(action_handler, entity, grid_map):
		for action in true_action_sequence.actions:
			await action.enable_preview(action_handler, entity, grid_map)
	else:
		for action in false_action_sequence.actions:
			await action.enable_preview(action_handler, entity, grid_map)
			
func disable_preview(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	true_action_sequence.disable_preview(action_handler, entity, grid_map)
	false_action_sequence.disable_preview(action_handler, entity, grid_map)