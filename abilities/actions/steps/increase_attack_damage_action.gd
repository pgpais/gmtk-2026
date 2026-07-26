class_name IncreaseAttackDamageAction
extends Action

@export var amount: int = 1

@export var parameter_name: String = "bloodSucked"


func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	var bloodSucked: bool = action_handler.get_parameter(parameter_name)
	if bloodSucked: 
		entity.frog_king_damage += amount
	
