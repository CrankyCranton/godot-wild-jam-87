# DEPRECATED
extends Node2D


func _ready() -> void:
	rotation_degrees = -90.0
	#var tree_index := randi() % get_child_count()
	for child: Node2D in get_children():
		#child.visible = child.get_index() == tree_index
		child.rotation_degrees += 90.0
