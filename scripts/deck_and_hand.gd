extends Node2D

@onready var card_scene: PackedScene = preload("res://scenes/card.tscn")
@onready var spawn_point = $CanvasLayer/Spawn
@onready var hand: Hand = $CanvasLayer/Hand

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_create_card_1_button_pressed() -> void:
	var card = card_scene.instantiate()
	hand.add_card(card)
	


func _on_create_card_2_button_pressed() -> void:
	var card = card_scene.instantiate()
	spawn_point.add_child(card)
	card.set_card_name("Card 2")
	card.set_card_cost(2)
	card.set_card_damage(2)
	card.set_card_description("Card 2 Description")
	card.visible = true
