class_name HealthPickup extends Area2D


@export var healing := 1


func _on_area_entered(area: HitBox) -> void:
	if area.is_in_group(&"players"):
		area.heal(healing)
		queue_free()
