class_name RangePattern
extends Resource

enum Direction {
    UP,
    DOWN,
    LEFT,
    RIGHT,
    TOP_RIGHT,
    TOP_LEFT,
    BOTTOM_RIGHT,
    BOTTOM_LEFT
}

var direction_vectors = {
    Direction.UP: Vector2i(0, -1),
    Direction.DOWN: Vector2i(0, 1),
    Direction.LEFT: Vector2i(-1, 0),
    Direction.RIGHT: Vector2i(1, 0),
    Direction.TOP_RIGHT: Vector2i(1, -1),
    Direction.TOP_LEFT: Vector2i(-1, -1),
    Direction.BOTTOM_RIGHT: Vector2i(1, 1),
    Direction.BOTTOM_LEFT: Vector2i(-1, 1)
}

@export var direction: Direction = Direction.RIGHT
@export var area_grid: Vector2i = Vector2i(1, 1)
@export var offset: Vector2i = Vector2i(0, 0)
@export var distance: int = 1

func get_direction_vector() -> Vector2i:
    return direction_vectors[direction]