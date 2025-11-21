class_name Credits extends Control


func _on_text_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")
