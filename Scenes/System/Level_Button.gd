extends Button

@export var situation = 0
@export var level = 0

func _on_pressed():
	get_node("../../..").level_button_pressed(situation, level)
