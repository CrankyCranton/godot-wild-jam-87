class_name CandlePickup extends NPC


@onready var candle_light: PointLight2D = $CandleLight


func _on_interaction_finished() -> void:
	candle_light.reparent(player)
	candle_light.position = Vector2()
	queue_free()
