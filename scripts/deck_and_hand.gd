extends Node2D

@onready var card_scene: PackedScene = preload("res://scenes/card.tscn")
@onready var spawn_point = $CanvasLayer/Spawn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_create_card_1_button_pressed() -> void:
	var card = card_scene.instantiate()
	spawn_point.add_entity(card)
	card.set_card_name("Card 1")
	card.set_card_cost("1")
	card.set_card_description("Card 1 Description")
	
