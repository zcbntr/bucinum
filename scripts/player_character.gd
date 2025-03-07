class_name PlayerCharacter extends Character

signal category_clicked(category: String, card: CardObject)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_hand_category_clicked(category: String, card: CardObject) -> void:
	category_clicked.emit(category, card)
