@tool
extends Node2D

# mostly stays in one place
# glows red when failed to kill

@export var color = Constants.COLORS.BLUE : set = _set_color
var hit = false : set = _set_hit # boolean for if demon was hit

func _ready():
	self.color = color

func _set_hit(value):
	if value:
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
			$Sprite2D.texture = load("res://Assets/Sprites/Gameplay/demon.png")
		Constants.COLORS.WHITE:
			$Sprite2D.texture = load("res://Assets/Sprites/Gameplay/demon_white.png")

func activate():
	$Area2D/CollisionShape2D.set_deferred("disabled", false)

func reset():
	self.hit = false

func _on_area_2d_area_entered(area):
	if color == area.color:
		self.hit = true
