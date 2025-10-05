extends Node3D

@onready var anims: AnimationPlayer = $Anims
@export var yeah : bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if yeah:
		anims.play("hit")
func hit():
	anims.play("hit")
