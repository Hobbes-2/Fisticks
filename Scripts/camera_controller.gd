extends Node3D

@export var player1 : CharacterBody3D
@export var player2 : CharacterBody3D
@onready var camera : Camera3D = $Camera3D2
@onready var mid_point_mesh: MeshInstance3D = $"../MidPoint"

@export var debug : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass 


func _physics_process(delta: float) -> void:
	var mid_point = (player1.global_position.x + player2.global_position.x) / 2
	var mid_point_y = (player1.global_position.y + player2.global_position.y) / 2

	#global_position.x = mid_point
	mid_point_mesh.global_position.x = mid_point
	mid_point_mesh.global_position.y = mid_point_y
	if debug == true:
		print(mid_point)

	#camera.global_position.z = abs(player1.global_position.x - player2.global_position.x) / 3.5
	camera.global_position.z = abs(player1.global_position.x - player1.global_position.y - player2.global_position.x - player1.global_position.y) / 5
	camera.global_position.x = mid_point
