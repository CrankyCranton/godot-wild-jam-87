extends NPC


func _on_interaction_finished() -> void:
	DialogueGlobals.tree_state = DialogueGlobals.TreeStates.SAW_TREE
