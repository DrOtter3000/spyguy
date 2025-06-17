extends Node


var code: int
var intelligence_taken := false
var won := false


func _ready() -> void:
	#code = randi_range(1000, 9999)
	code = 1000
