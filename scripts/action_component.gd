class_name ActionComponent extends Node2D

func _enter_tree() -> void:
	assert(owner is CardObject)
	owner.set_meta(&"ActionComponent", self)

func _exit_tree() -> void:
	owner.remove_meta(&"ActionComponent")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func activate(game_state: Dictionary) -> void:
#	Do the action associated e.g. increase stats of next card played
	pass
