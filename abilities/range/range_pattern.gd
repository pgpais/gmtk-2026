class_name RangePattern
extends Resource

@export var direction: Constants.DIRECTION = Constants.DIRECTION.RIGHT
@export var area_grid: Vector2i = Vector2i(1, 1)
@export var offset: Vector2i = Vector2i(0, 0)
@export var distance: int = 1
@export var mirror: bool = false

func get_direction_vector() -> Vector2i:
    return Constants.DIRECTION_VECTORS[direction]