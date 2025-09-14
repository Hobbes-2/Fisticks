extends CharacterBody3D

@onready var punch_timer: Timer = $PunchTimer
@onready var standing_collision: CollisionShape3D = $StandingCollision
@onready var crouching_collision: CollisionShape3D = $CrouchingCollision
@onready var punch_collision: CollisionShape3D = $"Punch Area/PunchCollision"
@onready var hit_collision: CollisionShape3D = $HitBox/HitCollision

var health = 300

const SPEED = 5.0
const JUMP_VELOCITY = 7

func _ready() -> void:
	punch_collision.disabled = true


func _physics_process(delta: float) -> void:
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
		punch_timer.start()
		punch_collision.disabled = false
		await get_tree().create_timer(0.1).timeout
		punch_collision.disabled = true
		#await punch_timer.timeout
		print("FinishedPunch")

	if Input.is_action_just_pressed("P2Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if movement_dir:
		velocity.x = -movement_dir * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)



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

	if health <= 0:
		death()


func _on_hit_box_area_entered(area: Area3D) -> void:
	print("Player2 Health = " + str(health))
	health -= 1
	if health == 0:
		print("Player2 Died")

func death():
	get_tree().change_scene_to_file("res://Scenes/Players/Player 1/p_1_win.tscn")
