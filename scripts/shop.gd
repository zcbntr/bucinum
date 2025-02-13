class_name Shop extends Node2D

signal exit_shop_pressed

var player_money: int = 0

@export var cards: Array[Card]
@export var upgrades: Array

@onready var card_scene: PackedScene = preload("res://scenes/card.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	populate_shop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$MoneyLbl.set_text("$" + str(player_money))

func set_money(_amount: int) -> void:
	player_money = _amount


func populate_shop() -> void:
	generate_shop_cards()
	lay_out_cards()


func generate_random_card() -> Card:
	var card = card_scene.instantiate()
	var rng = RandomNumberGenerator.new()
	var cardName = rng.randi_range(1, 100)
	var cost = rng.randi_range(1, 10)
	var damage = rng.randi_range(1, 10)
	var stats: Dictionary = {
		"Cuteness": rng.randi_range(1, 100),
		"Fluffyness": rng.randi_range(1, 100),
		"Mischief": rng.randi_range(1, 10),
		"Manners": rng.randi_range(1, 20),
		"Age": rng.randi_range(1, 22)
	}
	card.set_values("Card " + str(cardName), "Card Description", cost, damage, stats)
	return card


func generate_shop_cards() -> void:
	var generated_cards: Array[Card]
	for i in range(0, 3):
		var card = generate_random_card()
		card.show_cost()
		generated_cards.push_back(card)
		$CardsSection.add_child(card)
	cards = generated_cards

func add_card_to_shop(_card: Card) -> void:
	cards.push_back(_card)
	

func lay_out_cards() -> void:
	for i in range(0, cards.size()):
		cards[i].set_position(Vector2(50 + i * 100, 150))


func _on_shop_continue_button_pressed() -> void:
	exit_shop_pressed.emit()
