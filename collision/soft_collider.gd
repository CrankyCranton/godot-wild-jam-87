class_name SoftCollider extends Area2D


@export var distance_weighted := true

@onready var shape: CircleShape2D = $CollisionShape2D.shape


func get_velocity() -> Vector2:
	var result := Vector2()
	var soft_colliders := get_overlapping_areas()
	for soft_collider: SoftCollider in soft_colliders:
		var weighted_direction := (global_position - soft_collider.global_position) \
				/ (shape.radius + soft_collider.shape.radius)
		var direction := soft_collider.global_position.direction_to(global_position)
		result += weighted_direction if distance_weighted else direction
	if soft_colliders.size() > 0:
		result /= soft_colliders.size()

	return result
