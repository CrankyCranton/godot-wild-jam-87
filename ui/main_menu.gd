class_name MainMenu extends Control


@onready var start_button: Button = %StartButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	if OS.get_name() == "Web":
		quit_button.hide()
	start_button.grab_focus()


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/first_cutscene/first_cutscene.tscn")


func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/credits/credits.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
