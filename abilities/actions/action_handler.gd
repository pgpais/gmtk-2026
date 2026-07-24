extends Node

var actions_to_perform : Array[ActionStrategy]
var current_step : int = 0
var current_action : int = 0

var parameters : Dictionary

signal action_step_finished
signal action_finished
signal all_actions_finished

func _ready() -> void:
	EventBus.action_step_performed.connect(next_step)

func set_parameter(parameter_name : String, value : Variant):
	parameters[parameter_name] = value
	
func get_parameter(parameter_name : String):
	return parameters[parameter_name]

func perform_action(action : ActionStrategy):
	actions_to_perform = [action]
	perform_step()
	
func perform_actions(actions : Array[ActionStrategy]):
	actions_to_perform = actions
	perform_step()

func next_step():	
	current_step += 1
	if current_step >= len(actions_to_perform[current_action].steps):
		finish_action()
	
func next_action():
	current_action += 1
	if current_action >= len(actions_to_perform):
		finish_all_actions()
	else:
		current_step = 0
		next_step()
	
func perform_step():
	if current_action >= len(actions_to_perform) or actions_to_perform[current_action] == null or current_step >= len(actions_to_perform[current_action].steps):
		return
	
	var step : ActionStep = actions_to_perform[current_action].steps[current_step] 
	
	if step is SelectionStep:
		EventBus.selection_needed.emit(step.target_type, step.selection_range, step.highlight_selection_range)
	#if step is MovementStrategy:
	#	EventBus.movement_needed.emit()
	# extend

func finish_action_step():
	action_step_finished.emit()
	next_step()

func finish_action():
	action_finished.emit()
	next_action()
	
func finish_all_actions():
	actions_to_perform = []
	current_step = 0
	current_action = 0
	all_actions_finished.emit()
