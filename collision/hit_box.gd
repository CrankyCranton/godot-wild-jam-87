class_name HitBox extends Area2D


signal died
signal health_changed(health: int)
signal max_health_changed(max_health: int)
signal hurt(damage: int, source: HurtBox)
signal healed(healing: int)
signal immunity_timed_out

@export var max_health := 3:
	set(value):
		var difference := value - max_health
		max_health = value
		max_health_changed.emit()
		if difference > 0:
			health += difference
		else:
			health = health # Call the setter to clamp it.
@export var immunity_time := 0.0

var immune := false

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var health := max_health:
	set(value):
		health = mini(value, max_health)
		health_changed.emit(health)


func immunity_timeout() -> void:
	immune = false
	collision_shape.set_deferred(&"disabled", false)
	immunity_timed_out.emit()


func take_damage(damage: int, source: HurtBox) -> void:
	if immune:
		return
	health -= damage

	if immunity_time > 0.0:
		immune = true
		collision_shape.set_deferred(&"disabled", true)
		get_tree().create_timer(immunity_time, false).timeout.connect(immunity_timeout)

	hurt.emit(damage, source)
	if health <= 0:
			died.emit()


func heal(healing: int) -> void:
	health = mini(health + healing, max_health)
	healed.emit(healing)


@warning_ignore("shadowed_variable")
func set_health(health: int) -> void:
	self.health = health
