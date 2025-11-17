class_name Player extends Kinematic


@export var run_speed := 128.0
@export var dash_length := 32.0

var dash_cooling := false
var has_axe := false

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree.get(
		&"parameters/playback")
@onready var attack_sound: AudioStreamPlayer2D = %AttackSound
@onready var hurt_box: HurtBox = $HurtBox
@onready var dash_scanner: ShapeCast2D = $DashScanner
@onready var dash_cooldown: Timer = $DashCooldown
@onready var camera: Camera2D = $Camera2D
@onready var checkpoint := global_position


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"attack") and can_move:
		velocity = Vector2()
		can_move = false
		playback.travel(&"Attack")
	#if event.is_action_pressed(&"run") and not dash_cooling:
		#dash_cooling = true
		#var direction := Input.get_vector(&"left", &"right", &"up", &"down") * dash_length
		#dash_scanner.target_position = dash_scanner.to_local(global_position + direction)
		#dash_scanner.force_shapecast_update()
		#var percent := dash_scanner.get_closest_collision_safe_fraction()
		#global_position = dash_scanner.to_global(dash_scanner.target_position * percent)
		#dash_cooldown.start()


func physics_process(_delta: float) -> void:
	var running := Input.is_action_pressed(&"run")
	var input := Input.get_vector(&"left", &"right", &"up", &"down")
	target_velocity = input * (run_speed if running else speed)
	if input != Vector2():
		playback.travel(&"Run" if running else &"Walk")
		animation_tree.set(&"parameters/Idle/blend_position", input)
		animation_tree.set(&"parameters/Walk/blend_position", input)
		animation_tree.set(&"parameters/Run/blend_position", input)
		animation_tree.set(&"parameters/Attack/blend_position", input)
	else:
		playback.travel(&"Idle")


func _on_hit_box_hurt(damage: int, source: HurtBox) -> void:
	if can_move:
		super(damage, source)


func _on_hit_box_died() -> void:
	global_position = checkpoint
	hit_box.health = hit_box.max_health
	for enemy in get_tree().get_nodes_in_group(&"enemies"):
		enemy.queue_free()
	for creep_spawner: CreepSpawner in get_tree().get_nodes_in_group(&"creep_spawners"):
		creep_spawner.reset()


func set_camera_smoothed(smoothed: bool) -> void:
	camera.position_smoothing_enabled = smoothed


func give_axe() -> void:
	has_axe = true
	hurt_box.ignore_list.remove_at(0)
	hurt_box.damage = 2


func increase_max_health(bonus: int) -> void:
	hit_box.max_health += bonus
	hit_box.health += bonus


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name.contains("attack"):
		can_move = true


func _on_animation_tree_animation_started(anim_name: StringName) -> void:
	if anim_name.contains("attack"):
		# Couldn't find out how to fix the error with RESET tracks and the playing oneshot property,
		# so playing the audio here isntead.
		attack_sound.play()


func _on_dash_cooldown_timeout() -> void:
	dash_cooling = false
