extends Control


func _on_button_pressed():
	$AudioStreamPlayer.play()
	$AnimationPlayer.play("fade")
	SignalBus.emit_signal('game_start')
	$Button.disabled = true

func level_button_pressed(s, l):
	$AudioStreamPlayer.play()
	$AnimationPlayer.play('fade')
	SignalBus.emit_signal('level_start', s, l)
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_button_2_pressed():
	$AudioStreamPlayer.play()
	$Button.visible = false
	$Button2.visible = false
	$Levels.visible = true


func _on_back_pressed():
	$AudioStreamPlayer.play()
	$Button.visible = true
	$Button2.visible = true
	$Levels.visible = false
