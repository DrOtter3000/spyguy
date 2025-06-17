extends CanvasLayer


@onready var line_edit: LineEdit = $VBoxContainer/HBoxContainer/LineEdit


func _ready() -> void:
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func leave():
	get_tree().paused = false
	get_tree().call_group("Player", "change_label_visibility")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	queue_free()


func enter_code():
	var code_entered = line_edit.text
	var correct_code = str(Gamestate.code)
	if code_entered == correct_code:
		# TODO: Open safe
		leave()
	else:
		# TODO: Add reaction
		print("wrong")

func _on_exit_button_pressed() -> void:
	leave()


func _on_ok_button_pressed() -> void:
	enter_code()


func _on_line_edit_text_submitted(new_text: String) -> void:
	enter_code()
