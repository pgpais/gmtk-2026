@abstract
class_name MovementStrategy
extends Resource

@export var ability_range: AbilityRange

@abstract func move(entity: Entity)

@abstract func tiles_to_highlight(entity: Entity, grid_map: LayerGridMap) -> Array[Tile]
