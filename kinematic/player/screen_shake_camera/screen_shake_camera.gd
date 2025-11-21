class_name ScreenShakeCamera extends Camera2D


@warning_ignore("shadowed_global_identifier")
func shake(vibrations: int, frequency: float, range: Vector2) -> void:
	for i in vibrations:
		await create_tween().tween_property(self, ^"offset", Vector2(randf_range(-range.x, range.x),
				randf_range(-range.y, range.y)), frequency).finished
