extends Node2D

@export var player1 : CharacterBody3D
#SO MANY CARDSSDSDSDSDASS
var card1 = preload("res://Scenes/2D Scenes/Cards/test_card.tscn")
var damage_I = preload("res://Scenes/2D Scenes/Cards/damage_i.tscn")
var damage_II = preload("res://Scenes/2D Scenes/Cards/damage_ii.tscn")
var health_I = preload("res://Scenes/2D Scenes/Cards/health_i.tscn")
var health_II = preload("res://Scenes/2D Scenes/Cards/health_ii.tscn")
var speed_I = preload("res://Scenes/2D Scenes/Cards/speed_i.tscn")
var speed_II = preload("res://Scenes/2D Scenes/Cards/speed_ii.tscn")
@onready var card_1_spawn: Node2D = $Card1Spawn
@onready var card_2_spawn: Node2D = $Card2Spawn
@onready var card_3_spawn: Node2D = $Card3Spawn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var damageI = damage_I.instantiate()
	var healthI = health_I.instantiate()
	var speedI = speed_I.instantiate()
	var damageII = damage_II.instantiate()
	var healthII = health_II.instantiate()
	var speedII = speed_II.instantiate()
	var list_of_cards : Array = [
		damageI,
		damageII,
		healthI,
		healthII,
		speedI,
		speedII
	]
	var current_card = list_of_cards[randi_range(0, 5)]
	card_1_spawn.add_child(current_card)
	current_card.position = card_1_spawn.position
	current_card.player1 = player1
	current_card.visible = true
	current_card = list_of_cards[randi_range(0, 5)]
	card_2_spawn.add_child(current_card)
	current_card.position = card_2_spawn.position
	current_card.player1 = player1
	current_card.visible = true
	current_card = list_of_cards[randi_range(0, 5)]
	card_3_spawn.add_child(current_card)
	current_card.position = card_3_spawn.position
	current_card.player1 = player1
	current_card.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if GlobalCards.card_chosen == true:
		get_tree().change_scene_to_file("res://Scenes/main.tscn")
