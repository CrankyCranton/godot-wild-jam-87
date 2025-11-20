class_name HurtBox extends Area2D


signal hurt(target: HitBox)

@export var damage := 1

func _on_area_entered(area: HitBox) -> void:
	area.take_damage(damage, self)
	hurt.emit(area)
