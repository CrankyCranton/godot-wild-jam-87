class_name TimeOrb extends Area2D


@export var speed := 16.0
@export var slowing := 4.0
@export var enemy_speeding := 1.5

var direction := Vector2()
var player: Player


func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta


func delete() -> void:
	#if player:
		#reset_slowing()
	queue_free()


func reset_slowing() -> void:
	Engine.time_scale = 1.0
	player.speed *= slowing
	player.set_anim_time_scale(1.0)
	AudioServer.set_bus_effect_enabled(0, 0, false)


func _on_body_entered(body: Node) -> void:
	if body is Player:
		player = body
		Engine.time_scale = enemy_speeding
		body.speed /= slowing
		body.set_anim_time_scale(1.0 * slowing)
		AudioServer.set_bus_effect_enabled(0, 0, true)
	else:
		delete()


func _on_body_exited(body: Node) -> void:
	if body is Player:
		reset_slowing()
		player = null


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
