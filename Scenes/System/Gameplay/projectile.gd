@tool
extends Area2D

const DEACCEL = 0.5
@export var type = Constants.PROJECTILE_TYPES.NORMAL : set = _set_type
var init_position = Vector2.ZERO

var direction = Vector2(1,0)
var speed = 0
var splitter_speed = 0

func _ready():
	set_physics_process(false)

func spawn():
	$AnimationPlayer.play("spawn")

func _set_type(value):
	type = value
	
	match type:
		Constants.PROJECTILE_TYPES.NORMAL:
			$Sprite2D.texture = load("res://Assets/Sprites/Gameplay/projectile.png")
		Constants.PROJECTILE_TYPES.SPLITTING:
			$Sprite2D.texture = load("res://Assets/Sprites/Gameplay/projectile_pink.png")

func reset():
	$GPUParticles2D.visible = false
	$splitter_nodes/split0/GPUParticles2D.visible = false
	$splitter_nodes/split1/GPUParticles2D.visible = false
	
	speed = 0
	splitter_speed = 0
	position = init_position
	
	$splitter_nodes/split0.position = Vector2.ZERO
	$splitter_nodes/split1.position = Vector2.ZERO
	
	$Sprite2D.visible = true
	$splitter_nodes.visible = false
	
	$CollisionShape2D.set_deferred("disabled", false)
	$splitter_nodes/split0/CollisionShape2D.set_deferred("disabled", true)
	$splitter_nodes/split1/CollisionShape2D.set_deferred("disabled", true)
	
# called externally
func disable():
	pass
	
func on_hit():
	$GPUParticles2D.visible = true
	$GPUParticles2D.emitting = true
	$GPUParticles2D.restart()

func push(strength, _direction):
	set_physics_process(true)
	direction = _direction
	speed = strength
	
	if type == Constants.PROJECTILE_TYPES.SPLITTING:
		$splitter_nodes/Timer.start()
	
func _physics_process(delta):
	global_position += direction * speed * delta
	speed = lerpf(speed, 0, DEACCEL*delta)
	
	if type == Constants.PROJECTILE_TYPES.SPLITTING:
		$splitter_nodes/split0.position += Vector2(0,1) * splitter_speed * delta
		$splitter_nodes/split1.position -= Vector2(0,1) * splitter_speed * delta
		splitter_speed = lerpf(splitter_speed, 0, DEACCEL*delta)
		
		$splitter_nodes/split0.speed = splitter_speed
		$splitter_nodes/split1.speed = splitter_speed

# split the projectile
func _on_timer_timeout():
	$Sprite2D.visible = false
	$splitter_nodes.visible = true
	
	$CollisionShape2D.set_deferred("disabled", true)
	$splitter_nodes/split0/CollisionShape2D.set_deferred("disabled", false)
	$splitter_nodes/split1/CollisionShape2D.set_deferred("disabled", false)
	
	splitter_speed = speed
