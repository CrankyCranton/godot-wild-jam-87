class_name ChoppableTree extends StaticBody2D


signal chopped

@onready var hit_box: HitBox = $HitBox
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _on_hit_box_died() -> void:
	hit_box.immune = true
	collision_shape.set_deferred(&"disabled", true)
	hide()
	chopped.emit()


func _on_death_sound_finished() -> void:
	queue_free()
