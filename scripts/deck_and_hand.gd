extends Node2D

signal card_played(card: Card)
@onready var card_scene: PackedScene = preload("res://scenes/card.tscn")
@onready var hand: Hand = $CanvasLayer/Hand

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_create_card_1_button_pressed() -> void:
	var card = card_scene.instantiate()
	card.set_values("Card 1", "Card 1 Description", 1, 2)
	hand.add_card(card)
	

func _on_create_card_2_button_pressed() -> void:
	var card = card_scene.instantiate()
	card.set_values("Card 2", "Card 2 Description", 2, 3)
	hand.add_card(card)

func _on_delete_card_button_pressed() -> void:
	hand.remove_selected_cards()
