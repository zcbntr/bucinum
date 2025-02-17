class_name PlayableComponent extends Node2D

func _enter_tree() -> void:
#	This component can only be a child of a CardObject
	assert(owner is CardObject)
	owner.set_meta(&"PlayableComponent", self)

func _exit_tree() -> void:
	owner.remove_meta(&"PlayableComponent")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
