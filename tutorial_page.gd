extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var info: Label = $Info
var option : int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.play("walking")
	info.text = str("Player 1, use WASD to move - Player 2, use IJKL or arrow keys")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_next_pressed() -> void:
	if option == 0:
		animated_sprite_2d.play("punching")
		info.text = str("Player 1, use E to punch - Player 2, use U")
		option = 1
	elif option == 1:
		animated_sprite_2d.play("default")
		get_tree().change_scene_to_file("res://Scenes/2D Scenes/title_screen.tscn")
