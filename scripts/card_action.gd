extends Node2D

@onready var card: Card = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func activate(game_state: Dictionary) -> void:
	game_state.get("caster").spend_cards(1)
	game_state.get("targets")[0].take_damage(card.card_damage)
