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
@onready var father_time_gates: StaticBody2D = $FatherTimeGates
@onready var close_zone: Area2D = %CloseZone
@onready var close_zone_collision: CollisionShape2D = %CloseZoneCollision
@onready var lumberjack_region: Node2D = %LumberjackRegion
@onready var father_time: FatherTime = %FatherTime
@onready var default_darkness := darkness.color


func _on_hag_interaction_finished() -> void:
	if organist:
		organist.queue_free()
		candle_pickup.input_enabled = true


func _on_lumberjacks_tree_chopped() -> void:
	DialogueGlobals.tree_state = DialogueGlobals.TreeStates.CUT_LUMBERJACKS_TREE


func _on_west_tree_chopped() -> void:
	lumberjack_region.queue_free()


func _on_lumberjack_gave_axe() -> void:
	tree_interaction.queue_free()


func _on_house_interior_door_exited() -> void:
	if DialogueGlobals.spoke_to_mother_and_child and mother_and_child:
		mother_and_child.queue_free()


func _on_candle_pickup_interaction_finished() -> void:
	cave_enterance_dialogue.queue_free()


# TODO Move closing gates to it's own scene and script.
func _on_close_zone_body_entered(body: Player) -> void:
	print(body)
	gates_collision.set_deferred(&"disabled", false)
	close_zone_collision.set_deferred(&"disabled", true)
	father_time.start(body)


func _on_father_time_died() -> void:
	father_time_gates.queue_free()
	for creep_spawner in get_tree().get_nodes_in_group(&"creep_spawners"):
		creep_spawner.queue_free()


func _on_muffle_zone_body_entered(_body: Node2D) -> void:
	ambience.bus = &"Muffled"


func _on_muffle_zone_body_exited(_body: Node2D) -> void:
	ambience.bus = &"Master"


func _on_cave_zone_body_entered(body: Player) -> void:
	body.set_near_sight_active(true)
	darkness.color = Color(0.251, 0.125, 0.0, 1.0) if body.has_candle else Color.BLACK


func _on_cave_zone_body_exited(body: Player) -> void:
	body.set_near_sight_active(false)
	darkness.color = default_darkness


func _on_player_died() -> void:
	await get_tree().physics_frame
	gates_collision.set_deferred(&"disabled", true)
	close_zone_collision.set_deferred(&"disabled", false)
