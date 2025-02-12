@tool
extends Node2D

@export var category_name: String = "<category_name>"
@export var category_value: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	($CategoryLbl as Label).set_text(category_name + ":" + str(category_value))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
