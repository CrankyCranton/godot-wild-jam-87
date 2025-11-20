class_name Bat extends Enemy


@export var player_priority := 0.5

var direction := Vector2()

@onready var direction_change_timer: Timer = $DirectionChangeTimer


func get_move_vector(_target: Vector2) -> Vector2:
	return direction


func _on_vision_body_entered(body: Node2D) -> void:
	super(body)
	direction_change_timer.timeout.emit()
	direction_change_timer.start()


func _on_vision_body_exited(body: Node2D) -> void:
	direction_change_timer.stop()
	super(body)


func _on_direction_change_timer_timeout() -> void:
	direction = global_position.direction_to(player.global_position) \
			if randf() <= player_priority else Vector2.RIGHT.rotated(randf() * TAU)
