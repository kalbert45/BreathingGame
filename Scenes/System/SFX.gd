class_name SFX
extends AudioStreamPlayer


func _on_finished():
	queue_free()
