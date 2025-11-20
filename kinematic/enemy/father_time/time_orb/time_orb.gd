class_name TimeOrb extends Area2D


@export var speed := 16.0
@export var slowing := 4.0

var direction := Vector2()


func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta


func _on_body_entered(body: Node) -> void:
	if body is Player:
		body.speed /= slowing
		AudioServer.set_bus_effect_enabled(0, 0, true)
	else:
		queue_free()


func _on_body_exited(body: Node) -> void:
	if body is Player:
		body.speed *= slowing
		AudioServer.set_bus_effect_enabled(0, 0, false)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
