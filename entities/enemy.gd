class_name Enemy
extends Entity

@export var ranged: bool # if it attacks at a distance
var range: int

func _ready() -> void:
	team = TEAMS.ENEMY
	super._ready()

func set_data(data):
	entity_data = data
	
	var visuals = entity_data.scene.instantiate()
	visuals.name = "Visuals"
	add_child(visuals, true)
	animator = visuals.get_node("AnimationPlayer")

	
func trigger():
	if current_tile.column.column_index == 0:
		# Next to frog king
		# TODO: play frog king attack animation
		EventBus.enemy_attacked_frog_king.emit(self)

	await action_handler.perform_actions()
	# for action: ActionSequence in possible_actions:
	# 	pass # to do
