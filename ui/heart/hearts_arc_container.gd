@tool
extends Container

@export var radius: float = 150:
	set(value):
		radius = value
		queue_sort()

@export var arc_spread: float = 60:
	set(value):
		arc_spread = value
		queue_sort()

@export var start_angle: float = 0:
	set(value):
		start_angle = value
		queue_sort()

func _ready():
	queue_sort()

func _notification(what):
	if what == NOTIFICATION_SORT_CHILDREN:
		_arrange_in_arc()

func _arrange_in_arc():
	var valid_children = []
	for c in get_children():
		if c is Control and c.visible:
			valid_children.append(c)
			
	var count = valid_children.size()
	if count == 0: 
		return

	var step = 0
	if count > 1:
		step = arc_spread / (count - 1)

	var center_pt = size / 2 + Vector2(0, radius / 2)

	for i in range(count):
		var child = valid_children[i]
		var angle_deg = start_angle - (i * step)
		
		child.pivot_offset = child.size / 2
		
		var offset = Vector2(0, radius).rotated(deg_to_rad(angle_deg))
		
		child.position = center_pt + offset - child.pivot_offset
		
		child.rotation = 0