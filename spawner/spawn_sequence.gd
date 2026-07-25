extends Resource
class_name SpawnSequence

@export var spawn_limit_per_column : int = 1
@export_range(0, 1) var repeat_probability : float = 0
@export var column_indexes : Array[int]
@export var spawn_datas : Array[SpawnData]
