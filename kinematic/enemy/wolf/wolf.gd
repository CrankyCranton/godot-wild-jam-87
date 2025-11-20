class_name Wolf extends Enemy


@export var lunge_speed := 128.0
@export var max_circle_angle := 90.0
@export var circle_start_distance := 128
@export var lunge_duration := 1.0

var circle_direcion := randi() % 2 * 2 - 1 # Either -1 or 1

@onready var lunge_collision_shape: CollisionShape2D = %LungeCollisionShape
@onready var lunge_sound: AudioStreamPlayer2D = $LungeSound


func _ready() -> void:
	max_circle_angle = deg_to_rad(max_circle_angle)


func get_move_vector(target: Vector2) -> Vector2:
	# Clamp it so it will fall off at distances larger than circle_start_distance.
	var distance := minf(global_position.distance_to(target), circle_start_distance)
	# Flip it so the scalar will get bigger as the wolf gets closer.
	var distance_scalar := remap(distance / circle_start_distance, 0.0, 1.0, 1.0, 0.0)
	return global_position.direction_to(target).rotated(
			max_circle_angle * distance_scalar * circle_direcion)


func die() -> void:
	super()
	lunge_collision_shape.set_deferred(&"disabled", true)


func _on_lunge_area_body_entered(body: Node2D) -> void:
	if not stunned:
		lunge_sound.play()
		lunge_collision_shape.set_deferred(&"disabled", true)
		await bounce(global_position.direction_to(body.global_position) * lunge_speed,
				lunge_duration)
		if not dead:
			lunge_collision_shape.set_deferred(&"disabled", false)
