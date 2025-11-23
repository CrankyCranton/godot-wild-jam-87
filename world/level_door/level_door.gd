class_name LevelDoor extends Area2D


signal entered
signal exited

@export var target_door: LevelDoor

@onready var spawn_position: Marker2D = $SpawnPosition
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func enter(player: Player) -> void:
	player.global_position = spawn_position.global_position
	const GRACE_TIME := 1.0
	player.hit_box.set_immune(GRACE_TIME)
	entered.emit()


func _on_body_entered(body: Player) -> void:
	body.playback.travel(&"Idle")
	body.hit_box.set_immune()
	body.frozen = true
	body.velocity = Vector2()
	animation_player.play(&"fade_in")

	await animation_player.animation_finished
	body.set_camera_smoothed(false)
	target_door.enter(body)
	exited.emit()

	await RenderingServer.frame_post_draw
	body.set_camera_smoothed(true)
	animation_player.play(&"fade_out")
	body.frozen = false
