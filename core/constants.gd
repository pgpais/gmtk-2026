class_name Constants

enum TARGET_TYPES {
	tile,
	ally,
	enemy,
	direction
}

enum DIRECTION {
    UP,
    DOWN,
    RIGHT,
    LEFT,
    TOP_RIGHT,
    TOP_LEFT,
    BOTTOM_RIGHT,
    BOTTOM_LEFT
}

const DIRECTION_VECTORS = {
    DIRECTION.UP: Vector2i(0, -1),
    DIRECTION.DOWN: Vector2i(0, 1),
    DIRECTION.RIGHT: Vector2i(1, 0),
    DIRECTION.LEFT: Vector2i(-1, 0),
    DIRECTION.TOP_RIGHT: Vector2i(1, -1),
    DIRECTION.TOP_LEFT: Vector2i(-1, -1),
    DIRECTION.BOTTOM_RIGHT: Vector2i(1, 1),
    DIRECTION.BOTTOM_LEFT: Vector2i(-1, 1)
}