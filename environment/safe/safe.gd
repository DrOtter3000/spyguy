extends Area3D


@export var safe_input_scene: PackedScene
var interactor_text := "(LMB)"


func interact():
	var safe_scene = safe_input_scene.instantiate()
	add_child(safe_scene)
