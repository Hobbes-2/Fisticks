extends Sprite2D

var maps = []
var currentSelected = 0
var currentColumnSpot = 0
var currentRowSpot = 0

@export var amountOfRows : int = 2
@export var portraitOffset : Vector2

@onready var grid_container: GridContainer = $"../GridContainer"

func _ready() -> void:
	for nameOfMap in get_tree().get_nodes_in_group("Maps"):
		maps.append(nameOfMap)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("P1Right"):
		currentSelected += 1
		currentColumnSpot += 1


		if currentColumnSpot > grid_container.columns - 1 and currentSelected < maps.size() - 1:
			position.x -= (currentColumnSpot - 1) * portraitOffset.x
			position.y += portraitOffset.y
			
			currentColumnSpot = 0
			currentRowSpot += 1
		elif currentColumnSpot > grid_container.columns - 1 and currentSelected > maps.size() - 1:
			position.x -= (currentColumnSpot - 1) * portraitOffset.x
			position.y -= currentRowSpot * portraitOffset.y
			
			currentColumnSpot = 0
			currentRowSpot = 0
			currentSelected = 0
		else:
			position.x += portraitOffset.x

	elif Input.is_action_just_pressed("P1Left"):
		currentSelected -= 1
		currentColumnSpot -= 1

		if currentColumnSpot < 0 and currentSelected > 0:
			position.x += (grid_container.columns - 1) * portraitOffset.x
			position.y -= (amountOfRows - 1) * portraitOffset.y
			
			currentColumnSpot = grid_container.columns - 1
			currentRowSpot -= 1
		elif currentColumnSpot < 0 and currentSelected < 0:
			position.x += (grid_container.columns - 1) * portraitOffset.x
			position.y += (amountOfRows - 1) * portraitOffset.y
			
			currentColumnSpot = grid_container.columns - 1
			currentRowSpot = amountOfRows -1
			currentSelected = maps.size() - 1

		else:
			position.x -= portraitOffset.x

	if Input.is_action_just_pressed("ui_accept"):
		CharacterSelectionManager.current_map = CharacterSelectionManager.selectableMaps[maps[currentSelected].name]
