class_name EnemyCharacter extends Character

func play_turn() -> Card:
	return hand.remove_top_card()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = 50
	hand.angle_limit = 5
	hand.hand_radius = 1050
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
