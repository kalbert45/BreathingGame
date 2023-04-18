extends Control


func _on_button_pressed():
	$AnimationPlayer.play("fade")
	SignalBus.emit_signal('game_start')
	$Button.disabled = true
