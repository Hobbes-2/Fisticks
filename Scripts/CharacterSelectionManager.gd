extends Node

var player1
var player1script = preload("res://Scripts/Players/player_1.gd")
var player2
var player2script = preload("res://Scripts/Players/player_2.gd")

var selectableCharacters = {
	"Orange" : preload("res://stickman_1_test.tscn"),
	"Red" : preload("res://stickman_1_test.tscn")
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
