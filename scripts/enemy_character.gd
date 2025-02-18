class_name EnemyCharacter extends Character

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = 50
	hand.angle_limit = 5
	hand.hand_radius = 1050
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func get_random_category_to_play() -> String:
	if hand.is_empty():
		return ""
	
	var top_card = hand.get_top_card()
	var rng = RandomNumberGenerator.new()
	var keys = top_card.card_stats.keys()
	var category = keys[rng.randi_range(0, keys.size() - 1)]
	return category
