extends Node3D

@export var player1 : CharacterBody3D
@export var player2 : CharacterBody3D
@onready var camera : Camera3D = $Camera3D2
@onready var mid_point_mesh: MeshInstance3D = $"../MidPoint"

@export var debug : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#camera.position.z = abs(player1.global_position.x - player2.global_position.x) * 0.2
	#print(abs(player1.global_position.x - player2.global_position.x))

	#var player_x = player1.global_position.x + player2.global_position.x
	#var new_position = global_position
	#new_position.x = player_x
	#global_position = new_position


	var mid_point = (player1.global_position.x + player2.global_position.x) / 2

	#global_position.x = mid_point
	mid_point_mesh.global_position.x = mid_point
	if debug == true:
		print(mid_point)

	camera.global_position.z = abs(player1.global_position.x - player2.global_position.x) / 3.5
	camera.global_position.x = mid_point

#@export var move_speed = 30
#@export var zoom_speed = 3.0
#@export var min_zoom = 5.0
#@export var max_zoom = 0.5
#@export var margin = Vector2(400, 200)
#
#var targets = [player1, player2]
#
#@onready var screen_size = DisplayServer.screen_get_size()
#
#var twod_position = Vector2(position.x, position.y)
#
#
#func _physics_process(delta: float) -> void:
	#var player1_twod_position = Vector2(player1.position.x, player1.position.y)
	#var player2_twod_position = Vector2(player2.position.x, player2.position.y)
	#if !targets:
		#return
#
 ## Keep the camera centered among all targets
	#var p = Vector3.ZERO
	##for target in targets:
		##p += targets[target].position
	#p += player1.position
	#p += player2.position
	#p /= targets.size()
	#position = lerp(position, p, move_speed * delta)
#
 ## Find the zoom that will contain all targets
	#var r = Rect2(twod_position, Vector2.ONE)
	#for target in targets:
		#r = r.expand(player1_twod_position)
		#r = r.expand(player2_twod_position)
#
	#r = r.grow_individual(margin.x, margin.y, margin.x, margin.y)
	#var z = 1 / clamp(r.size.x / screen_size.x, max_zoom, min_zoom)
	##if r.size.x > r.size.y * screen_size.aspect():
		##z = 1 / clamp(r.size.x / screen_size.x, max_zoom, min_zoom)
	##else:
		##z = 1 / clamp(r.size.y / screen_size.y, max_zoom, min_zoom)
	#position = Vector3(camera.fov, z, zoom_speed * delta)
#
#
#func add_target(t):
	#if not t in targets:
		#targets.append(t)
#
#func remove_target(t):
	#if t in targets:
		#targets.remove(t)
