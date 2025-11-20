class_name HealthPickup extends Area2D


@export var healing := 1

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Player) -> void:
	body.hit_box.heal(healing)
	animation_player.play(&"collect")
