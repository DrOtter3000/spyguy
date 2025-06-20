extends Area3D


var interactor_text := "Take Intelligence(LMB)"


# Looks weird but works. Crashes if using queue_free() 
func interact():
	Gamestate.intelligence_taken = true
	$CollisionShape3D.queue_free()
	$Briefcase2.visible = false
