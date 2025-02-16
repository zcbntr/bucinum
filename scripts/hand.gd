@tool
class_name Hand extends Node2D

const ROT_VAR: int = 5
const X_VAR: int = 4
const Y_VAR: int = 4

@onready var playable_card_scene: PackedScene = preload("res://scenes/playable_card.tscn")

signal category_clicked(category: String, card: PlayableCard)

@export var hand_radius: int = 1000
# Cards only spread in 20 degree arc
@export var angle_limit: float = 20
# Max spread between cards - smaller gives more overlap in smaller decks
@export var max_card_spread_angle: float = 2.5

@onready var collision_shape: CollisionShape2D = $DebugCircle

var hovered_category: String
var hovered_category_card: PlayableCard
var cards: Array[PlayableCard] = []
var cards_touched: Array[PlayableCard] = []
var categories_of_cards_touched: Dictionary
var cards_selected: Array[PlayableCard] = []

func is_empty() -> bool:
	return cards.is_empty()

# Removes card at front of queue - right most card in hand
func remove_top_card() -> PlayableCard:
	if (is_empty()):
		return null
	
	var card = cards[0]
	remove_card(0)
	return card

func get_top_card() -> PlayableCard:
	if (is_empty()):
		return null
	
	return cards[0]

# Physically add card to hand, positionally sort cards
func add_card(_card: PlayableCard):
	cards.push_back(_card)
	add_child(_card)
	
	_card.category_hovered.connect(_handle_card_category_hovered)
	_card.category_unhovered.connect(_handle_card_category_unhovered)
	_card.mouse_entered.connect(_handle_card_touched)
	_card.mouse_exited.connect(_handle_card_untouched)
	fan_cards()

# Remove card by index from hand, positionally sort cards
func remove_card(_index: int) -> PlayableCard:
	var removing_card = cards[_index]
	
	var touched_card_index = cards_touched.find(removing_card)
	if (touched_card_index >= 0):
		cards_touched.remove_at(touched_card_index)
	
	var selected_card_index = cards_selected.find(removing_card)
	if (selected_card_index >= 0):
		cards_selected.remove_at(selected_card_index)
	
	categories_of_cards_touched.erase(cards[_index])
	
	cards.remove_at(_index)
	#removing_card.category_hovered.disconnect()
	#removing_card.category_unhovered.disconnect()
	remove_child(removing_card)
	fan_cards()
	
	return removing_card

func remove_selected_cards() -> Array[PlayableCard]:
	var removing_cards: Array[PlayableCard] = []
	
	while !cards_selected.is_empty():
		var card_index = cards.find(cards_selected[0])
		removing_cards.push_back(remove_card(card_index))
	
	return removing_cards

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

func _handle_card_touched(_card: PlayableCard) -> void:
	cards_touched.push_back(_card)

func _handle_card_untouched(_card: PlayableCard) -> void:
	cards_touched.remove_at(cards_touched.find(_card))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event):
	if (self.visible):
		if event.is_action_pressed("mouse_click"):
			if (!cards_touched.is_empty()):
#				Get the rightmost touched card
				var lowest_touched_index: int = cards.size()
				for card in cards_touched:
					lowest_touched_index = min(lowest_touched_index, cards.find(card))
				var card_clicked = cards[lowest_touched_index]
				
	#			Select the card. If its already selected unselect it
				if (cards_selected.find(card_clicked) == -1):
					cards_selected.push_back(cards[lowest_touched_index])
				else:
					cards_selected.remove_at(cards_selected.find(card_clicked))
			elif (hovered_category != ""):
				category_clicked.emit(hovered_category, hovered_category_card)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in range(0, cards.size()):
		cards[i].unhighlight()
		cards[i].set_card_name("Card " + str(i))
	
#	Update visuals to show touched card
	var lowest_touched_index: int = cards.size()
	if (!cards_touched.is_empty()):
		for touched_card in cards_touched:
			lowest_touched_index = min(lowest_touched_index, cards.find(touched_card))
		if lowest_touched_index < cards.size():
			cards[lowest_touched_index].highlight()
	
#	Update visuals to show selected cards
	if (!cards_selected.is_empty()):
		for selected_card in cards_selected:
			if (lowest_touched_index < cards.size() && cards[lowest_touched_index] == selected_card):
				selected_card.highlight_select()
			else:
				selected_card.select()
	
#	Tool logic
	if (collision_shape.shape as CircleShape2D).radius != hand_radius:
		(collision_shape.shape as CircleShape2D).set_radius(hand_radius)

# Update selected_category with the category hovered on the lowest card
func update_selected_category() -> void:
	if categories_of_cards_touched.is_empty():
		hovered_category = ""
		return
		
#	Clear current highlights
	for card in cards:
		card.unhighlight_all_categories()
		
#	Find correct card to highlight
	var lowest_card_category_touched: String
	var lowest_card_category_touched_index: int = cards.size()
	for key in categories_of_cards_touched:
		var current_index = cards.find(key)
		if current_index < lowest_card_category_touched_index:
			lowest_card_category_touched_index = current_index
			lowest_card_category_touched = categories_of_cards_touched.get(key)
	cards[lowest_card_category_touched_index].highlight_category(lowest_card_category_touched)
	hovered_category = lowest_card_category_touched
	hovered_category_card = cards[lowest_card_category_touched_index]


func _handle_card_category_hovered(category: String, card: PlayableCard):
	categories_of_cards_touched.get_or_add(card, category)
	update_selected_category()
	

func _handle_card_category_unhovered(card: PlayableCard):
	categories_of_cards_touched.erase(card)
	update_selected_category()
