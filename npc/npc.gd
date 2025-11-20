class_name NPC extends Area2D


signal interaction_started
signal interaction_finished

const DIALOGUE := preload("res://dialogue/dialogue.dialogue")
const BALLOON := preload("res://dialogue/balloon.tscn")

@export var dialogue := &""
@export var force_interaction := false
@export var input_enabled := true
@export var delay := 0.0
@export var checkpoint: Node2D

var player: Player
var interacting := false

@onready var label: Label = $Label


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"interact") and player \
			and input_enabled and not player.frozen:
		interact()


func interact() -> void:
	player.hit_box.set_immune()
	interacting = true
	if checkpoint:
		player.checkpoint = checkpoint.global_position
	label.hide()
	player.frozen = true
	player.velocity = Vector2()
	set_creep_spawn_timers_paused(true)

	if delay:
		await get_tree().create_timer(delay, false).timeout
	DialogueManager.show_dialogue_balloon_scene(BALLOON, DIALOGUE, dialogue)
	interaction_started.emit()
	await DialogueManager.dialogue_ended

	set_creep_spawn_timers_paused(false)
	if not force_interaction:
		label.show()
	player.frozen = false
	interacting = false
	interaction_finished.emit()
	player.hit_box.immune = false


func set_creep_spawn_timers_paused(paused: bool) -> void:
	for creep_spawner: CreepSpawner in get_tree().get_nodes_in_group(&"creep_spawners"):
		creep_spawner.set_paused(paused)


func _on_body_entered(body: Node2D) -> void:
	player = body
	if force_interaction:
		interact()
	elif input_enabled:
		label.show()


func _on_body_exited(_body: Node2D) -> void:
	if interacting:
		await interaction_finished
		if get_overlapping_bodies().size() > 0:
			return
	player = null
	label.hide()
