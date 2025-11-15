class_name HurtBox extends Area2D


@export var ignore_list: Array[StringName]
@export var damage := 1


func in_ignore_list(group: StringName) -> bool:
	return group in ignore_list


func _on_area_entered(area: HitBox) -> void:
	if area.get_groups().any(in_ignore_list):
		return
	area.take_damage(damage, self)
