@tool
extends Node2D

# mostly stays in one place
# glows red when failed to kill

@export var color = Constants.COLORS.BLUE : set = _set_color
var hit = false : set = _set_hit # boolean for if demon was hit

func _ready():
	set_idle()
	self.color = color

func _set_hit(value):
	if value:
		#$AudioStreamPlayer.play()
		$IdlePlayer.stop()
		$AnimationPlayer.play("hit")
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
	else:
		if hit != value:
			$AnimationPlayer.play("respawn")
		
	hit = value

func _set_color(value):
	color = value
	match color:
		Constants.COLORS.BLUE:
			$Sprite2D.texture = load("res://Assets/Sprites/Gameplay/demon_red.png")
		Constants.COLORS.WHITE:
			$Sprite2D.texture = load("res://Assets/Sprites/Gameplay/demon_white.png")

func activate():
	$Area2D/CollisionShape2D.set_deferred("disabled", false)

func set_idle():
	$IdlePlayer.play("idle")
	$IdlePlayer.seek(randf_range(0, 1.99), true)

func reset():
	set_idle()
	self.hit = false

func _on_area_2d_area_entered(area):
	var note = Global.pick_note()
	var db = (area.speed / 250) * 28 - 24
	Global.play_sfx('res://Assets/Sounds/SFX/demon_hit'+note+'3.wav', db)
	
	self.hit = true
	area.on_hit()
