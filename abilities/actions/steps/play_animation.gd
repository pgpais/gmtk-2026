class_name PlayAnimation
extends Action

@export var animation_name: String

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	entity.play_animation(animation_name)

	while (true):
		var finished_animation = await entity.animation_finished

		if finished_animation == animation_name:
			break

func enable_preview(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	pass

func disable_preview(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	pass