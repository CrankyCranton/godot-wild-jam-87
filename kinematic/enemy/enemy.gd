class_name Enemy extends Kinematic


@export var soft_collider_strength := 64.0
@export var max_warn_delay := 1.0
@export var health_drop_chance := 0.4

var player: Player
var can_warn := true

@onready var warning_sound_cooldown: Timer = $WarningSoundCooldown
@onready var soft_collider: SoftCollider = $SoftCollider
@onready var warning_sound: Node = $WarningSound
@onready var health_bar: ProgressBar = $HealthBar
@onready var hurt_box_shape: CollisionShape2D = $HurtBox/CollisionShape2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	await get_tree().create_timer(0.5, false).timeout
	hurt_box_shape.set_deferred(&"disabled", false)


func physics_process(_delta: float) -> void:
	if player:
		target_velocity = get_move_vector(player.global_position) * speed
	else:
		target_velocity = Vector2()
	target_velocity += soft_collider.get_velocity() * soft_collider_strength


func get_move_vector(target: Vector2) -> Vector2:
	return global_position.direction_to(target)


func die() -> void:
	collision_shape.set_deferred(&"disabled", true)
	hurt_box_shape.set_deferred(&"disabled", true)
	if randf() < health_drop_chance:
		var health_pickup: HealthPickup = preload(
				"res://pickups/health_pickup/health_pickup.tscn").instantiate()
		health_pickup.position = position
		call_deferred(&"add_sibling", health_pickup)


func play_warning_sound() -> void:
	can_warn = false
	await get_tree().create_timer(max_warn_delay * randf(), false).timeout
	warning_sound.play()
	warning_sound_cooldown.start()


func _on_vision_body_entered(body: Node2D) -> void:
	player = body
	if can_warn:
		play_warning_sound()


func _on_vision_body_exited(_body: Node2D) -> void:
	player = null


func _on_warning_sound_cooldown_timeout() -> void:
	can_warn = true


func _on_hit_box_health_changed(health: float) -> void:
	if not is_node_ready():
		await ready
	health_bar.value = health


func _on_hit_box_max_health_changed(max_health: int) -> void:
	if not is_node_ready():
		await ready
	health_bar.max_value = max_health
