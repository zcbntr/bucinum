extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_deck_and_hand_card_played(card: Card) -> void:
	card.play({
		"caster": $GameScreen/PlayerCharacter,
		"targets": [$GameScreen/EnemyCharacter]
	})
