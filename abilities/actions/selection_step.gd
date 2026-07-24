extends ActionStep
class_name SelectionStep

enum TARGET_TYPES {
	tile,
	ally,
	enemy,
	direction
}

@export var target_type : TARGET_TYPES
@export var selection_range : AbilityRange
@export var highlight_selection_range : bool = true
