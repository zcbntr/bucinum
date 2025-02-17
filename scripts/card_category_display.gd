@tool
extends Node2D

signal mouse_entered(category_name: String)
signal mouse_exited(category_name: String)

@export var category_name: String = "<category_name>"
@export var category_value: int = 0
@export var highlighted: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	($CategoryLbl as Label).set_modulate(Color(0.8, 0.8, 0.8, 1))
	($CategoryLbl as Label).set_text(category_name + ":" + str(category_value))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_clickable_area_mouse_entered() -> void:
	mouse_entered.emit(category_name)

func _on_clickable_area_mouse_exited() -> void:
	mouse_exited.emit(category_name)

func highlight():
	highlighted = true
	($CategoryLbl as Label).set_modulate(Color(0.4, 0.2, 0.4, 1))

func unhighlight():
	highlighted = false
	($CategoryLbl as Label).set_modulate(Color(0.8, 0.8, 0.8, 1))
