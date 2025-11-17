class_name ChoppableTree extends StaticBody2D


signal chopped


func _on_hit_box_died() -> void:
	chopped.emit()
	queue_free()
