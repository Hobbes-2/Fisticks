extends CharacterBody3D

@onready var punch_timer: Timer = $PunchTimer
@onready var collision_shape_3d: CollisionShape3D = $"Punch Area/CollisionShape3D"

var health = 3

const SPEED = 5.0
const JUMP_VELOCITY = 4

func _ready() -> void:
	collision_shape_3d.disabled = true


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	var movement_dir = (
		Input.get_action_strength("P2Left") -
		Input.get_action_strength("P2Right")
	)

	# Handle jump.
	if Input.is_action_just_pressed("P2Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("P2Left", "P2Right", "ui_up", "ui_down")
	if Input.is_action_just_pressed("P2Punch") and punch_timer.timeout:
		punch_timer.start()
		collision_shape_3d.disabled = false
		await get_tree().create_timer(0.1).timeout
		collision_shape_3d.disabled = true
		#await punch_timer.timeout
		print("FinishedPunch")

	if Input.is_action_just_pressed("P1Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if movement_dir:
		velocity.x = -movement_dir * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()




func _on_hit_box_area_entered(area: Area3D) -> void:
	print("Player2 Health = " + str(health))
	health -= 1
	if health == 0:
		print("Player2 Died")
