extends CharacterBody3D

@onready var punch_area: Area3D = $"Punch Area"
@onready var punch_timer: Timer = $PunchTimer
@onready var standing_collision: CollisionShape3D = $StandingCollision
@onready var crouching_collision: CollisionShape3D = $CrouchingCollision
@onready var punch_collision: CollisionShape3D = $"Punch Area/PunchCollision"
@onready var hit_collision: CollisionShape3D = $HitBox/HitCollision

@export var debug : bool

const SPEED = 5.0
const JUMP_VELOCITY = 4

var health = 3

var current_timestamp = 0
#Time.get_time_msec() or something
func _ready() -> void:
	punch_collision.disabled = true

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


	if Input.is_action_just_pressed("P1Left"):
		print("left")
		current_timestamp = 0
		await get_tree().create_timer(0.04).timeout
		#FIX THIS THIS IS NOT YET WORKING AND THE DOUBLE CLICK NEVER TRIGGERS
		if Input.is_action_just_pressed("P1Left") and current_timestamp <= 1000:
			print("Double Left")
	move_and_slide()

	if Input.is_action_pressed("P1Crouch"):
		standing_collision.disabled = true
		crouching_collision.disabled = false
		hit_collision.scale.y = crouching_collision.scale.y
		hit_collision.global_position = crouching_collision.global_position
	if Input.is_action_just_released("P1Crouch"):
		standing_collision.disabled = false
		crouching_collision.disabled = true
		hit_collision.scale.y = standing_collision.scale.y
		hit_collision.global_position = standing_collision.global_position
	if health <= 0:
		death()


func _on_hit_box_area_entered(area: Area3D) -> void:
	print("Player1 Health = " + str(health))
	health -= 1
	if health == 0:
		print("Player1 Died")

func death():
	get_tree().change_scene_to_file("res://Scenes/Players/Player 2/p_2_win.tscn")
