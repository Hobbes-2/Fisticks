extends Control
class_name CarouselContainer

@export var spacing : float = 20.0

@export var wraparound_enabled : bool = true
@export var wraparound_radius : float = 300.0
@export var wraparound_height : float = 50.0

@export_range(0.0, 1.0) var opacity_strength : float = 0.35
@export_range(0.0, 1.0) var scale_strength : float = 0.25
@export_range(0.1, 0.99, 0.01) var scale_min : float = 0.1

@export var smoothing_speed : float = 6.5
@export var selected_index : int = 0
@export var follow_button_focus : bool = false

@export var position_offset_node : Control 

@export var Player1 : bool = true
@export var Cosmetics : bool = false
@export var Maps : bool = false

var current_selected
var current_hatp1
var current_hatp2
var objects = []

@onready var p_1_model: Node3D = $"../P1Model"
@onready var p_2_model: Node3D = $"../P2Model"

var hat_list = [
	"Conehat",
	"Tophat",
	"Conehat3",
	"Conehat4",
]

var map_list = [
	"Spikes",
	"Forest"
]

func _ready() -> void:
	if Cosmetics:
		for i in CosmeticManager.selectableHats:
			objects.append(i)
	elif Maps:
		for m in CharacterSelectionManager.selectableMaps:
			objects.append(m)
func _process(delta: float) -> void:
	if !position_offset_node or position_offset_node.get_child_count() == 0:
		#print("failed")
		return

	selected_index = clamp(selected_index, 0, position_offset_node.get_child_count()-1)

	for i in position_offset_node.get_children():

		if wraparound_enabled:
			var max_index_range = max(1, (position_offset_node.get_child_count() - 1) / 2.0)
			var angle = clamp((i.get_index() - selected_index) / max_index_range, -1.0, 1.0) * PI
			var x = sin(angle) * wraparound_radius
			var y = cos(angle) * wraparound_height
			var target_pos = Vector2(x, y - wraparound_height) - i.size / 2.0
			i.position = lerp(i.position, target_pos, smoothing_speed * delta)
		else:
			var pos_x = 0
			if i.get_index() > 0:
				pos_x = get_child(i.get_index()-1).position.x + position_offset_node.get_child(i.get_index() - 1).size.x + spacing
			i.position = Vector2(pos_x, -i.size.y / 2.0)
	
		i.pivot_offset = i.size / 2.0
		var target_scale = 1.0 - (scale_strength * abs(i.get_index()-selected_index))
		target_scale = clamp(target_scale, scale_min, 1.0)
		i.scale = lerp(i.scale, Vector2.ONE * target_scale, smoothing_speed * delta)

		var target_opacity = 1.0 - (opacity_strength * abs(i.get_index()-selected_index))
		target_opacity = clamp(target_opacity, scale_min, 1.0)
		i.modulate.a = lerp(i.modulate.a, target_opacity, smoothing_speed * delta)

		if i.get_index() == selected_index:
			i.z_index = 1
			i.mouse_filter = MOUSE_FILTER_STOP
			i.focus_mode = FOCUS_ALL
		else:
			i.z_index = -abs(i.get_index() - selected_index)
			i.mouse_filter = MOUSE_FILTER_IGNORE
			i.focus_mode = FOCUS_NONE

		if follow_button_focus and i.has_focus():
			selected_index = i.get_index()

	if wraparound_enabled:
		position_offset_node.position.x = 540

	else:
		#THIS BREAKS IT AHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHh
		position_offset_node.position.x = lerp(position_offset_node.position.x, -(position_offset_node.get_child(selected_index).position.x + position_offset_node.get_child(selected_index).size.x / 2.0), smoothing_speed)
		print(lerp(position_offset_node.position.x, -(position_offset_node.get_child(selected_index).position.x + position_offset_node.get_child(selected_index).size.x / 2.0), smoothing_speed))

func _left():
	if Cosmetics:
		if Player1 and Cosmetics:
			for n in p_1_model.hatadd.get_children():
				p_1_model.hatadd.remove_child(n)
				n.queue_free()
		elif Cosmetics:
			for n in p_2_model.hatadd.get_children():
				p_2_model.hatadd.remove_child(n)
				n.queue_free()
		current_hatp1.queue_free()
		current_hatp2.queue_free()
	selected_index -= 1
	if selected_index < 0:
		selected_index += 1

func _right():
	if Cosmetics:
		if Player1 and Cosmetics:
			for n in p_1_model.hatadd.get_children():
				p_1_model.hatadd.remove_child(n)
				n.queue_free() 
		elif Cosmetics:
			for n in p_2_model.hatadd.get_children():
				p_2_model.hatadd.remove_child(n)
				n.queue_free()
		current_hatp1.queue_free()
		current_hatp2.queue_free()
	selected_index += 1
	if selected_index > position_offset_node.get_child_count() - 1:
		selected_index -= 1

func _physics_process(delta: float) -> void:
	if Player1 == true:
		if Input.is_action_just_pressed("P1Left"):
			_left()
		if Input.is_action_just_pressed("P1Right"):
			_right()
			
	else:
		if Input.is_action_just_pressed("P2Left"):
			_left()
		if Input.is_action_just_pressed("P2Right"):
			_right()

	if Cosmetics:

		CosmeticManager.p1hat = CosmeticManager.selectableHats[hat_list[selected_index - 1]]
		#print("p1 hat: " + str(CosmeticManager.p1hat))
		current_hatp1 = CosmeticManager.p1hat.instantiate()
		p_1_model.hatadd.add_child(current_hatp1)

		CosmeticManager.p2hat = CosmeticManager.selectableHats[hat_list[selected_index - 1]]
		#print("p2 hat: " + str(CosmeticManager.p2hat))
		current_hatp2 = CosmeticManager.p2hat.instantiate()
		p_2_model.hatadd.add_child(current_hatp2)

	elif Maps:
		if Input.is_action_just_pressed("ui_accept"):
			CharacterSelectionManager.current_map = CharacterSelectionManager.selectableMaps[map_list[selected_index]]
			get_tree().change_scene_to_file(CharacterSelectionManager.current_map)
