class_name Lumberjack extends NPC


signal gave_axe

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var chop_sound: AudioStreamPlayer2D = $ChopSound


func _on_interaction_finished() -> void:
	if DialogueGlobals.tree_state == DialogueGlobals.TreeStates.HAS_AXE and not player.has_axe:
		player.give_axe()
		gave_axe.emit()
	else:
		sprite.play(&"chop")


func _on_interaction_started() -> void:
	sprite.play(&"idle")


func _on_sprite_frame_changed() -> void:
	if sprite.frame == 3 and sprite.animation == &"chop":
		chop_sound.play()
