extends Node2D

signal card_played(card: Card)
@onready var card_scene: PackedScene = preload("res://scenes/card.tscn")
@onready var hand: Hand = $Hand

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_create_card_button_pressed() -> void:
	var card = card_scene.instantiate()
	var rng = RandomNumberGenerator.new()
	var cost = rng.randi_range(0, 10)
	var damage = rng.randi_range(0, 10)
	card.set_values("Card Name", "Card Description", cost, damage)
	hand.add_card(card)

func _on_play_button_pressed() -> void:
	if (!hand.is_empty()):
		card_played.emit(hand.get_top_card())

func _on_delete_card_button_pressed() -> void:
	hand.remove_selected_cards()
