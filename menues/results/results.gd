extends Control


@onready var win_loose_label: Label = $WinLooseLabel


func _ready() -> void:
	if Gamestate.won:
		win_loose_label.text = "You win"
	else:
		win_loose_label.text = "Game Over"
