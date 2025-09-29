extends Sprite2D

var characters = []
var currentSelected = 0
var currentColumnSpot = 0
var currentRowSpot = 0
var amount
@export var player1Text : Texture
@export var player2Text : Texture
@export var amountOfRows : int = 2
@export var portraitOffset : Vector2
var current_icon
@onready var grid_container: GridContainer = $"../GridContainer"

func _ready() -> void:
	for nameOfCharacter in get_tree().get_nodes_in_group("Characters"):
		characters.append(nameOfCharacter)
	texture = player1Text
	amount = characters.size()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("P1Left"):
		#currentSelected += 1
		#currentColumnSpot += 1
#
#
		#if currentColumnSpot > grid_container.columns - 1 and currentSelected < characters.size() - 1:
			#position.x -= (currentColumnSpot - 1) * portraitOffset.x
			#position.y += portraitOffset.y
			#
			#currentColumnSpot = 0
			#currentRowSpot += 1
		#elif currentColumnSpot > grid_container.columns - 1 and currentSelected > characters.size() - 1:
			#position.x -= (currentColumnSpot - 1) * portraitOffset.x
			#position.y -= currentRowSpot * portraitOffset.y
			#
			#currentColumnSpot = 0
			#currentRowSpot = 0
			#currentSelected = 0
		#else:
			#position.x += portraitOffset.x
		currentSelected += 1
		currentColumnSpot += 1


		if currentColumnSpot > grid_container.columns - 1 and currentSelected < characters.size() - 1:
			grid_container.position.x -= (currentColumnSpot - 1) * portraitOffset.x
			grid_container.position.y += portraitOffset.y
			
			currentColumnSpot = 0
			currentRowSpot += 1
		elif currentColumnSpot > grid_container.columns - 1 and currentSelected > characters.size() - 1:
			grid_container.position.x -= (currentColumnSpot - 1) * portraitOffset.x
			grid_container.position.y -= currentRowSpot * portraitOffset.y
			
			currentColumnSpot = 0
			currentRowSpot = 0
			currentSelected = 0
		else:
			grid_container.position.x += portraitOffset.x

	elif Input.is_action_just_pressed("P1Right"):
		current_icon = grid_container.get_child(abs(currentSelected))
		currentSelected -= 1
		currentColumnSpot -= 1

		if currentColumnSpot < 0 and currentSelected > 0:
			for number in amount:
				grid_container.get_child(number).position.x += (grid_container.columns - 1) * portraitOffset.x
				grid_container.get_child(number).position.y -= (amountOfRows - 1) * portraitOffset.y
				print(grid_container.position)
			currentColumnSpot = grid_container.columns - 1
			currentRowSpot -= 1
			
		elif currentColumnSpot < 0 and currentSelected < 0:
			current_icon.position.x += (grid_container.columns - 1) * portraitOffset.x
			#grid_container.position.y += (amountOfRows - 1) * portraitOffset.y
			
			currentColumnSpot = grid_container.columns - 1
			currentRowSpot = amountOfRows - 1
			currentSelected -= characters.size() - 1
			print(currentSelected)
		else:
			for number in amount:
				current_icon.position.x -= portraitOffset.x

	if Input.is_action_just_pressed("ui_accept"):
		if CharacterSelectionManager.player1 == null:
			CharacterSelectionManager.player1 = CharacterSelectionManager.selectableCharacters[characters[currentSelected].name]
			texture = player2Text
		else:
			CharacterSelectionManager.player2 = CharacterSelectionManager.selectableCharacters[characters[currentSelected].name]
			get_tree().change_scene_to_file("res://Scenes/main.tscn")
