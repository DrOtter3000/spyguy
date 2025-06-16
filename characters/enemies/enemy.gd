class_name AIController extends CharacterBody3D

@onready var state_machine: StateMachine = $StateMachine
@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var agent: NavigationAgent3D = $NavigationAgent3D
@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var recognicion_timer: Timer = $RecognicionTimer

@export var recognicion_time := 1.5
@export var lose_interest_time := 5.0

@export var patrol_destination: Node3D
@onready var home_position = global_position # Test if needed
var patrol_position: Vector3
var chasing := false

@export var walk_speed := 1.0
@export var run_speed := 3.5
var is_running := false
var is_stopped := false
var look_at_player := false
var move_direction: Vector3
var target_y_rot: float
var player_distance: float

@export var sight_arc := 100.0
@export var max_sight_range := 10.0


func _ready() -> void:
	recognicion_timer.wait_time = recognicion_time
	patrol_position = patrol_destination.position


func _process(delta: float) -> void:
	if can_see_player():
		if chasing:
			recognicion_timer.stop()
			recognicion_timer.wait_time = recognicion_time
			print("start chasing")
		else:
			if recognicion_timer.is_stopped():
				recognicion_timer.start()
			print(recognicion_timer.time_left)
	else:
		if chasing:
			if recognicion_timer.is_stopped():
				recognicion_timer.wait_time = lose_interest_time
				recognicion_timer.start()
				print("losing interest")
		else:
			recognicion_timer.stop()
			recognicion_timer.wait_time = recognicion_time
	if player:
		player_distance = position.distance_to(player.position)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var target_pos = agent.get_next_path_position()
	var move_dir = position.direction_to(target_pos)
	move_dir.y = 0
	move_dir = move_dir.normalized()
	if agent.is_navigation_finished() or is_stopped:
		move_dir = Vector3.ZERO
	var current_speed = walk_speed
	if is_running:
		current_speed = run_speed
	velocity.x = move_dir.x * current_speed
	velocity.z = move_dir.z * current_speed
	
	move_and_slide()
	
	if look_at_player:
		var player_dir = player.position - position
		target_y_rot = atan2(player_dir.x, player_dir.z)
	elif velocity.length() > 0:
		target_y_rot = atan2(velocity.x, velocity.z)
	
	rotation.y = lerp_angle(rotation.y, target_y_rot, 0.1)


func move_to_position(to_position: Vector3):
	if not agent:
		agent = get_node("NavigationAgent3D")
	
	is_stopped = false

	agent.target_position = to_position


func update_patrol_position():
	if patrol_position == home_position:
		patrol_position = patrol_destination.position
	else:
		patrol_position = home_position


func can_see_player() -> bool:
	var target_pos = player.look_at_position.global_position
	var dir_to_player = global_position.direction_to(target_pos)
	var dist_to_target = global_position.distance_to(target_pos)
	var fwd = global_transform.basis.z
	
	if dist_to_target > max_sight_range:
		return false
	
	if fwd.angle_to(dir_to_player) > deg_to_rad(sight_arc/2.0):
		return false
	
	ray_cast_3d.enabled = true
	ray_cast_3d.target_position = ray_cast_3d.to_local(target_pos)
	ray_cast_3d.force_raycast_update()
	var has_los = !ray_cast_3d.is_colliding()
	ray_cast_3d.enabled = false
	
	return has_los


func _on_recognicion_timer_timeout() -> void:
	if chasing:
		state_machine.change_state("Patrol")
		chasing = false
	else:
		state_machine.change_state("Chase")
		chasing = true
	
