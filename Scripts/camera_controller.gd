extends Node3D

@export var player1 : CharacterBody3D
@export var player2 : CharacterBody3D
@onready var camera : Camera3D = $Camera3D2
@onready var mid_point_mesh: MeshInstance3D = $"../MidPoint"

@export var debug : bool
#UI STUFF
@onready var p_1_health: Label3D = $Camera3D2/P1Health
@onready var p_1_speed: Label3D = $Camera3D2/P1Speed
@onready var p_1_damage: Label3D = $Camera3D2/P1Damage
@onready var p_2_health: Label3D = $Camera3D2/P2Health
@onready var p_2_speed: Label3D = $Camera3D2/P2Speed
@onready var p_2_damage: Label3D = $Camera3D2/P2Damage

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

	#camera.global_position.z = abs(player1.global_position.x - player2.global_position.x) / 3.aa5
	camera.global_position.z = abs(player1.global_position.x - player1.global_position.y - player2.global_position.x - player1.global_position.y) / 5
	camera.global_position.x = mid_point

	if camera.global_position.z >= 15:
		camera.global_position.z = 15

	p_1_health.text = "Player 1 Health = " + str(player1.health)
	p_1_speed.text = "Player 1 Speed = " + str(player1.SPEED)
	p_1_damage.text = "Player 1 Damage = " + str(player1.damage)

	p_2_health.text = "Player 1 Health = " + str(player2.health)
	p_2_speed.text = "Player 1 Speed = " + str(player2.SPEED)
	p_2_damage.text = "Player 1 Damage = " + str(player2.damage)
