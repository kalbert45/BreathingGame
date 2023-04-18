extends Area2D

func on_hit():
	$GPUParticles2D.visible = true
	$GPUParticles2D.emitting = true
	$GPUParticles2D.restart()
