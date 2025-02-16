class_name PlayableCard extends Card

const playable_card_scene: PackedScene = preload("res://scenes/playable_card.tscn")

static func new_card(_name: String, _description: String, _cost: int, _damage: int, _stats: Dictionary) -> PlayableCard:
	var new_card: Card = playable_card_scene.instantiate()
	
	new_card.set_values(_name, _description, _cost, _damage, _stats)
	
	return new_card


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_clickable_area_size(Vector2(78, 50))
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func activate(game_state: Dictionary):
	action.activate(game_state)
