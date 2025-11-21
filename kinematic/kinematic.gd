class_name Kinematic extends CharacterBody2D


signal died

@export var speed := 64.0
@export var traction := 14.0
@export_group("bounce")
@export var bounce_force := 256.0
@export var bounce_duration := 0.1
@export var reset_velocity_after_bounce := false

var stunned := false
var frozen := false
var target_velocity := Vector2()
var dead := false

@onready var hit_box: HitBox = $HitBox


func _physics_process(delta: float) -> void:
	if frozen:
		return

	if not stunned:
		physics_process(delta)
		velocity = velocity.lerp(target_velocity, traction * delta)
	move_and_slide()


func physics_process(_delta: float) -> void:
	pass


func bounce(force: Vector2, duration := bounce_duration) -> void:
	velocity = force
	stunned = true
	if duration:
		await get_tree().create_timer(duration, false).timeout
		stunned = false
		if reset_velocity_after_bounce:
			velocity = Vector2()


func die() -> void:
	died.emit()


func _on_hit_box_died() -> void:
	dead = true
	frozen = true
	hit_box.set_immune()
	die()


func _on_hit_box_hurt(damage: int, source: HurtBox) -> void:
	bounce(source.global_position.direction_to(hit_box.global_position) * bounce_force * damage,
			0.0 if stunned else bounce_duration)


func _on_death_sound_finished() -> void:
	queue_free()
