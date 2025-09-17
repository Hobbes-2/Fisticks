extends CharacterBody3D

@onready var punch_area: Area3D = $"Punch Area"
@onready var punch_timer: Timer = $PunchTimer
@onready var standing_collision: CollisionShape3D = $StandingCollision
@onready var crouching_collision: CollisionShape3D = $CrouchingCollision
@onready var punch_collision: CollisionShape3D = $"Punch Area/PunchCollision"
@onready var hit_collision: CollisionShape3D = $HitBox/HitCollision
@export var player2 : CharacterBody3D
@export var low_death : Area3D
@export var debug : bool
@onready var sounds: AudioStreamPlayer = $Sounds

#SPEED AND SPEED MODIFIERS
var SPEED
var NORMAL_SPEED = GlobalCards.player1Speed
var DODGE_SPEED = NORMAL_SPEED * 2
var CROUCHING_SPEED = NORMAL_SPEED / 2
const JUMP_VELOCITY = 7
var health = GlobalCards.player1Health

var going_left : bool = false
var going_right : bool = false

var current_timestamp = 0

#DAMAGE MODIFIERS
var damage = GlobalCards.player1Damage

#Time.get_time_msec() or something
func _ready() -> void:
	punch_collision.disabled = true
	SPEED = NORMAL_SPEED
func _physics_process(delta: float) -> void:

	current_timestamp += delta * 1000
	if debug == true:
		print(current_timestamp)
	if not is_on_floor():
		velocity += get_gravity() * delta

	var movement_dir = (
		Input.get_action_strength("P1Left") -
		Input.get_action_strength("P1Right")
	)

	if Input.is_action_just_pressed("P1Punch") and punch_timer.timeout:
		current_timestamp = 0
		punch_timer.start()
		punch_collision.disabled = false
		await get_tree().create_timer(0.1).timeout
		punch_collision.disabled = true
		#await punch_timer.timeout
		print("FinishedPunch")

	if Input.is_action_just_pressed("P1Jump") and is_on_floor():
		current_timestamp = 0
		velocity.y = JUMP_VELOCITY

	if movement_dir:
		velocity.x = -movement_dir * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if going_left == true and Input.is_action_just_pressed("P1Left") and is_on_floor():
		rotation_degrees.y = 180
		going_left = false
		print("P1 Double Left")
		position.x -= 1
		#--ONE WAY I WAS TRYING
		#SPEED = DODGE_SPEED
		#await get_tree().create_timer(0.4)
		#SPEED = NORMAL_SPEED
		#--ANOTHER WAY THAT STILL DIDNT WORK
		#print(global_position.x)
		#move_toward(global_position.x, global_position.x - 100, -100)
		#print(global_position.x)

	else:
		if Input.is_action_just_pressed("P1Left"):
			rotation_degrees.y = 180
			if debug == true:
				print("left")
			current_timestamp = 0
			going_left = true
	if current_timestamp >= 500:
		going_left = false

	if going_right == true and Input.is_action_just_pressed("P1Right") and is_on_floor():
		rotation_degrees.y = 0
		going_right = false
		print("P1 Double Right")
		position.x += 1

	else:
		if Input.is_action_just_pressed("P1Right"):
			rotation_degrees.y = 0
			if debug == true:
				print("right")
			current_timestamp = 0
			going_right = true
	if current_timestamp >= 500:
		going_right = false

		#FIX THIS THIS IS NOT YET WORKING AND THE DOUBLE CLICK NEVER TRIGGERS
	move_and_slide()

	if Input.is_action_pressed("P1Crouch"):
		SPEED = CROUCHING_SPEED
		standing_collision.disabled = true
		crouching_collision.disabled = false
		hit_collision.scale.y = crouching_collision.scale.y
		hit_collision.global_position = crouching_collision.global_position
	if Input.is_action_just_released("P1Crouch"):
		SPEED = NORMAL_SPEED
		standing_collision.disabled = false
		crouching_collision.disabled = true
		hit_collision.scale.y = standing_collision.scale.y
		hit_collision.global_position = standing_collision.global_position
	if health <= 0:
		death()


func _on_hit_box_area_entered(area: Area3D) -> void:
	print("Player1 Health = " + str(health))
	if area == low_death:
		health = 0
	else:
		sounds.play()
		health -= player2.damage
	if health == 0:
		print("Player1 Died")


func death():
	get_tree().change_scene_to_file("res://Scenes/Players/Player 2/p_2_win.tscn")
