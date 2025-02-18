class_name Character extends Node2D

@export var max_health: int = 100
@export var health: int = max_health
@export var max_armour: int = 100
@export var armour: int = 0
@export var max_cards_per_round: int = 20
@export var cards_left_to_play_in_round: int = max_cards_per_round

@onready var hand: Hand = $Hand

func get_hand() -> Hand:
	return hand

func remove_selected_cards() -> Array[CardObject]:
	return hand.remove_selected_cards()

func hand_is_empty() -> bool:
	return hand.is_empty()

func get_top_card() -> CardObject:
	return hand.get_top_card()

func pop_top_card() -> CardObject:
	return hand.pop_top_card()

func add_card_to_hand(_card: CardObject) -> void:
	hand.add_card(_card)

func clear_hand() -> void:
	hand.clear()

func set_health_values(_max_health: int, _health: int) -> void:
	max_health = _max_health
	health = _health
	update_healthbar()

func update_healthbar():
	if (($HealthBar as ProgressBar).max_value != max_health):
		($HealthBar as ProgressBar).max_value = max_health
	if (($HealthBar as ProgressBar).value != health):
		($HealthBar as ProgressBar).value = health

func add_armour(_amount: int) -> void:
	armour += _amount
	if (armour > max_armour):
		armour = max_armour

func spend_cards(_amount: int) -> void:
	cards_left_to_play_in_round -= _amount

func take_damage(_amount: int) -> void:
	health -= _amount
	
	if (health <= 0):
		health = 0
	
	update_healthbar()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hand = $Hand
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
