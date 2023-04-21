extends Node2D

# handles space bar input
# contains real world node and gameplay node

const MAX_STRENGTH = 250 # maximum strength of exhale
const BREATH_LIMIT = 5 # maximum time limit in seconds

@onready var _anim_player = $MovingBackground/AnimationPlayer

@export var active = false # determines if input is active
var prepared = true # variable to disallow spamming
var tutorial = true # one time use variable
var strength = 0 # strength of exhale. Depends on length held
var situation = 0
var level

var inhaling = false : set = _set_inhaling

func intro():
	level.get_node("IntroPlayer").play('intro')

func _ready():
	level = $level
	set_physics_process(false)
	SignalBus.game_start.connect(_on_Game_Start)
	SignalBus.level_start.connect(_on_Level_Start)
	SignalBus.breath_finished.connect(_on_Breath_Finished)
	SignalBus.level_cleared.connect(_on_Level_Cleared)

func _on_Game_Start():
	$MovingBackground/AnimationPlayer.play("intro")

func _on_Breath_Finished():
	prepared = true
	
# used for level select screen
func _on_Level_Start(s, l):
	if is_instance_valid(level):
		level.queue_free()
		
	$MovingBackground/SleepPlayer.stop()
		
	await get_tree().create_timer(1.0).timeout
		
	$MovingBackground/AnimationPlayer.play("wake")
	var new_level = load("res://Scenes/Game/levels/situation"+str(s)+"/breath"+str(s)+"_"+str(l)+".tscn")
	level = new_level.instantiate()
	add_child(level)
	active = true
	tutorial = false
	prepared = true

func _on_Level_Cleared(s, l):
	# 'clear' feedback
	# wait a bit
	await get_tree().create_timer(0.5).timeout
	# if there is a next level, add it. else, progress situation
	var max_levels = Global.num_levels[s]
	if l < max_levels - 1:
		var new_l = l+1
		var new_level = load("res://Scenes/Game/levels/situation"+str(s)+"/breath"+str(s)+"_"+str(new_l)+".tscn")
		level = new_level.instantiate()
		add_child(level)
		prepared = true
	else:
		active = false
		$MovingBackground/AnimationPlayer.play("outro")
		await get_tree().create_timer(1.0).timeout
		set_clear_button(s, l)
		
func set_clear_button(s, l):
	situation = s + 1
	if situation < 2:
		$ClearButton.text = "Next"
		$ClearButton.position = Vector2(296, 248)
		$ClearButton/AnimationPlayer.play("spawn")
	else:
		$ClearButton.text = "Thanks for playing!"
		$ClearButton.position = Vector2(268, 248)
		$ClearButton/AnimationPlayer.play("spawn")

func _set_inhaling(value):
	inhaling = value
	if inhaling:
		set_physics_process(true)
	else:
		strength = 0
		set_physics_process(false)

func _unhandled_input(event):
	if !active:
		return
	
	if event.is_action_pressed("breathe"):
		if prepared:
			if tutorial:
				tutorial = false
				$MovingBackground/TutorialPlayer.play("space_fadeout")
			
			_anim_player.play("inhale")
			$BreathingSFX/InhaleSFX.volume_db = 0
			$BreathingSFX/InhaleSFX.play()
			level.inhale()
			prepared = false
			self.inhaling = true
	elif event.is_action_released("breathe"):
		if inhaling:
			_anim_player.play("exhale")
			var tween = get_tree().create_tween()
			tween.tween_property($BreathingSFX/InhaleSFX, "volume_db", -80, 1)
			$BreathingSFX/ExhaleSFX.play()
			level.exhale(strength)
			self.inhaling = false

# about 5 seconds to max
func _physics_process(delta):
	strength = lerpf(strength, MAX_STRENGTH, delta)


func _on_clear_button_pressed():
	Global.play_sfx('res://Assets/Sounds/SFX/demon_hitC.wav', 0)
	if situation < 2:
		$ClearButton/AnimationPlayer.play("despawn")
		await get_tree().create_timer(1.0).timeout
		SignalBus.emit_signal('level_start', situation+1, 0)
	else:
		$ClearButton/AnimationPlayer.play("despawn")
		await get_tree().create_timer(1.0).timeout
		add_child(load("res://Scenes/System/title_screen.tscn").instantiate())
		level = load("res://Scenes/Game/levels/situation0/breath0_0.tscn").instantiate()
		level.modulate.a = 0
		
