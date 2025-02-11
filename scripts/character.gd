@tool
class_name Character extends Node2D

@export var max_health: int = 10
@export var health: int = max_health

func set_health_values(_health: int, _max_health: int) -> void:
	max_health = _max_health
	health = _health
	update_healthbar()

func update_healthbar():
	if (($HealthBar as ProgressBar).max_value != max_health):
		($HealthBar as ProgressBar).max_value = max_health
	if (($HealthBar as ProgressBar).value != health):
		($HealthBar as ProgressBar).value = health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
