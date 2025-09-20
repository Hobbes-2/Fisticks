extends StaticBody3D

@onready var player_2_collision: CollisionShape3D = $Player2Collision
@onready var player_1_collision: CollisionShape3D = $Player1Collision
@export var player1 : CharacterBody3D
@export var player2 : CharacterBody3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if player1.global_position.y >= global_position.y + 0.1:
		set_collision_layer_value(1, true)
	elif player1.global_position.y <= global_position.y + 0.1:
		set_collision_layer_value(1, false)
	if player2.global_position.y >= global_position.y + 0.1:
		set_collision_layer_value(2, true)
	elif player2.global_position.y <= global_position.y + 0.1:
		set_collision_layer_value(2, false)
