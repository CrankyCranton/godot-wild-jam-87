class_name CreepSpawner extends Area2D


@export var CREEP: PackedScene
@export var min_timeout := 60.0
@export var max_timeout := 180.0

var is_timed_out := false

@onready var timeout: Timer = $Timeout
@onready var spawn_points: Node2D = $SpawnPoints


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
	timeout.start(randf_range(min_timeout, max_timeout))
