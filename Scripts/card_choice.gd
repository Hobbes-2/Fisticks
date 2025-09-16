extends Node2D

@export var player1 : CharacterBody3D
var card1 = preload("res://Scenes/2D Scenes/Cards/test_card.tscn")
var damage_I = preload("res://Scenes/2D Scenes/Cards/damage_i.tscn")

@onready var card_1_spawn: Node3D = $Card1Spawn
@onready var card_2_spawn: Node3D = $Card2Spawn
@onready var card_3_spawn: Node3D = $Card3Spawn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var damageI = damage_I.instantiate()
	var health_card = card1.instantiate()
	var speed_card = card1.instantiate()
	var list_of_cards : Array = [
		damageI,
		speed_card,
		health_card
	]
	var current_card = list_of_cards[randi_range(0, 2)]
	card_1_spawn.add_child(current_card)
	current_card.player1 = player1
	current_card.visible = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
