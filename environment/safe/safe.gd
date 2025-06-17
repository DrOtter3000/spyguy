extends Area3D


@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@export var safe_input_scene: PackedScene
var interactor_text := "Enter Code(LMB)"
var closed := true


func interact():
	var safe_scene = safe_input_scene.instantiate()
	add_child(safe_scene)


func open():
	if closed:
		collision_shape_3d.disabled = true
		$MeshInstance3D.visible = false
