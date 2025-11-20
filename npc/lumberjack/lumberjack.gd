class_name Lumberjack extends NPC


signal gave_axe


func _on_interaction_finished() -> void:
	if DialogueGlobals.tree_state == DialogueGlobals.TreeStates.HAS_AXE and not player.has_axe:
		player.give_axe()
		gave_axe.emit()
