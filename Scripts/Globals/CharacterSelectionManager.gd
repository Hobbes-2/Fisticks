extends Node

var player1
var player1script = preload("res://Scripts/Players/player_1.gd")
var player2
var player2script = preload("res://Scripts/Players/player_2.gd")

var selectableCharacters = {
	"Orange" : preload("res://Scenes/stickman_1_test.tscn"),
	"Red" : preload("res://Scenes/stickman_1_test.tscn"),
}

var selectableMaps = {
	"Spikes" : "res://Scenes/main.tscn",
	"Forest" : "res://Scenes/Maps/map_1.tscn"
}

var current_map

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
