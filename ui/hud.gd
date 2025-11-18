class_name HUD extends CanvasLayer


@onready var health_bar: TextureProgressBar = $HealthBar


func set_health(health: int) -> void:
	health_bar.value = health


func set_max_health(max_health: int) -> void:
	health_bar.max_value = max_health
