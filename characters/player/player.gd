extends CharacterBody3D


@onready var interaction_raycast: RayCast3D = $Camera3D/InteractionRaycast
@onready var camera_3d: Camera3D = $Camera3D
@onready var look_at_position: Node3D = $Camera3D/LookAtPosition
@onready var search_bar: ProgressBar = $HUD/VBoxContainer/HBoxContainer/MarginContainer/SearchBar
@onready var interaction_label: Label = $HUD/CenterContainer/InteractionLabel


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var mouse_sensetivity := .08
@export var normal_camera_position := 1.8


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_pressed("crouch"):
		camera_3d.position.y = lerp(camera_3d.position.y, normal_camera_position / 2, 0.1)
	else:
		camera_3d.position.y = lerp(camera_3d.position.y, normal_camera_position, 0.1)
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _input(event: InputEvent) -> void:
	check_for_interactor()
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensetivity
		camera_3d.rotation_degrees.x -= event.relative.y * mouse_sensetivity
		camera_3d.rotation_degrees.x = clamp(camera_3d.rotation_degrees.x, -90, 90)


func update_search_bar(value):
	if value == 0:
		search_bar.visible = false
	else:
		search_bar.visible = true
		search_bar.value = value


func check_for_interactor():
	if interaction_raycast.is_colliding():
		var collider = interaction_raycast.get_collider()
		print(collider)
		if collider.has_method("interact"):
			interaction_label.text = collider.interactor_text
			if Input.is_action_just_pressed("interact"):
				collider.interact()
		else:
			interaction_label.text = "."
	else:
		interaction_label.text = "."


func change_label_visibility():
	interaction_label.visible = !interaction_label.visible
