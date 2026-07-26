class_name DiveTargetAction
extends Action

@export var target_parameter_name: String = "target"

@export var parameter_name: String = "bloodSucked"

@export var blood_sucked: bool = false

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	var target: Entity = action_handler.get_parameter(target_parameter_name)
	#entity.dive(target)
	if (target != null && target.team == entity.TEAMS.ALLY):
		#certo mas precisa da animaçao para ser claro, por agora fazer delete
		#target.dive(false)
		target.queue_free()
		action_handler.set_parameter(parameter_name, true)
	else:
		action_handler.set_parameter(parameter_name, false)

func enable_preview(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	var target: Entity = action_handler.get_parameter(target_parameter_name)

	var target_tile: Tile = target.current_tile
	target_tile.show_danger_highlight()

func disable_preview(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	var target: Entity = action_handler.get_parameter(target_parameter_name)

	var target_tile: Tile = target.current_tile
	target_tile.hide_danger_highlight()
