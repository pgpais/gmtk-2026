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
