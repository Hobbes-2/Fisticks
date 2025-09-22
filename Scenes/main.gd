extends Node3D

@onready var pause_menu: Node2D = $PauseMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		pause_menu.show()
	if pause_menu.visible == true:
		Engine.time_scale = 0.0
