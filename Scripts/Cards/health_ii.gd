extends Node2D

var damage_buff = 0
var health_buff = 2
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
		GlobalCards.player1Health += health_buff
		GlobalCards.player1Damage += damage_buff
		GlobalCards.player1Speed += speed_buff
	if p2_select == true:
		GlobalCards.player2Health += health_buff
		GlobalCards.player2Damage += damage_buff
		GlobalCards.player2Speed += speed_buff
	GlobalCards.card_chosen = true
	queue_free()
