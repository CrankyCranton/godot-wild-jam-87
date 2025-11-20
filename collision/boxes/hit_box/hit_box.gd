class_name HitBox extends Area2D


signal died
signal health_changed(health: float)
signal max_health_changed(max_health: int)
signal hurt(damage: int, source: HurtBox)
signal healed(healing: int)
signal immunity_timed_out

@export var immunity_time := 0.0
@export var max_health := 3.0:
	set(value):
		max_health = value
		max_health_changed.emit(max_health)
		if health > max_health:
			health = max_health

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var hit_sound: AudioStreamPlayer2D = $HitSound
@onready var death_sound: AudioStreamPlayer2D = $DeathSound
@onready var immunity_timer: Timer = $ImmunityTimer
@onready var health := 0.0:
	set(value):
		health = minf(value, max_health)
		health_changed.emit(health)
@onready var immune := false:
	set(value):
		immune = value
		collision_shape.set_deferred(&"disabled", immune)


func _ready() -> void:
	max_health_changed.emit(max_health)
	health = max_health


func set_immune(time := 0.0) -> void:
	immune = true
	if time > 0.0:
		immunity_timer.start(time)
	else:
		immunity_timer.stop()


func take_damage(damage: int, source: HurtBox) -> void:
	if immune:
		return
	health -= damage

	if immunity_time > 0.0:
		set_immune(immunity_time)

	hurt.emit(damage, source)
	hit_sound.play()
	if health <= 0:
		died.emit()
		death_sound.play()


func heal(healing: int) -> void:
	health += healing
	healed.emit(healing) # Note: The healing passed here isn't clamped.


func _on_immunity_timer_timeout() -> void:
	immune = false
	immunity_timed_out.emit()
