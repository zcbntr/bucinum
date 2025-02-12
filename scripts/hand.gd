@tool
class_name Hand extends Node2D

const ROT_VAR: int = 5
const X_VAR: int = 4
const Y_VAR: int = 4

@export var hand_radius: int = 1000
# Cards only spread in 20 degree arc
@export var angle_limit: float = 20
# Max spread between cards - smaller gives more overlap in smaller decks
@export var max_card_spread_angle: float = 2.5
@export var selected_category: String

@onready var collision_shape: CollisionShape2D = $DebugCircle

var hand: Array = []
var cards_touched: Array = []
var cards_selected: Array = []

func is_empty() -> bool:
	return hand.is_empty()

func remove_top_card() -> Card:
	if (is_empty()):
		return null
	
	var card = hand[hand.size() - 1]
	remove_card(hand.size() - 1)
	return card

# Physically add card to hand, positionally sort cards
func add_card(_card: Card):
	hand.push_back(_card)
	_card.category_hovered.connect(_handle_card_category_hovered)
	_card.category_unhovered.connect(_handle_card_category_unhovered)
	add_child(_card)
	_card.mouse_entered.connect(_handle_card_touched)
	_card.mouse_exited.connect(_handle_card_untouched)
	fan_cards()

# Remove card by index from hand, positionally sort cards
func remove_card(_index: int) -> Card:
	var removing_card = hand[_index]
	
	var touched_card_index = cards_touched.find(removing_card)
	if (touched_card_index >= 0):
		cards_touched.remove_at(touched_card_index)
	
	var selected_card_index = cards_selected.find(removing_card)
	if (selected_card_index >= 0):
		cards_selected.remove_at(selected_card_index)
	
	hand.remove_at(_index)
	#removing_card.category_hovered.disconnect()
	#removing_card.category_unhovered.disconnect()
	remove_child(removing_card)
	fan_cards()
	
	return removing_card

func remove_selected_cards() -> Array[Card]:
	var removing_cards: Array[Card] = []
	
	while !cards_selected.is_empty():
		var card_index = hand.find(cards_selected[0])
		removing_cards.push_back(remove_card(card_index))
	
	return removing_cards

# Fan cards
func fan_cards():
	var card_spread = min(angle_limit / hand.size(), max_card_spread_angle)
	var current_angle = -(card_spread * hand.size() - 1) / 2 - 90
	
	for card in hand:
		_update_card_transform(card, current_angle )
		current_angle += card_spread

# Get the position of a card for a given angle
func get_card_position(_angle_in_deg: float) -> Vector2:
	var x: float = hand_radius * cos(deg_to_rad(_angle_in_deg))
	var y: float = hand_radius * sin(deg_to_rad(_angle_in_deg))
	
	return Vector2(int(x), int(y))

func _update_card_transform(card: Card, _angle_in_deg: float):
#	Random variation
	var rng = RandomNumberGenerator.new()
	var x_offset = rng.randf_range(-0.5 * X_VAR, 0.5 * X_VAR)
	var y_offset = rng.randf_range(-0.5 * Y_VAR, 0.5 * Y_VAR)
	var rot_offset = rng.randf_range(-0.5 * ROT_VAR, 0.5 * ROT_VAR)
	
	card.set_position(get_card_position(_angle_in_deg) + Vector2(int(x_offset), int(y_offset)))
	card.set_rotation(deg_to_rad(_angle_in_deg + 90 + rot_offset))

func _handle_card_touched(_card: Card) -> void:
	cards_touched.push_back(_card)

func _handle_card_untouched(_card: Card) -> void:
	cards_touched.remove_at(cards_touched.find(_card))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("mouse_click"):
		if (!cards_touched.is_empty()):
#			Get the rightmost touched card
			var highest_touched_index: int = -1
			for card in cards_touched:
				highest_touched_index = max(highest_touched_index, hand.find(card))
			var card_clicked = hand[highest_touched_index]
			
#			Select the card. If its already selected unselect it
			if (cards_selected.find(card_clicked) == -1):
				cards_selected.push_back(hand[highest_touched_index])
			else:
				cards_selected.remove_at(cards_selected.find(card_clicked))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for card in hand:
		card.unhighlight()
	
#	Update visuals to show touched card
	var highest_touched_index: int = -1
	if (!cards_touched.is_empty()):
		for touched_card in cards_touched:
			highest_touched_index = max(highest_touched_index, hand.find(touched_card))
		if highest_touched_index >= 0 &&	 highest_touched_index < hand.size():
			hand[highest_touched_index].highlight()
	
#	Update visuals to show selected cards
	if (!cards_selected.is_empty()):
		for selected_card in cards_selected:
			if (highest_touched_index >= 0 && hand[highest_touched_index] == selected_card):
				selected_card.highlight_select()
			else:
				selected_card.select()
	
#	Tool logic
	if (collision_shape.shape as CircleShape2D).radius != hand_radius:
		(collision_shape.shape as CircleShape2D).set_radius(hand_radius)

func _handle_card_category_hovered(category: String):
	selected_category = category

func _handle_card_category_unhovered():
	selected_category = ""
