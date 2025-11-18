class_name Kinematic extends CharacterBody2D


signal died

@export var speed := 64.0
@export var traction := 14.0
@export var bounce_force := 256.0
@export var bounce_duration := 0.1
@export var reset_velocity_after_bounce := false

var can_move := true
var target_velocity := Vector2()

@onready var hit_box: HitBox = $HitBox


func _physics_process(delta: float) -> void:
	if can_move:
		physics_process(delta)
		velocity = velocity.lerp(target_velocity, traction * delta)
	move_and_slide()


func physics_process(_delta: float) -> void:
	pass


func freeze(duration: float) -> void:
	can_move = false
	await get_tree().create_timer(duration, false).timeout
	can_move = true


func bounce(force: Vector2, duration := bounce_duration) -> void:
	velocity = force
	await freeze(duration)
	if reset_velocity_after_bounce:
		velocity = Vector2()


func die() -> void:
	queue_free()


func _on_hit_box_died() -> void:
	die()
	died.emit()


func _on_hit_box_hurt(damage: int, source: HurtBox) -> void:
	bounce(source.global_position.direction_to(hit_box.global_position) * bounce_force * damage)


func _on_hit_box_health_changed(health: float) -> void:
	$Label.text = str(health)
