class_name World extends Node2D


@onready var tree_interaction: NPC = %TreeInteraction
@onready var cave_enterance_dialogue: NPC = %CaveEnteranceDialogue
@onready var organist: NPC = %Organist
@onready var mother_and_child: NPC = %MotherAndChild
@onready var candle_pickup: NPC = %CandlePickup
@onready var ambience: AudioStreamPlayer = $Ambience
@onready var darkness: CanvasModulate = $Darkness
@onready var player: Player = %Player
@onready var gates_collision: CollisionShape2D = %GatesCollision
@onready var father_time_gates: StaticBody2D = %FatherTimeGates
@onready var close_zone: Area2D = %CloseZone
@onready var close_shape: CollisionShape2D = close_zone.get_node(^"CollisionShape2D")
@onready var lumberjack_region: Node2D = %LumberjackRegion
@onready var father_time: FatherTime = %FatherTime
@onready var wind: AudioStreamPlayer = $Ambience
@onready var hag: NPC = %Hag
@onready var god_rays: ColorRect = $GodRays
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var end_zone_shape: CollisionPolygon2D = %EndZoneShape
@onready var map_edge: TileMapLayer = %MapEdge
@onready var blockade_sprite: Sprite2D = %BlockadeSprite
@onready var default_darkness := darkness.color


func _on_hag_interaction_finished() -> void:
	if organist:
		organist.queue_free()
		candle_pickup.input_enabled = true


func _on_lumberjacks_tree_chopped() -> void:
	DialogueGlobals.tree_state = DialogueGlobals.TreeStates.CUT_LUMBERJACKS_TREE


func _on_west_tree_chopped() -> void:
	lumberjack_region.queue_free()
	map_edge.enabled = true


func _on_lumberjack_gave_axe() -> void:
	tree_interaction.queue_free()


func _on_house_interior_door_exited() -> void:
	if DialogueGlobals.spoke_to_mother_and_child and mother_and_child:
		mother_and_child.queue_free()


func _on_candle_pickup_interaction_finished() -> void:
	cave_enterance_dialogue.queue_free()


func _on_father_time_died() -> void:
	god_rays.show()
	end_zone_shape.set_deferred(&"disabled", false)
	father_time_gates.queue_free()
	hag.queue_free()
	if mother_and_child:
		mother_and_child.queue_free()
	for creep_spawner in get_tree().get_nodes_in_group(&"creep_spawners"):
		creep_spawner.queue_free()
	player.shake_cam()


func _on_muffle_zone_body_entered(_body: Node2D) -> void:
	ambience.bus = &"Muffled"
	player.outdoors = false


func _on_muffle_zone_body_exited(_body: Node2D) -> void:
	ambience.bus = &"Master"
	player.outdoors = true


func _on_cave_zone_body_entered(body: Player) -> void:
	body.set_near_sight_active(true)
	darkness.color = Color(0.15, 0.075, 0.0, 1.0) if body.has_candle else Color.BLACK


func _on_cave_zone_body_exited(body: Player) -> void:
	body.set_near_sight_active(false)
	darkness.color = default_darkness


func _on_player_died() -> void:
	gates_collision.set_deferred(&"disabled", true)
	close_shape.set_deferred(&"disabled", false)
	blockade_sprite.hide()
	father_time.reset()


func _on_end_zone_body_entered(body: Player) -> void:
	body.frozen = true
	body.animation_tree.set(&"parameters/Idle/blend_position", Vector2.UP)
	body.playback.travel(&"Idle")
	animation_player.play(&"end")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://ui/credits/credits.tscn")


func _on_close_zone_interaction_finished() -> void:
	if father_time.active:
		return
	gates_collision.set_deferred(&"disabled", false)
	close_shape.set_deferred(&"disabled", true)
	blockade_sprite.show()
	father_time.start(player)


func _on_organist_interaction_started() -> void:
	for node in organist.get_children():
		if node is AudioStreamPlayer2D:
			node.stream_paused = true


func _on_organist_interaction_finished() -> void:
	#await get_tree().create_timer(0.5).timeout
	for node in organist.get_children():
		if node is AudioStreamPlayer2D:
			node.stream_paused = false
