extends State


var home_position: Vector3
@export var max_wander_range := 6 # remove later
@export var min_wait_time := 0.2 # move to Enemy script later
@export var max_wait_time := 2.0 # move to Enemy script later


func enter():
	super.enter()
	home_position = controller.position
	_new_patrol_position()


func _new_patrol_position():
	controller.update_patrol_position()
	var pos = controller.patrol_position
	controller.move_to_position(pos)


func navigation_complete():
	var wait_time = randf_range(min_wait_time, max_wait_time)
	await get_tree().create_timer(wait_time).timeout
	
	if not active:
		return
	
	_new_patrol_position()
