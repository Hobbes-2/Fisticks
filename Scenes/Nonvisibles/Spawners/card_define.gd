extends TextureRect

@export_multiline var text : String
@onready var label: Label = $PanelContainer/MarginContainer/Label
@onready var panel_container: PanelContainer = $PanelContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = text


func _on_mouse_entered() -> void:
	panel_container.visible = true


func _on_mouse_exited() -> void:
	panel_container.visible = false
