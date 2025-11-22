class_name Villager extends NPC


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if DialogueGlobals.spoke_to_villager:
		queue_free()
