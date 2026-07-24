class_name ActionHandler
extends Node

var entity: Entity

var actions: Array[Action]
var current_action: int = 0

var parameters: Dictionary

signal action_finished
signal all_actions_finished

func _ready() -> void:
	EventBus.action_step_performed.connect(next_action)

func set_parameter(parameter_name: String, value: Variant):
	parameters[parameter_name] = value
	
func get_parameter(parameter_name: String):
	return parameters[parameter_name]

func set_entity(entity: Entity):
	self.entity = entity

func perform_actions():
	actions = entity.entity_data.action_sequence.actions
	current_action = 0
	_perform_action(current_action)

func _perform_action(index: int):
	await actions[index].execute(self, entity, entity.grid_map)
	action_finished.emit()
	next_action()

func next_action():
	current_action += 1
	var has_next_action = current_action < len(actions)
	if has_next_action:
		_perform_action(current_action)
	else:
		_finish_performing()

func _finish_performing():
	all_actions_finished.emit()
