@tool
class_name Character extends Node2D

@export var max_health: int = 10
@export var health: int = max_health
@export var max_cards_per_round: int = 20
@export var cards_left_to_play_in_round: int = max_cards_per_round

func set_health_values(_health: int, _max_health: int) -> void:
	max_health = _max_health
	health = _health
	update_healthbar()

func update_healthbar():
	if (($HealthBar as ProgressBar).max_value != max_health):
		($HealthBar as ProgressBar).max_value = max_health
	if (($HealthBar as ProgressBar).value != health):
		($HealthBar as ProgressBar).value = health

func spend_cards(_amount: int) -> void:
	cards_left_to_play_in_round -= _amount

func take_damage(_amount: int) -> void:
	health -= _amount
	
	if (health <= 0):
		health = 0
	
	update_healthbar()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
