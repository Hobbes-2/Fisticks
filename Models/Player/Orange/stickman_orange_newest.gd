extends Node3D

@onready var hatadd: Node3D = $HatAdd
@onready var cube_011: MeshInstance3D = $Tpose_001/Skeleton3D/Cube_011/Cube_011
@onready var mball_001: MeshInstance3D = $Tpose_001/Skeleton3D/Mball_001/Mball_001
@onready var cylinder_002: MeshInstance3D = $Tpose_001/Skeleton3D/Mball_001/Mball_001/Cylinder_002
@onready var cube_012: MeshInstance3D = $Tpose_001/Skeleton3D/Cube_012/Cube_012
@onready var cube_013: MeshInstance3D = $Tpose_001/Skeleton3D/Cube_013/Cube_013
@onready var cube_014: MeshInstance3D = $Tpose_001/Skeleton3D/Cube_014/Cube_014
@onready var cube_015: MeshInstance3D = $Tpose_001/Skeleton3D/Cube_015/Cube_015
@onready var cube_016: MeshInstance3D = $Tpose_001/Skeleton3D/Cube_016/Cube_016
@onready var cylinder_003: MeshInstance3D = $Tpose_001/Skeleton3D/Cube_016/Cube_016/Cylinder_003
@onready var cube_017: MeshInstance3D = $Tpose_001/Skeleton3D/Cube_017/Cube_017
@onready var cube: MeshInstance3D = $Tpose_001/Skeleton3D/Cube/Cube
@onready var cube_018: MeshInstance3D = $Tpose_001/Skeleton3D/Cube_018/Cube_018
@onready var cube_019: MeshInstance3D = $Tpose_001/Skeleton3D/Cube_019/Cube_019

@onready var anims: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func hitFlash() -> void:
	cube_011.material_override = load("res://Textures/hitflashTexture.tres")
	mball_001.material_override = load("res://Textures/hitflashTexture.tres")
	cylinder_002.material_override = load("res://Textures/hitflashTexture.tres")
	cube_012.material_override = load("res://Textures/hitflashTexture.tres")
	cube_013.material_override = load("res://Textures/hitflashTexture.tres")
	cube_014.material_override = load("res://Textures/hitflashTexture.tres")
	cube_015.material_override = load("res://Textures/hitflashTexture.tres")
	cube_016.material_override = load("res://Textures/hitflashTexture.tres")
	cylinder_003.material_override = load("res://Textures/hitflashTexture.tres")
	cube_017.material_override = load("res://Textures/hitflashTexture.tres")
	cube.material_override = load("res://Textures/hitflashTexture.tres")
	cube_018.material_override = load("res://Textures/hitflashTexture.tres")
	cube_019.material_override = load("res://Textures/hitflashTexture.tres")

	await get_tree().create_timer(0.1).timeout

	cube_011.material_override = load("res://Textures/stickman_orange_newest.tres")
	mball_001.material_override = load("res://Textures/stickman_orange_newest.tres")
	cylinder_002.material_override = load("res://Textures/stickman_orange_newest.tres")
	cube_012.material_override = load("res://Textures/stickman_orange_newest.tres")
	cube_013.material_override = load("res://Textures/stickman_orange_newest.tres")
	cube_014.material_override = load("res://Textures/stickman_orange_newest.tres")
	cube_015.material_override = load("res://Textures/stickman_orange_newest.tres")
	cube_016.material_override = load("res://Textures/stickman_orange_newest.tres")
	cylinder_003.material_override = load("res://Textures/stickman_orange_newest.tres")
	cube_017.material_override = load("res://Textures/stickman_orange_newest.tres")
	cube.material_override = load("res://Textures/stickman_orange_newest.tres")
	cube_018.material_override = load("res://Textures/stickman_orange_newest.tres")
	cube_019.material_override = load("res://Textures/stickman_orange_newest.tres")

	await get_tree().create_timer(0.1).timeout

	cube_011.material_override = load("res://Textures/hitflashTexture.tres")
	mball_001.material_override = load("res://Textures/hitflashTexture.tres")
	cylinder_002.material_override = load("res://Textures/hitflashTexture.tres")
	cube_012.material_override = load("res://Textures/hitflashTexture.tres")
	cube_013.material_override = load("res://Textures/hitflashTexture.tres")
	cube_014.material_override = load("res://Textures/hitflashTexture.tres")
	cube_015.material_override = load("res://Textures/hitflashTexture.tres")
	cube_016.material_override = load("res://Textures/hitflashTexture.tres")
	cylinder_003.material_override = load("res://Textures/hitflashTexture.tres")
	cube_017.material_override = load("res://Textures/hitflashTexture.tres")
	cube.material_override = load("res://Textures/hitflashTexture.tres")
	cube_018.material_override = load("res://Textures/hitflashTexture.tres")
	cube_019.material_override = load("res://Textures/hitflashTexture.tres")

	await get_tree().create_timer(0.1).timeout

	cube_011.material_override = load("res://Textures/stickman_orange_newest.tres")
	mball_001.material_override = load("res://Textures/stickman_orange_newest.tres")
	cylinder_002.material_override = load("res://Textures/stickman_orange_newest.tres")
	cube_012.material_override = load("res://Textures/stickman_orange_newest.tres")
	cube_013.material_override = load("res://Textures/stickman_orange_newest.tres")
	cube_014.material_override = load("res://Textures/stickman_orange_newest.tres")
	cube_015.material_override = load("res://Textures/stickman_orange_newest.tres")
	cube_016.material_override = load("res://Textures/stickman_orange_newest.tres")
	cylinder_003.material_override = load("res://Textures/stickman_orange_newest.tres")
	cube_017.material_override = load("res://Textures/stickman_orange_newest.tres")
	cube.material_override = load("res://Textures/stickman_orange_newest.tres")
	cube_018.material_override = load("res://Textures/stickman_orange_newest.tres")
	cube_019.material_override = load("res://Textures/stickman_orange_newest.tres")
