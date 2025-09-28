extends CharacterBody3D

@onready var punch_timer: Timer = $PunchTimer
@onready var standing_collision: CollisionShape3D = $StandingCollision
@onready var crouching_collision: CollisionShape3D = $CrouchingCollision
@onready var punch_collision: CollisionShape3D = $"Punch Area/PunchCollision"
@onready var hit_collision: CollisionShape3D = $HitBox/HitCollision
@export var player1 : CharacterBody3D
@export var low_death : Area3D
@onready var sounds: AudioStreamPlayer = $Sounds

@export var debug : bool
#ANIMS
@onready var stickman_1new: Node3D = $Stickman1NEW
var animations
#SHADER STUFF
@onready var shaders: MeshInstance3D = $"../CameraController/Camera3D2/Shaders"
var wireShader = preload("res://Shaders/GreenCrt.tres")
var outlineShader = preload("res://Shaders/CellShader.tres")
var current_hitstop
#STAT MODS
var SPEED
var NORMAL_SPEED = GlobalCards.player2Speed
var DODGE_SPEED = NORMAL_SPEED * 2
var CROUCHING_SPEED = NORMAL_SPEED / 2
const JUMP_VELOCITY = 7
var health = GlobalCards.player2Health

var going_left : bool = false
var going_right : bool = false

var current_timestamp = 0

#DAMAGE MODIFIERS
var damage = GlobalCards.player1Damage

func _ready() -> void:
	punch_collision.disabled = true
	SPEED = NORMAL_SPEED
	animations = stickman_1new.animation_player


func _physics_process(delta: float) -> void:
	current_timestamp += delta * 1000
	if debug == true:
		print(current_timestamp)

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	var movement_dir = (
		Input.get_action_strength("P2Left") -
		Input.get_action_strength("P2Right")
	)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("P2Left", "P2Right", "ui_up", "ui_down")
	if Input.is_action_just_pressed("P2Punch") and punch_timer.timeout:
		animations.play("PunchStill")
		punch_timer.start()
		punch_collision.disabled = false
		await get_tree().create_timer(0.1).timeout
		punch_collision.disabled = true
		#await punch_timer.timeout
		print("FinishedPunch")
		animations.play("Punch2ToIdle")

	if Input.is_action_just_pressed("P2Jump") and is_on_floor():
		animations.play("Jumping")
		velocity.y = JUMP_VELOCITY

	if movement_dir:
		velocity.x = -movement_dir * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if going_left == true and Input.is_action_just_pressed("P2Left") and is_on_floor():
		rotation_degrees.y = -180
		going_left = false
		print("P2 Double Left")
		position.x -= 1
	else:
		if Input.is_action_just_pressed("P2Left"):
			rotation_degrees.y = -180
			if debug == true:
				print("left")
			current_timestamp = 0
			going_left = true
	if current_timestamp >= 500:
		going_left = false

	if going_right == true and Input.is_action_just_pressed("P2Right") and is_on_floor():
		rotation_degrees.y = 0
		going_right = false
		print("P2 Double Right")
		position.x += 1
	else:
		if Input.is_action_just_pressed("P2Right"):
			rotation_degrees.y = 0
			if debug == true:
				print("right")
			current_timestamp = 0
			going_right = true
	if current_timestamp >= 500:
		going_right = false


	move_and_slide()

	if Input.is_action_pressed("P2Crouch"):
		standing_collision.disabled = true
		crouching_collision.disabled = false
		hit_collision.scale.y = crouching_collision.scale.y
		hit_collision.global_position = crouching_collision.global_position
	if Input.is_action_just_released("P2Crouch"):
		standing_collision.disabled = false
		crouching_collision.disabled = true
		hit_collision.scale.y = standing_collision.scale.y
		hit_collision.global_position = standing_collision.global_position

	if Input.is_action_pressed("P2Left") or Input.is_action_pressed("P2Right"):
		animations.play("WalkForwards")


	if health <= 0:
		death()

	if animations.is_playing() == false or Input.is_anything_pressed() == false:
		animations.play("Idle")

func _on_hit_box_area_entered(area: Area3D) -> void:
	print("Player2 Health = " + str(health))
	if area == low_death:
		health = 0
		#IF YOU CHANGE ANY NODES OR ADD ANY NODES IN THE PLAYER TREE THEN CHECK TO MAKE SURE THIS STILL WORKS
	elif area == player1.get_child(2):
		sounds.play()
		health -= player1.damage
		shaders.set_surface_override_material(0, wireShader)
		#FRAME PAUSE CODE!
		hitStopShort()
		#IN OTHER INSTANCES CHANGE HITSTOPLONG() TO HITSTOPSHORT OR MEDIUM
		while await hitStopShort():
			return
		shaders.set_surface_override_material(0, outlineShader)
	if health == 0:
		print("Player2 Died")

func hitStopShort():
	Engine.time_scale = 0
	await get_tree().create_timer(0.15, true, false, true).timeout
	Engine.time_scale = 1.0

func hitStopMedium():
	Engine.time_scale = 0
	await get_tree().create_timer(0.3, true, false, true).timeout
	Engine.time_scale = 1.0

func hitStopLong():
	Engine.time_scale = 0
	await get_tree().create_timer(0.45, true, false, true).timeout
	Engine.time_scale = 1.0
func death():
	get_tree().change_scene_to_file("res://Scenes/Players/Player 1/p_1_win.tscn")
