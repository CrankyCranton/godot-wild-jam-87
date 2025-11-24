class_name CreepSpawner extends Area2D


@export var CREEP: PackedScene
@export var min_cooldown := 120.0
@export var max_cooldown := 240.0

var is_timed_out := false

@onready var cooldown: Timer = $Cooldown
@onready var spawn_points: Node2D = $SpawnPoints


func set_paused(paused: bool) -> void:
	cooldown.paused = paused


func reset() -> void:
	cooldown.stop()
	cooldown.timeout.emit()


func _on_timeout_timeout() -> void:
	is_timed_out = false


func _on_body_entered(_body: Node2D) -> void:
	if is_timed_out:
		return

	for spawn_point: Node2D in spawn_points.get_children():
		var creep: Node2D = CREEP.instantiate()
		creep.position = spawn_point.position
		call_deferred(&"add_child", creep)

	is_timed_out = true
	cooldown.start(randf_range(min_cooldown, max_cooldown))
