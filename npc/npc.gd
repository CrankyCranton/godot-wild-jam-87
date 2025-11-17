class_name NPC extends Area2D


signal interaction_finished

const DIALOGUE := preload("res://dialogue/dialogue.dialogue")
const BALLOON := preload("res://dialogue/balloon.tscn")

@export var dialogue := &""
@export var force_interaction := false
@export var delay := 0.0

var player: Player

@onready var label: Label = $Label


func _input(event: InputEvent) -> void:
	if event.is_action_pressed(&"interact") and player and player.can_move:
		interact()


func interact() -> void:
	label.hide()
	player.can_move = false
	player.velocity = Vector2()
	set_creep_spawn_timers_paused(true)
	DialogueManager.show_dialogue_balloon_scene(BALLOON, DIALOGUE, dialogue)

	if delay:
		await get_tree().create_timer(delay, false).timeout
	await DialogueManager.dialogue_ended

	set_creep_spawn_timers_paused(false)
	if not force_interaction:
		label.show()
	player.can_move = true
	interaction_finished.emit()


func set_creep_spawn_timers_paused(paused: bool) -> void:
	for timer: Timer in get_tree().get_nodes_in_group(&"creep_spawn_timers"):
		timer.paused = paused


func _on_body_entered(body: Node2D) -> void:
	player = body
	if force_interaction:
		interact()
	else:
		label.show()


func _on_body_exited(_body: Node2D) -> void:
	player = null
	label.hide()
