class_name World extends Node2D


@onready var tree_interaction: NPC = %TreeInteraction
@onready var organist: NPC = %Organist
@onready var candle_pickup: NPC = %CandlePickup


func _on_hag_interaction_finished() -> void:
	if organist:
		organist.queue_free()
		candle_pickup.input_enabled = true


func _on_lumberjacks_tree_chopped() -> void:
	DialogueGlobals.tree_state = DialogueGlobals.TreeStates.CUT_LUMBERJACKS_TREE


func _on_west_tree_chopped() -> void:
	pass # TODO Delete Lumberjack's place.


func _on_lumberjack_gave_axe() -> void:
	tree_interaction.queue_free()
