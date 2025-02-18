class_name Shop extends Node2D

signal exit_shop_pressed

@export var cards: Array[CardObject]
@export var upgrades: Array
@export var player_character: PlayerCharacter


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	populate_shop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$MoneyLbl.set_text("$" + str(GameController.money))


func populate_shop() -> void:
	generate_shop_cards()
	lay_out_cards()


func generate_shop_cards() -> void:
	var generated_cards: Array[CardObject]
	for i in range(0, 4):
		var card = CardObject.generate_random_card()
		card.show_cost()
		card.card_selected.connect(_on_card_selected)
		generated_cards.push_back(card)
		$CardsSection.add_child(card)
	cards = generated_cards

func add_card_to_shop(_card: CardObject) -> void:
	cards.push_back(_card)


func lay_out_cards() -> void:
	for i in range(0, cards.size()):
		cards[i].set_position(Vector2(50 + i * 100, 150))


func _on_shop_continue_button_pressed() -> void:
	exit_shop_pressed.emit()


func _on_card_selected(_card: CardObject) -> void:
#	Add card to deck, decrement money
	if GameController.get_money() >= _card.card_cost:
		_card.visible = false
		cards.remove_at(cards.find(_card))
		$CardsSection.remove_child(_card)
		player_character.add_card_to_hand(_card)
		lay_out_cards()
		GameController.remove_money(_card.card_cost)
