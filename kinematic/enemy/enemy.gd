class_name Enemy extends Kinematic


@export var soft_collider_strength := 32.0

var player: Player

@onready var soft_collider: SoftCollider = $SoftCollider


func physics_process(_delta: float) -> void:
	if player:
		target_velocity = global_position.direction_to(player.global_position) * speed
	else:
		target_velocity = Vector2()
	target_velocity += soft_collider.get_velocity() * soft_collider_strength


func _on_vision_body_entered(body: Node2D) -> void:
	player = body


func _on_vision_body_exited(_body: Node2D) -> void:
	player = null
