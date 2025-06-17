extends Node3D


@onready var label_3d: Label3D = $MeshInstance3D/Label3D


func _ready() -> void:
	label_3d.text = str(Gamestate.code)
