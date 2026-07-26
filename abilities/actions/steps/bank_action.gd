class_name BankActionSequenceAction
extends Action

@export var actions : ActionSequence 

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	entity.bank_actions(actions)

func enable_preview(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	pass

func disable_preview(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	pass