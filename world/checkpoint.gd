class_name Checkpoint extends Area2D


func _on_body_entered(body: Player) -> void:
	body.checkpoint = global_position
