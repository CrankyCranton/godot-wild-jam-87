class_name NPC extends Area2D


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
	DialogueManager.show_dialogue_balloon_scene(BALLOON, DIALOGUE, dialogue)
	if delay:
		await get_tree().create_timer(delay, false).timeout
	await DialogueManager.dialogue_ended
	label.show()
	player.can_move = true


func _on_body_entered(body: Node2D) -> void:
	player = body
	if force_interaction:
		interact()
	else:
		label.show()


func _on_body_exited(_body: Node2D) -> void:
	player = null
	label.hide()
