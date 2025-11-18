class_name FatherTime extends Enemy


const HEALTH_DRAIN := 0.1

var attack_number := 0

@onready var enemies: Node = $Enemies
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree.get(
		&"parameters/playback")
@onready var wolf_spawn_points: Node = $WolfSpawnPoints
@onready var bat_spawn_points: Node = $BatSpawnPoints
@onready var spawn_timer: Timer = $SpawnTimer
@onready var starting_position := global_position


func _ready() -> void:
	set_process(false)


func _process(delta: float) -> void:
	player.hit_box.health -= HEALTH_DRAIN * delta
	animation_tree.set(&"parameters/Walk/blend_position", target_velocity.normalized())
	animation_tree.set(&"parameters/Attack/blend_position", target_velocity.normalized())
	animation_tree.set(&"parameters/Die/blend_position", target_velocity.normalized())


func reset() -> void:
	spawn_timer.stop()
	set_process(false)
	global_position = starting_position
	hit_box.health = hit_box.max_health
	animation_tree.active = false
	for enemy in enemies.get_children():
		enemy.queue_free()


@warning_ignore("shadowed_variable_base_class")
func start(player: Player) -> void:
	spawn_timer.start()
	set_process(true)
	self.player = player
	animation_tree.active = true


func spawn_random() -> void:
	var BAT_CHANCE := 0.5
	if randf() <= BAT_CHANCE:
		spawn(preload("res://kinematic/enemy/bat.tscn"), bat_spawn_points)
	else:
		spawn(preload("res://kinematic/enemy/wolf.tscn"), wolf_spawn_points)


func spawn(ENEMY: PackedScene, spawn_points: Node) -> void:
	for spawn_point: Node2D in spawn_points.get_children():
		var enemy: Node2D = ENEMY.instantiate()
		enemy.global_position = spawn_point.global_position
		enemies.add_child(enemy)


func attack() -> void:
	can_move = false
	velocity = Vector2()
	playback.travel(&"Attack")


func _on_attack_zone_body_entered(_body: Node2D) -> void:
	attack()


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name.contains("attack"):
		can_move = true


func _on_spawn_timer_timeout() -> void:
	playback.travel(&"spawn_enemies")
