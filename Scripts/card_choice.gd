extends Node2D

@onready var which_player: Label = $WhichPlayer
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
	var damageI = damage_I
	var healthI = health_I
	var speedI = speed_I
	var damageII = damage_II
	var healthII = health_II
	var speedII = speed_II
	var list_of_cards : Array = [
		damageI,
		damageII,
		healthI,
		healthII,
		speedI,
		speedII
	]
	card_1_spawn.get_children()
	var filler_card = list_of_cards[randi_range(0, 5)]
	var current_card = filler_card.instantiate()
	card_1_spawn.add_child(current_card)
	current_card.position = card_1_spawn.position
	current_card.player1 = player1
	current_card.visible = true
	filler_card = list_of_cards[randi_range(0, 5)]
	current_card = filler_card.instantiate()
	card_2_spawn.add_child(current_card)
	current_card.position = card_2_spawn.position
	current_card.player1 = player1
	current_card.visible = true
	filler_card = list_of_cards[randi_range(0, 5)]
	current_card = filler_card.instantiate()
	card_3_spawn.add_child(current_card)
	current_card.position = card_3_spawn.position
	current_card.player1 = player1
	current_card.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if GlobalCards.card_chosen == true:
		if GlobalCards.player2_choice == true:
			get_tree().change_scene_to_file("res://Scenes/2D Scenes/map_select.tscn")
			GlobalCards.player2_choice = false
		else:
			GlobalCards.card_chosen = false
			GlobalCards.player2_choice = true
			_ready()
	if GlobalCards.player2_choice == true:
		which_player.text = "Player 2s choice"
	else:
		which_player.text = "Player 1s choice"
