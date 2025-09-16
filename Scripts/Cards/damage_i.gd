extends Node2D

var damage_buff = 1
var health_buff = 0
var speed_buff = 0

@export var player1 : CharacterBody3D
@export var player2 : CharacterBody3D

@onready var button: Button = $Button

var p1_select : bool = true
var p2_select : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	if p1_select == true:
		player1.health += health_buff
		player1.damage += damage_buff
		player1.SPEED += speed_buff
	if p2_select == true:
		player2.health += health_buff
		player2.damage += damage_buff
		player2.SPEED += speed_buff
	queue_free()
