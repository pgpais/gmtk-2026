extends Resource
class_name  ActionStep

enum STEP_TYPES {
	select, 
	move, 
	push, 
	create_barrier, 
	lurk_tile,
	transform
}

enum TARGET_TYPES {
	tile,
	ally,
	enemy,
	direction
}

@export var action_type : STEP_TYPES:
	set(value):
		action_type = value
		property_list_changed.emit()

@export_group("Selection Options")

@export var target_type : TARGET_TYPES
@export var selection_range : AbilityRange
@export var highlight_selection_range : bool = true

const selection_props = [&"target_type", &"selection_range"]

func _validate_property(property : Dictionary):
	if property.name in selection_props:
		if action_type == STEP_TYPES.select:
			property.usage |= PROPERTY_USAGE_EDITOR 
		else:
			property.usage &= ~PROPERTY_USAGE_EDITOR 
