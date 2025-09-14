extends StaticBody3D

@onready var collision: CollisionShape3D = $CollisionShape3D
@export var player : CharacterBody3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_layer = 2

func _process(delta: float) -> void:
	if player.global_position.y >= global_position.y + 0.1:
		collision_layer = 1
	elif player.global_position.y <= global_position.y + 0.1:
		collision_layer = 2
