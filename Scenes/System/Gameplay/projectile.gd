@tool
extends Area2D

const DEACCEL = 0.5
@export var color = Constants.COLORS.BLUE : set = _set_color
var init_position = Vector2.ZERO

var direction = Vector2(1,0)
var speed = 0

func _ready():
	set_physics_process(false)

func _set_color(value):
	color = value
	
	match color:
		Constants.COLORS.BLUE:
			$Sprite2D.texture = load("res://Assets/Sprites/Gameplay/projectile.png")
		Constants.COLORS.WHITE:
			$Sprite2D.texture = load("res://Assets/Sprites/Gameplay/projectile_white.png")

func reset():
	speed = 0
	position = init_position

func push(strength, _direction):
	set_physics_process(true)
	direction = _direction
	speed = strength
	
func _physics_process(delta):
	global_position += direction * speed * delta
	speed = lerpf(speed, 0, DEACCEL*delta)
