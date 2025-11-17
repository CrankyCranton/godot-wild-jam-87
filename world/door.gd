class_name Door extends Area2D


@export var target_door: Door

@onready var spawn_position: Marker2D = $SpawnPosition
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_body_entered(body: Player) -> void:
	body.can_move = false
	body.velocity = Vector2()
	animation_player.play(&"fade_in")
	await animation_player.animation_finished
	body.set_camera_smoothed(false)
	body.global_position = target_door.spawn_position.global_position
	await RenderingServer.frame_post_draw
	body.set_camera_smoothed(true)
	animation_player.play(&"fade_out")
	body.can_move = true
