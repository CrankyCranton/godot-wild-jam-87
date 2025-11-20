class_name MaxHealthPickup extends NPC


@export var bonus := 3


func _on_interaction_started() -> void:
	player.increase_max_health(3)


func _on_interaction_finished() -> void:
	queue_free()
