class_name Credits extends Control


@export var speed := 48.0
@export var input_speed := 256.0

@onready var credits_roll: VBoxContainer = $CreditsRoll


func _process(delta: float) -> void:
	credits_roll.position.y -= (speed + Input.get_axis(&"ui_up", &"ui_down") * input_speed) * delta
	var screen_height: int = ProjectSettings.get_setting(
			"display/window/size/viewport_height")
	credits_roll.position.y = clampf(credits_roll.position.y,
			-(credits_roll.size.y - screen_height), screen_height)


func _on_text_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")
