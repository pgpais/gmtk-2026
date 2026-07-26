class_name PlayAnimationOnEntityAction
extends Action

@export var animation_name: String

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	var other_entity = action_handler.get_parameter("selected_entity")
	other_entity.play_animation(animation_name)

	while (true):
		var finished_animation = await other_entity.animation_finished

		if finished_animation == animation_name:
			break
