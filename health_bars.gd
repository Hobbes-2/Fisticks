extends Node2D

@onready var p_1_health: ProgressBar = $P1Health
@onready var p_2_health: ProgressBar = $P2Health

@export var player1 : CharacterBody3D
@export var player2 : CharacterBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	p_1_health.max_value = GlobalCards.player1Health 
	p_2_health.max_value = GlobalCards.player2Health 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	p_1_health.value = player1.health 
	p_2_health.value = player2.health 
