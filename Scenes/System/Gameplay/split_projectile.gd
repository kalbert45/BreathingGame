extends Area2D

var speed = 0

func on_hit():
	$GPUParticles2D.visible = true
	$GPUParticles2D.emitting = true
	$GPUParticles2D.restart()
