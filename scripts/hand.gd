@tool
class_name Hand extends Node2D

const ROT_VAR: int = 5
const X_VAR: int = 4
const Y_VAR: int = 4

signal category_clicked(category: String, card: CardObject)

@export var hand_radius: int = 1000
# Cards only spread in 20 degree arc
@export var angle_limit: float = 20
# Max spread between cards - smaller gives more overlap in smaller decks
@export var max_card_spread_angle: float = 2.5

@onready var collision_shape: CollisionShape2D = $DebugCircle

var cards: Array[CardObject] = []
var cards_selected: Array[CardObject] = []

func is_empty() -> bool:
	return cards.is_empty()

# Removes card at front of queue - right most card in hand
func pop_top_card() -> CardObject:
	if (is_empty()):
		return null
	
	return remove_card(0)

func get_top_card() -> CardObject:
	if (is_empty()):
		return null
	
	return cards[0]

# Physically add card to hand, positionally sort cards
func add_card(_card: CardObject):
	_card.category_clicked.connect(_on_card_category_clicked)
	_card.card_selected.connect(_on_card_selected)
	_card.card_unselected.connect(_on_card_unselected)
	_card.make_playable()
	_card.visible = true
	cards.push_back(_card)
	add_child(_card)
	
	fan_cards()

# Remove card by index from hand, positionally sort cards
func remove_card(_index: int) -> CardObject:
	var removing_card = cards[_index]
	
	var selected_card_index = cards_selected.find(removing_card)
	if (selected_card_index >= 0):
		cards_selected.remove_at(selected_card_index)
	
	cards.remove_at(_index)
	removing_card.category_clicked.disconnect(_on_card_category_clicked)
	removing_card.card_selected.disconnect(_on_card_selected)
	removing_card.card_unselected.disconnect(_on_card_unselected)
	remove_child(removing_card)
	fan_cards()
	
	return removing_card

func remove_selected_cards() -> Array[CardObject]:
	var removing_cards: Array[CardObject] = []
	
	while !cards_selected.is_empty():
		var card_index = cards.find(cards_selected[0])
		removing_cards.push_back(remove_card(card_index))
	
	return removing_cards

func clear() -> void:
	while cards.size() != 0:
		remove_card(0)

# Fan cards
func fan_cards():
	var card_spread = min(angle_limit / cards.size(), max_card_spread_angle)
	var current_angle = -(card_spread * cards.size() - 1) / 2 - 90
	
#	Render in reverse to do proper card overlap
	for i in range(cards.size() - 1, -1, -1):
		_update_card_transform(cards[i], current_angle)
		current_angle += card_spread
		cards[i].z_index = cards.size() -1 - i

# Get the position of a card for a given angle
func get_card_position(_angle_in_deg: float) -> Vector2:
	var x: float = hand_radius * cos(deg_to_rad(_angle_in_deg))
	var y: float = (hand_radius * sin(deg_to_rad(_angle_in_deg))) + hand_radius
	
	return Vector2(int(x), int(y))

func _update_card_transform(card: CardObject, _angle_in_deg: float) -> void:
#	Random variation
	var rng = RandomNumberGenerator.new()
	var x_offset = rng.randf_range(-0.5 * X_VAR, 0.5 * X_VAR)
	var y_offset = rng.randf_range(-0.5 * Y_VAR, 0.5 * Y_VAR)
	var rot_offset = rng.randf_range(-0.5 * ROT_VAR, 0.5 * ROT_VAR)
	
	card.set_position(get_card_position(_angle_in_deg) + Vector2(int(x_offset), int(y_offset)))
	card.set_rotation(deg_to_rad(_angle_in_deg + 90 + rot_offset))

func _on_card_category_clicked(_category: String, _card: CardObject) -> void:
	category_clicked.emit(_category, _card)

func _on_card_selected(_card: CardObject) -> void:
	cards_selected.push_back(_card)

func _on_card_unselected(_card: CardObject) -> void:
	cards_selected.remove_at(cards_selected.find(_card))


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
#	Tool logic
	if collision_shape.visible && (collision_shape.shape as CircleShape2D).radius != hand_radius:
		(collision_shape.shape as CircleShape2D).set_radius(hand_radius)
