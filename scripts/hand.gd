@tool
class_name Hand extends Node2D

@export var hand_radius: int = 1000
# Cards only spread in 20 degree arc
@export var angle_limit: float = 20
# Max spread between cards - smaller gives more overlap in smaller decks
@export var max_card_spread_angle: float = 2.5

@onready var collision_shape: CollisionShape2D = $DebugCircle

var hand: Array = []

# Physically add card to hand, positionally sort cards
func add_card(_card: Card):
	hand.push_back(_card)
	add_child(_card)
	reposition_cards()

# Remove card by index from hand, positionally sort cards
func remove_card(_index: int) -> Card:
	var removing_card = hand[_index]
	hand.remove_at(_index)
	remove_child(removing_card)
	reposition_cards()
	return removing_card

# Positionally sort cards
func reposition_cards():
	var card_spread = min(angle_limit / hand.size(), max_card_spread_angle)
	var current_angle = -(card_spread * hand.size() - 1) / 2 - 90
	for card in hand:
		_update_card_transform(card, current_angle)
		current_angle += card_spread

# Get the position of a card for a given angle
func get_card_position(_angle_in_deg: float) -> Vector2:
	var x: float = hand_radius * cos(deg_to_rad(_angle_in_deg))
	var y: float = hand_radius * sin(deg_to_rad(_angle_in_deg))
	
	return Vector2(int(x), int(y))

func _update_card_transform(card: Card, _angle_in_deg: float):
	card.set_position(get_card_position(_angle_in_deg))
	card.set_rotation(deg_to_rad(_angle_in_deg + 90))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (collision_shape.shape as CircleShape2D).radius != hand_radius:
		(collision_shape.shape as CircleShape2D).set_radius(hand_radius)
	
