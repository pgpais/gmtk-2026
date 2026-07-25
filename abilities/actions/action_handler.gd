class_name ActionHandler
extends Node

var entity: Entity

var actions: Array[Action]
var current_action: int = 0

var parameters: Dictionary

signal action_finished
signal all_actions_finished

func set_parameter(parameter_name: String, value: Variant):
	parameters[parameter_name] = value
	print(parameters[parameter_name])
	
func get_parameter(parameter_name: String):
	if !parameters.has(parameter_name):
		return null

	return parameters[parameter_name]

func set_entity(entity: Entity):
	self.entity = entity

func perform_actions(action_sequence: ActionSequence = entity.entity_data.action_sequence):
	actions = action_sequence.actions.duplicate()
	current_action = 0
	_perform_action(current_action)
	await all_actions_finished

func insert_actions(action_sequence: ActionSequence):
	for i in range(len(action_sequence.actions)):
		actions.insert(current_action + i + 1, action_sequence.actions[i])
		print(actions)

func _perform_action(index: int):
	var action = actions[index]
	
	await action.execute(self, entity, entity.grid_map)
	action_finished.emit()
	next_action()

func next_action():
	current_action += 1
	var has_next_action = current_action < len(actions)
	if has_next_action:
		_perform_action(current_action)
	else:
		_finish_performing()

func reset():
	current_action = 0
	actions.clear()

func _finish_performing():
	all_actions_finished.emit()
