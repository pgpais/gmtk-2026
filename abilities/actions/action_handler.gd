extends Node

var current_action : ActionStrategy
var current_step : int = 0

func _ready() -> void:
	EventBus.action_step_performed.connect(next_step)

func set_new_action(action):
	current_action = action

func next_step():
	var step : ActionStep = current_action.steps[current_step] 
	
	match step.action_type:
		ActionStep.STEP_TYPES.select:
			EventBus.selection_needed.emit(step.target_type, step.selection_range, step.highlight_selection_range)
		ActionStep.STEP_TYPES.move:
			EventBus.movement_needed.emit()
		ActionStep.STEP_TYPES.push:
			pass
		ActionStep.STEP_TYPES.create_barrier:
			pass
		ActionStep.STEP_TYPES.lurk_tile:
			pass
		ActionStep.STEP_TYPES.transform:
			pass
