@tool extends StaticBody2D


@export var distance_curve: Curve

@onready var sprite: Sprite2D = $Sprite


func _ready() -> void:
	sprite.flip_h = bool(randi() % 2)
	sprite.position = Vector2(distance_curve.sample(randf()), 0.0).rotated(randf() * TAU)
