
extends Path2D

# mostly stays in one place
# glows red when failed to kill

#@export var color = Constants.COLORS.BLUE : set = _set_color
var tween_time = 1.5
var hit_count = 2
var hit = false : set = _set_hit # boolean for if demon was hit

var _tween

func _ready():
	set_idle()
	#self.color = color

func _set_hit(value):
	if value:
		if hit_count > 1:
			$PathFollow2D/AnimationPlayer.play("first_hit")
			hit_count -= 1
		else:
		#$AudioStreamPlayer.play()
			$PathFollow2D/AnimationPlayer.play("hit")
			$PathFollow2D/Area2D/CollisionShape2D.set_deferred("disabled", true)
			hit=value
	else:
		if hit != value:
			$PathFollow2D/AnimationPlayer.play("respawn")
		
		hit = value

#func _set_color(value):
#	color = value
#	match color:
#		Constants.COLORS.BLUE:
#			hit_count = 1
#			$Sprite2D.texture = load("res://Assets/Sprites/Gameplay/demon_red.png")
#		Constants.COLORS.RED:
#			hit_count = 2
#			$Sprite2D.texture = load("res://Assets/Sprites/Gameplay/demon_red2.png")

# move along path2d
func activate():
	tween_to(1.0)
	$PathFollow2D/Area2D/CollisionShape2D.set_deferred("disabled", false)
	
# move back
func deactivate():
	tween_to(0.0)
	
func tween_to(pos):
	if _tween:
		_tween.kill()
	_tween = create_tween().set_trans(Tween.TRANS_QUAD)
	_tween.tween_property($PathFollow2D, 'progress_ratio', pos, tween_time)

func set_idle():
	$PathFollow2D/IdlePlayer.play("idle")
	$PathFollow2D/IdlePlayer.seek(randf_range(0, 1.99), true)

func reset():
	hit_count = 2
	if hit:
		set_idle()
	self.hit = false

func _on_area_2d_area_entered(area):
	var note = Global.pick_note()
	var db = (area.speed / 250) * 28 - 24
	Global.play_sfx('res://Assets/Sounds/SFX/demon_hit'+note+'3.wav', db)
	
	self.hit = true
	area.on_hit()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == 'first_hit':
		set_idle()
