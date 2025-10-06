extends Node2D

var current_card

@export var card_images_1: Node2D
@export var card_images_2: Node2D
@export var card_images_3: Node2D

@onready var card_1_spawn: Node2D = $"../Card1Spawn"
@onready var card_2_spawn: Node2D = $"../Card2Spawn"
@onready var card_3_spawn: Node2D = $"../Card3Spawn"

var roll_duration = 5.0
var TWN

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#for i in get_child_count():
		#print(get_child(i))
		#var new_one = get_child(i)
		#add_child(new_one)
		#new_one.position.y -= 1150
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#current_card = get_child(randi_range(0, get_child_count() - 1))
	#print(current_card)
	#for i in get_child_count():
		#print(get_child(i))
		#if get_child(i) != current_card:
			#get_child(i).visible = false
		#else:
			#get_child(i).visible = true
	#await get_tree().create_timer(0.5).timeout

#-1854
	roll_duration -= delta

	if roll_duration <= 0:
		_stop_roll()
	else:
		_roll(self, 100)



func _roll(slot: Node2D, Speed):
	var newPOS = slot.position.y + Speed
	if newPOS >= 465:
		newPOS = -3225
	slot.position.y = newPOS

func _stop_roll():
	TWN = create_tween().set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT).set_parallel()
	var rng = randi_range(0, 9)
	var dur = 0.1 * rng
	dur += 1
	var finalPos = 192 * rng
	var finalSlot = self
	var anotherSlot = self
#stuff here
	TWN.tween_property(finalSlot, "position:y", finalPos, dur)
	TWN.tween_property(anotherSlot, "position:y", finalPos + 160, dur)
	await TWN.finished

	card_1_spawn.show()
	card_2_spawn.show()
	card_3_spawn.show()
