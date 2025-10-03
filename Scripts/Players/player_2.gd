extends CharacterBody3D

@onready var punch_area: Area3D = $"Punch Area"
@onready var punch_timer: Timer = $PunchTimer
@onready var standing_collision: CollisionShape3D = $StandingCollision
@onready var crouching_collision: CollisionShape3D = $CrouchingCollision
@onready var punch_collision: CollisionShape3D = $"Punch Area/PunchCollision"
@onready var hit_collision: CollisionShape3D = $HitBox/HitCollision
@export var player1 : CharacterBody3D
@export var low_death : Area3D
@export var debug : bool
@onready var sounds: AudioStreamPlayer = $Sounds
#SHADER STUFF
@onready var shaders: MeshInstance3D = $"../CameraController/Camera3D2/Shaders"
var wireShader = preload("res://Shaders/GreenCrt.tres")
var outlineShader = preload("res://Shaders/CellShader.tres")
var current_hitstop
#ANIMATIONS AND MODEL STUFF
@onready var stickman_2new: Node3D = $StickmanOrangeNewest
var animations
#SPEED AND SPEED MODIFIERS
var SPEED
var NORMAL_SPEED = GlobalCards.player1Speed
var DODGE_SPEED = NORMAL_SPEED * 2
var CROUCHING_SPEED = NORMAL_SPEED / 2
const JUMP_VELOCITY = 5
var health = GlobalCards.player1Health

var going_left : bool = false
var going_right : bool = false

var current_timestamp = 0

#DAMAGE MODIFIERS
var damage = GlobalCards.player1Damage

#KNOCKBACK VARS
var is_knockback = false
var knockback_timer = 0.0
var knockback_duration = 0.5
var knockbackVal = 1.0

@export var angle = 90
var hdecay = 1.0
var vdecay = 1.0
var hitstun
var connected : bool

func _ready() -> void:
	stickman_2new.get_child(4).add_child(CosmeticManager.p2hat.instantiate())
	punch_collision.disabled = true
	SPEED = NORMAL_SPEED
	animations = stickman_2new.animation_player
	shaders.set_surface_override_material(0, outlineShader)

func _physics_process(delta: float) -> void:
	current_timestamp += delta * 1000

	if is_knockback:
		# Apply gravity manually during knockback b/c otherwise it doesnt apply :(
		if not is_on_floor():
			velocity.y += get_gravity().y * delta

		# prevents bouncing weird after knockback
		#elif velocity.y > 0:
		#	velocity.y = 0

		# Apply knockback decay
		velocity.x = move_toward(velocity.x, 0, hdecay * delta)
		velocity.y = move_toward(velocity.y, 0, vdecay * delta)

		move_and_slide()

		# Knockback duration countdown
		knockback_timer -= delta
		if knockback_timer <= 0:
			is_knockback = false
			velocity = Vector3.ZERO  # cahnge this to be able to have some friction instead of complete stop

		return 

# PLAYER INPUT MOVEMENT (Only runs if not being knockbacked)

	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	else:
		if not is_knockback:
			velocity.y = 0

	# Movement
	var movement_dir = (
		Input.get_action_strength("P2Left") -
		Input.get_action_strength("P2Right")
	)
	if movement_dir != 0:
		velocity.x = -movement_dir * SPEED / 2
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Jumping
	if Input.is_action_just_pressed("P2Jump") and is_on_floor():
		animations.play("Tpose_001|JumpForward")
		current_timestamp = 0
		velocity.y = JUMP_VELOCITY

	# Punching
	if Input.is_action_just_pressed("P2Punch") and punch_timer.timeout:
		animations.play("Tpose_001|Punch")
		current_timestamp = 0
		punch_timer.start()
		punch_collision.disabled = false
		await get_tree().create_timer(0.1).timeout
		punch_collision.disabled = true
		animations.play("Punch2ToIdle")

	# Run animations
	if Input.is_action_pressed("P2Left") or Input.is_action_pressed("P2Right"):
		if Input.is_action_just_pressed("P2Punch"):
			set_process_input(false)
			await get_tree().create_timer(0.4).timeout
			set_process_input(true)
			await animations.animation_finished
		else:
			animations.play("Tpose_001|Run")

	# Double tap detection (left/right)
	handle_double_tap("P2Left", 180, -1)
	handle_double_tap("P2Right", 0, 1)

	move_and_slide()

func handle_double_tap(action: String, face_direction: float, dodge_offset: float):
	if action == "P2Left":
		if going_left and Input.is_action_just_pressed(action) and is_on_floor():
			rotation_degrees.y = face_direction
			going_left = false
			position.x += dodge_offset
			if debug:
				print("P2 Double Left")
		elif Input.is_action_just_pressed(action):
			rotation_degrees.y = face_direction
			current_timestamp = 0
			going_left = true
	elif action == "P2Right":
		if going_right and Input.is_action_just_pressed(action) and is_on_floor():
			rotation_degrees.y = face_direction
			going_right = false
			position.x += dodge_offset
			if debug:
				print("P2 Double Right")
		elif Input.is_action_just_pressed(action):
			rotation_degrees.y = face_direction
			current_timestamp = 0
			going_right = true

	if current_timestamp >= 500:
		going_left = false
		going_right = false

	# Crouching
	if Input.is_action_pressed("P2Crouch"):
		SPEED = CROUCHING_SPEED
		standing_collision.disabled = true
		crouching_collision.disabled = false
		hit_collision.scale.y = crouching_collision.scale.y
		hit_collision.global_position = crouching_collision.global_position
	elif Input.is_action_just_released("P2Crouch"):
		SPEED = NORMAL_SPEED
		standing_collision.disabled = false
		crouching_collision.disabled = true
		hit_collision.scale.y = standing_collision.scale.y
		hit_collision.global_position = standing_collision.global_position

	# Move the player
	move_and_slide()

	# Idle animation when nothing else happening
	if not animations.is_playing() or not Input.is_anything_pressed():
		animations.play("Tpose_001|Idle")

	# Death check
	#if health <= 0:

	if animations.is_playing() == false or Input.is_anything_pressed() == false:
		animations.play("Tpose_001|Idle")

func _on_hit_box_area_entered(area: Area3D) -> void:
	print("player2 Health = " + str(health))
	if area == low_death:
		death()
		#IF YOU CHANGE ANY NODES OR ADD ANY NODES IN THE PLAYER TREE THEN CHECK TO MAKE SURE THIS STILL WORKS
	elif area == player1.get_child(2):
		sounds.play()
		weight = self.weight
		self.percentage += damage
		health -= player1.damage
		self.kb = knockbackVal
		if player1.global_position.x < global_position.x:
			angle = 135
		elif player1.global_position.x >= global_position.x:
			angle = 45
		apply_knockback(knockbackVal, angle)
		animations.play("Tpose_001|TakeHit")
		shaders.set_surface_override_material(0, wireShader)
		#FRAME PAUSE CODE!
		hitStopShort()
		#IN OTHER INSTANCES CHANGE HITSTOPLONG() TO HITSTOPSHORT OR MEDIUM
		while await hitStopShort():
			return
		shaders.set_surface_override_material(0, outlineShader)
	if health <= 0:
		print("player1 Died")
		hitStopLong()
		death()

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

@export var percentage = 0
@export var weight = 100
@export var base_knockback = 40
@export var ratio = 1
@export var kb_scaling = 1
@export var kb = 1

func knockback(p, d, w, ks, bk, r):
	percentage = p
	damage = d
	weight = w
	kb_scaling = ks
	base_knockback = bk
	ratio = r
	return((((((((percentage / 10) + (percentage * damage / 20)) * (200 / (weight + 100)) *1.4) + 18) * (kb_scaling)) + base_knockback) + 1)) * .004

const angleConversion = PI / 180

func getHorizontalDecay(angle): #Rate of slowing that the enemy will slow after kb horiz
	var decay = 0.051 * cos(angle * angleConversion) #To get horizontal rate mulitply horizontal(cos) angle with 0.051
	decay = round(decay * 100000) / 100000 # Rounds to whole number
	decay = decay * 1000
	return decay
func getVerticalDecay(angle): #Rate of slowing that the enemy will slow after kb vert
	var decay = 0.051 * sin(angle * angleConversion) #To get horizontal rate mulitply horizontal(cos) angle with 0.051
	decay = round(decay * 100000) / 100000 # Rounds to whole number
	decay = decay * 1000
	return abs(decay)

const DEG2RAD = PI / 180

func get_horizontal_velocity(kb: float, angle_deg: float) -> float:
	var angle_rad = angle_deg * DEG2RAD
	#If you put tan in here instead of cos its funny
	print("horizontal vel is: " + str(round(kb * 30 * cos(angle_rad) * 100000) / 100000))
	return -round(kb * 30 * cos(angle_rad) * 100000) / 100000
func get_vertical_velocity(kb: float, angle_deg: float) -> float:
	var angle_rad = angle_deg * DEG2RAD

	return round(kb * 30 * sin(angle_rad) * 100000) / 100000


#func angle_flipper(body):
	#is_knockback = true
	#knockback_timer = knockback_duration
#
	#knockbackVal *= 100000000
	#print("Inside angle_flipper()")
	#print("knockbackVal = ", knockbackVal)
	#var xangle
	#if self.rotation.y == -180:
		#xangle = (-(((body.global_position.angle_to(global_position))*180)/PI))
	#else:
		#xangle = ((((body.global_position.angle_to(global_position))*180)/PI))
	#match angle_flipper:
		#0:
			#body.velocity.x = (getHorizontalVelocity(knockbackVal, -angle))
			#body.velocity.y = (getVerticalVelocity(knockbackVal, angle))
			#body.hdecay = (getHorizontalDecay(-angle))
			#body.vdecay = (getVerticalDecay(angle))
		#1:
			#if self.rotation.y == -180:
				#xangle = -(((self.global_position.angle_to(body.global_position))*180)/PI)
			#else:
				#xangle = (((self.global_position.angle_to(body.global_position))*180)/PI)
			#body.velocity.x = (getHorizontalVelocity(knockbackVal, xangle + 180))
			#body.velocity.y = (getVerticalVelocity(knockbackVal, -xangle))
			#body.hdecay = (getHorizontalDecay(xangle + 180))
			#body.vdecay = (getVerticalDecay(xangle))
#
		#2:
			#if self.rotation.y == -180:
				#xangle = -(((body.global_position.angle_to(self.global_position))*180)/PI)
			#else:
				#xangle = (((body.global_position.angle_to(self.global_position))*180)/PI)
			#body.velocity.x = (getHorizontalVelocity(knockbackVal, -xangle + 180))
			#body.velocity.y = (getVerticalVelocity(knockbackVal, -xangle))
			#body.hdecay = (getHorizontalDecay(xangle + 180))
			#body.vdecay = (getVerticalDecay(xangle))
#
		#3:
			#if self.rotation.y == -180:
				#xangle = (-(((body.global_position.angle_to(self.global_position))*180)/PI)) + 180
			#else:
				#xangle = (((body.global_position.angle_to(self.global_position))*180)/PI)
			#body.velocity.x = (getHorizontalVelocity(knockbackVal, xangle))
			#body.velocity.y = (getVerticalVelocity(knockbackVal, -angle))
			#body.hdecay = (getHorizontalDecay(xangle))
			#body.vdecay = (getVerticalDecay(angle))
#
		#4:
			#if self.rotation.y == -180:
				#xangle = -(((body.global_position.angle_to(self.global_position))*180)/PI) + 180
			#else:
				#xangle = (((body.global_position.angle_to(self.global_position))*180)/PI)
			#body.velocity.x = (getHorizontalVelocity(knockbackVal, -xangle + 180))
			#body.velocity.y = (getVerticalVelocity(knockbackVal, -angle))
			#body.hdecay = (getHorizontalDecay(angle))
			#body.vdecay = (getVerticalDecay(angle))
#
		#5:
			#body.velocity.x = (getHorizontalVelocity(knockbackVal, angle + 180))
			#body.velocity.y = (getVerticalVelocity(knockbackVal, -angle))
			#body.hdecay = (getHorizontalDecay(angle+180))
			#body.vdecay = (getVerticalDecay(angle))
#
		#6:
			#body.velocity.x = (getHorizontalVelocity((knockbackVal), xangle))
			#body.velocity.y = (getVerticalVelocity(knockbackVal, -angle))
			#body.hdecay = (getHorizontalDecay(xangle))
			#body.vdecay = (getVerticalDecay(angle))
			#print("ligma")
#
		#7:
			#body.velocity.x = (getHorizontalVelocity((knockbackVal), -xangle + 180))
			#body.velocity.y = (getVerticalVelocity(knockbackVal, -angle))
			#body.hdecay = (getHorizontalDecay(angle))
			#body.vdecay = (getVerticalDecay(angle))

func apply_knockback(kb: float, angle_deg: float) -> void:
	is_knockback = true
	knockback_timer = knockback_duration

# Calculate velocities
	var h_vel = get_horizontal_velocity(kb, angle)/2
	var v_vel = get_vertical_velocity(kb, angle)/4

	velocity.x = h_vel
	velocity.y = v_vel

	print("knockback running")
