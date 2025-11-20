class_name FatherTime extends Enemy


const HEALTH_DRAIN := 0.1
const RAMPAGE_HP := 30

@onready var enemies: Node = $Enemies
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree.get(
		&"parameters/playback")
@onready var wolf_spawn_points: Node = $WolfSpawnPoints
@onready var bat_spawn_points: Node = $BatSpawnPoints
@onready var spawn_timer: Timer = $SpawnTimer
@onready var orb_spawn_point: Marker2D = $OrbSpawnPoint
@onready var boss_health_bar: ProgressBar = %BossHealthBar
@onready var starting_position := global_position


func _process(_delta: float) -> void:
	animation_tree.set(&"parameters/Walk/blend_position", target_velocity.normalized())
	animation_tree.set(&"parameters/Attack/blend_position", target_velocity.normalized())
	animation_tree.set(&"parameters/Die/blend_position", target_velocity.normalized())


func _on_hit_box_health_changed(health: float) -> void:
	if not is_node_ready():
		await ready
	boss_health_bar.value = health
	if health <= RAMPAGE_HP:
		spawn_timer.wait_time /= 2.0


func _on_hit_box_max_health_changed(max_health: int) -> void:
	if not is_node_ready():
		await ready
	boss_health_bar.max_value = max_health


@warning_ignore("shadowed_variable_base_class")
func start(player: Player) -> void:
	boss_health_bar.show()
	spawn_timer.start()
	self.player = player
	animation_tree.active = true


func reset() -> void:
	boss_health_bar.hide()
	spawn_timer.stop()
	global_position = starting_position
	hit_box.health = hit_box.max_health
	animation_tree.active = false
	for enemy in enemies.get_children():
		enemy.queue_free()


func spawn_random() -> void:
	var bag := ["bat", "wolf", "orb"]
	match bag.pick_random():
		"bat":
			spawn(preload("res://kinematic/enemy/bat/bat.tscn"), bat_spawn_points)
		"wolf":
			spawn(preload("res://kinematic/enemy/wolf/wolf.tscn"), wolf_spawn_points)
		"orb":
			spawn_orbs(6)


func spawn(ENEMY: PackedScene, spawn_points: Node) -> void:
	for spawn_point: Node2D in spawn_points.get_children():
		var enemy: Node2D = ENEMY.instantiate()
		enemy.global_position = spawn_point.global_position
		enemies.add_child(enemy)


func spawn_orbs(orb_count: int) -> void:
	const TIME_ORB := preload("res://kinematic/enemy/father_time/time_orb/time_orb.tscn")
	var offset := randf() * TAU
	for i in range(1, orb_count + 1):
		var time_orb: TimeOrb = TIME_ORB.instantiate()
		time_orb.global_position = orb_spawn_point.global_position
		time_orb.direction = Vector2.RIGHT.rotated((float(i) / orb_count * TAU) + offset)
		enemies.add_child(time_orb)


func _on_spawn_timer_timeout() -> void:
	playback.travel(&"spawn_enemies")


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == &"spawn_enemies":
		stunned = false


func _on_animation_tree_animation_started(anim_name: StringName) -> void:
	if anim_name == &"spawn_enemies":
		stunned = true
		velocity = Vector2()
