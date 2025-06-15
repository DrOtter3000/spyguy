extends State


var home_position: Vector3
@export var max_wander_range := 6 # remove later
@export var min_wait_time := 0.2 # move to Enemy script later
@export var max_wait_time := 2.0 # move to Enemy script later
@export var chase_range := 5.0 # change to LOS later


func enter():
	super.enter()
	home_position = controller.position
	_new_patrol_position()


func _new_patrol_position():
	var pos = home_position + random_offsets() * randf_range(0, max_wander_range)
	controller.move_to_position(pos)


func navigation_complete():
	var wait_time = randf_range(min_wait_time, max_wait_time)
	await get_tree().create_timer(wait_time).timeout
	
	if not active:
		return
	
	_new_patrol_position()


func update(delta):
	if controller.player_distance < chase_range:
		state_machine.change_state("Chase")
