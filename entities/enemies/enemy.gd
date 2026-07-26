class_name Enemy
extends Entity

@export var ranged: bool # if it attacks at a distance
var range: int
var frog_king_damage: int

func _ready() -> void:
	team = TEAMS.ENEMY
	super._ready()

func set_data(data, hidden = false):
	entity_data = data
	
	visuals = entity_data.scene.instantiate()
	visuals.name = "Visuals"
	add_child(visuals, true)
	animator = visuals.get_node("AnimationPlayer")

	frog_king_damage = entity_data.frog_king_damage
	
	play_animation("spawn")

	
func trigger():
	if current_tile.column.column_index == 0:
		# Next to frog king
		# TODO: play frog king attack animation
		EventBus.enemy_attacked_frog_king.emit(self)
		queue_free()

	await action_handler.perform_actions(entity_data.action_sequence)
	# for action: ActionSequence in possible_actions:
	# 	pass # to do

func preview_actions(will_preview: bool):
	if will_preview:
		print("preview actions")
		action_handler.preview_actions(entity_data.action_sequence)
	else:
		action_handler.disable_preview_actions()
