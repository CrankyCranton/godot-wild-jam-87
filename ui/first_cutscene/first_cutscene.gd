class_name FirstCutscene extends Control


func load_level() -> void:
	get_tree().change_scene_to_file("res://world/world.tscn")


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	load_level()


func _on_skip_button_pressed() -> void:
	load_level()
