extends State


@export var stop_range := 1.0
@export var lose_interest_range := 10.0 # replace with time later?

var path_update_rate := 0.1
var last_path_update_time: float


func enter():
	super.enter()
	controller.is_running = true
	controller.look_at_player = true


func exit():
	super.exit()
	controller.is_running = false
	controller.look_at_player = false


func update(delta):
	var current_time = Time.get_unix_time_from_system()
	
	if current_time - last_path_update_time > path_update_rate:
		last_path_update_time = current_time
		controller.move_to_position(controller.player.position)
	
	# May not be needet later
	#if controller.player_distance < stop_range:
		#controller.is_stopped = true
	#
	#if controller.player_distance > lose_interest_range:
		#state_machine.change_state("Patrol")
