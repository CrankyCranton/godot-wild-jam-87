class_name Kinematic extends CharacterBody2D


@export var speed := 64.0
@export var traction := 14.0
@export var bounce_force := 256.0
@export var bounce_duration := 0.1

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


func _on_hit_box_died() -> void:
	queue_free()


func _on_hit_box_hurt(damage: int, source: HurtBox) -> void:
	if can_move:
		velocity = source.global_position.direction_to(hit_box.global_position) \
				* bounce_force * damage
		freeze(bounce_duration)
