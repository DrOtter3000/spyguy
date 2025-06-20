extends Area3D


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var door: MeshInstance3D = $DoorAsset/Door
var open := false
var interactor_text := "Use Door(LMB)"



func _ready() -> void:
	door.scale = Vector3(1,1,1)
	door.rotation.y = 0
	$StaticBody3D.queue_free()


func interact():
	if not animation_player.is_playing():
		if open:
			animation_player.play("close")
			open = false
		else:
			animation_player.play("open")
			open = true
	


func _on_enemy_detector_area_body_entered(body: Node3D) -> void:
	if !open:
		animation_player.play("open")


func _on_enemy_detector_area_body_exited(body: Node3D) -> void:
	if open:
		animation_player.play("close")
