class_name Player extends Kinematic


const TREE_LAYER := 7

@export var run_speed := 2.0

var outdoors := true
var has_axe := false
var has_candle := false
var attacking := false
var running := false

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree.get(
		&"parameters/playback")
@onready var attack_sound: AudioStreamPlayer2D = %AttackSound
@onready var hurt_box: HurtBox = $HurtBox
@onready var near_sight: PointLight2D = $NearSight
@onready var heal_sound: AudioStreamPlayer = $HealSound
@onready var health_bar: TextureRect = %HealthBar
@onready var death_sound: AudioStreamPlayer = $DeathSound
@onready var hurt_sound: AudioStreamPlayer = $HurtSound
@onready var wind: AudioStreamPlayer = $Wind
@onready var camera: ScreenShakeCamera = $ScreenShakeCamera
@onready var checkpoint := global_position


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"attack") and not frozen:
		playback.travel(&"Attack")
		attacking = true


func _process(delta: float) -> void:
	if outdoors:
		if running and not (stunned or frozen) and velocity != Vector2():
			wind.volume_linear = lerpf(wind.volume_linear, remap(clampf(velocity.length(), speed, speed * run_speed),
					speed, speed * run_speed, 0.0, 1.5), delta * 2.0)
		else:
			wind.volume_linear = lerpf(wind.volume_linear, 0.0, delta)
	else:
		wind.volume_linear = 0.0


func physics_process(_delta: float) -> void:
	running = Input.is_action_pressed(&"run")
	var input := Input.get_vector(&"left", &"right", &"up", &"down")
	target_velocity = input * (speed * run_speed if running else speed)
	if not attacking:
		if input != Vector2():
			playback.travel(&"Run" if running else &"Walk")
			animation_tree.set(&"parameters/Idle/blend_position", input)
			animation_tree.set(&"parameters/Walk/blend_position", input)
			animation_tree.set(&"parameters/Run/blend_position", input)
			animation_tree.set(&"parameters/Attack/blend_position", input)
		else:
			playback.travel(&"Idle")


func die() -> void:
	for enemy in get_tree().get_nodes_in_group(&"enemies"):
		if not enemy is FatherTime:
			enemy.queue_free()
	for creep_spawner: CreepSpawner in get_tree().get_nodes_in_group(&"creep_spawners"):
		creep_spawner.reset()

	velocity = Vector2()
	hit_box.health = hit_box.max_health
	death_sound.play()
	died.emit()

	set_camera_smoothed(false)
	global_position = checkpoint
	await RenderingServer.frame_post_draw
	set_camera_smoothed(true)

	dead = false
	hit_box.immune = false
	frozen = false


func shake_cam() -> void:
	camera.shake(100, 0.03, Vector2(4.0, 4.0))


func set_anim_time_scale(time_scale: float) -> void:
	var state_machine: AnimationNodeStateMachine = animation_tree.tree_root
	var anim_list := scan_anim_node(state_machine)
	for anim_node in anim_list:
		anim_node.use_custom_timeline = true
		anim_node.stretch_time_scale = time_scale != 1.0
		anim_node.timeline_length = animation_tree.get_animation(anim_node.animation
				).length * time_scale


func scan_anim_node(anim_node: AnimationRootNode) -> Array[AnimationNodeAnimation]:
	var result: Array[AnimationNodeAnimation] = []
	if anim_node is AnimationNodeAnimation:
		result.append(anim_node)
	elif anim_node is AnimationNodeBlendSpace2D:
		for i in anim_node.get_blend_point_count():
			result.append_array(scan_anim_node(anim_node.get_blend_point_node(i)))
	elif anim_node is AnimationNodeStateMachine:
		for anim in anim_node.get_node_list():
			result.append_array(scan_anim_node(anim_node.get_node(anim)))
	return result


func _on_hit_box_hurt(damage: int, source: HurtBox) -> void:
	if hit_box.health > 0:
		hurt_sound.play()
	super(damage, source)


func set_near_sight_active(active: bool) -> void:
	near_sight.visible = active


func set_camera_smoothed(smoothed: bool) -> void:
	camera.position_smoothing_enabled = smoothed


func give_axe() -> void:
	has_axe = true
	hurt_box.set_collision_mask_value(TREE_LAYER, true)


func increase_max_health(bonus: int) -> void:
	hit_box.max_health += bonus
	hit_box.health += bonus


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name.contains("attack"):
		attacking = false


func _on_animation_tree_animation_started(anim_name: StringName) -> void:
	if anim_name.contains("attack"):
		# Couldn't find out how to fix the error with RESET tracks and the playing oneshot property,
		# so playing the audio here isntead.
		attack_sound.play()


func _on_hit_box_healed(_healing: int) -> void:
	heal_sound.play()


func _on_hurt_box_hurt(target: HitBox) -> void:
	if target.get_collision_layer_value(TREE_LAYER):
		attack_sound.stop()


func _on_hit_box_health_changed(health: float) -> void:
	if not is_node_ready():
		await ready
	health_bar.size.x = health_bar.texture.get_width() * health


func _on_hit_box_max_health_changed(_max_health: int) -> void:
	pass # Replace with function body.
