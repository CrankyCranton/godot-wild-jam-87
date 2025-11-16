class_name Player extends Kinematic


@export var run_speed := 128.0

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree.get(
		&"parameters/playback")
@onready var attack_sound: AudioStreamPlayer2D = %AttackSound


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"attack") and can_move:
		velocity = Vector2()
		can_move = false
		playback.travel(&"Attack")


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


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name.contains("attack"):
		can_move = true


func _on_animation_tree_animation_started(anim_name: StringName) -> void:
	if anim_name.contains("attack"):
		# Couldn't find out how to fix the error with RESET tracks and the playing oneshot property,
		# so playing the audio here isntead.
		attack_sound.play()
