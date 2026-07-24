@tool
class_name AbilityRange
extends Resource

enum range_types {distance, directional, path}

@export var range_type : range_types:
	set(value):
		range_type = value
		property_list_changed.emit()

@export_group("Distance Range")

@export var min_distance : int
@export var max_distance : int

@export_group("Directional Range")

@export var left_min_range: int
@export var left_max_range: int
@export var right_min_range: int
@export var right_max_range: int
@export var up_min_range: int
@export var up_max_range: int
@export var down_min_range: int
@export var down_max_range: int

@export var top_left_min_range: int
@export var top_left_max_range: int
@export var top_right_min_range: int
@export var top_right_max_range: int
@export var bottom_left_min_range: int
@export var bottom_left_max_range: int
@export var bottom_right_min_range: int
@export var bottom_right_max_range: int

@export_group("Path Range")

@export var path : Array[Vector2i]

const distance_props = [&"min_distance", &"max_distance"]

const directional_props = [
	&"left_min_range", &"left_max_range", &"right_min_range", &"right_max_range",
	&"up_min_range", &"up_max_range", &"down_min_range", &"down_max_range",
	&"top_left_min_range", &"top_left_max_range", &"top_right_min_range", &"top_right_max_range",
	&"bottom_left_min_range", &"bottom_left_max_range", &"bottom_right_min_range", &"bottom_right_max_range"
]
const path_props = [&"path"]

func _validate_property(property : Dictionary):
	if property.name in distance_props:
		if range_type == range_types.distance:
			property.usage |= PROPERTY_USAGE_EDITOR 
		else:
			property.usage &= ~PROPERTY_USAGE_EDITOR 

	elif property.name in directional_props:
		if range_type == range_types.directional:
			property.usage |= PROPERTY_USAGE_EDITOR
		else:
			property.usage &= ~PROPERTY_USAGE_EDITOR

	elif property.name in path_props:
		if range_type == range_types.path:
			property.usage |= PROPERTY_USAGE_EDITOR
		else:
			property.usage &= ~PROPERTY_USAGE_EDITOR

func get_tiles_to_highlight(column_index, tile_index) -> Array: 
	return []
