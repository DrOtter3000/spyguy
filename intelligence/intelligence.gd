extends Area3D


var interactor_text := "Take Intelligence(LMB)"


func interact():
	Gamestate.intelligence_taken = true
	queue_free()
