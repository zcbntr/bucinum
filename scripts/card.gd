class_name Card extends Node2D

signal mouse_entered(card: Card)
signal mouse_exited(card: Card)

@onready var card_category_display_scene: PackedScene = preload("res://scenes/card_category_display.tscn")

@export var action: Node2D

@export var stats: Dictionary = {
	"Cuteness": 99,
	"Fluffyness": 99,
	"Mischief": 100,
	"Manners": 14,
	"Age": 5,
	"Legs": 4
}

@export var card_name: String = "Card Name"
@export var card_description: String = "Card Description"
@export var card_cost: int = 1
@export var card_damage: int = 1
@export var card_image: Node2D
@export var selected_category_index: int = -1

@onready var cost_lbl: Label = $CostDisplay/CostLbl
@onready var damage_lbl: Label = $DamageDisplay/DamageLbl
@onready var name_lbl: Label = $NameDisplay/NameLbl
@onready var base_sprite: Sprite2D = $BaseCardSprite
@onready var category_displays: Array[Node2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CostDisplay.visible = false
	for i in stats.keys().size():
		var cat_display = card_category_display_scene.instantiate()
		cat_display.category_name = stats.keys()[i]
		cat_display.category_value = stats.values()[i]
		cat_display.position = Vector2(-39, -12 + (14 * i))
		add_child(cat_display)


func set_values(_name: String, _description: String, _cost: int, _damage: int, _stats: Dictionary) -> void:
	card_name = _name
	card_description = _description
	card_cost = _cost
	card_damage = _damage
	stats = _stats

func set_card_name(_name: String) -> void:
	card_name = _name
	update_card_graphics()

func set_card_cost(_cost: int) -> void:
	card_cost = _cost
	update_card_graphics()

func set_card_damage(_damage: int) -> void:
	card_damage = _damage
	update_card_graphics()

func set_card_description(_description: String) -> void:
	card_description = _description
	update_card_graphics()

# Syncs the card's graphics with the card's data
# Should only be run once the card is added to the scene tree otherwise the labels will be null
func update_card_graphics() -> void:
	print(selected_category_index)
	
	cost_lbl.set_text(str(card_cost))
	
	damage_lbl.set_text(str(card_damage))
	
	name_lbl.set_text(card_name)

func highlight():
	base_sprite.set_modulate(Color(0.75, 0.6, 0.75, 1))

func unhighlight():
	base_sprite.set_modulate(Color(1,1,1,1))

func select():
	base_sprite.set_modulate(Color(0.42, 0.25, 0.55, 1))
	
func highlight_select():
	base_sprite.set_modulate(Color(0.5, 0.3, 1, 1))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_card_graphics()


func _on_clickable_area_mouse_entered() -> void:
	mouse_entered.emit(self)


func _on_clickable_area_mouse_exited() -> void:
	mouse_exited.emit(self)

func activate(game_state: Dictionary):
	action.activate(game_state)


func _on_category_0_lbl_mouse_entered() -> void:
	selected_category_index = 0


func _on_category_0_lbl_mouse_exited() -> void:
	if (selected_category_index == 0):
		selected_category_index = -1


func _on_category_1_lbl_mouse_entered() -> void:
	selected_category_index = 1


func _on_category_1_lbl_mouse_exited() -> void:
	if (selected_category_index == 1):
		selected_category_index = -1


func _on_category_2_lbl_mouse_entered() -> void:
	selected_category_index = 2


func _on_category_2_lbl_mouse_exited() -> void:
	if (selected_category_index == 2):
		selected_category_index = -1


func _on_category_3_lbl_mouse_entered() -> void:
	selected_category_index = 3


func _on_category_3_lbl_mouse_exited() -> void:
	if (selected_category_index == 3):
		selected_category_index = -1


func _on_category_4_lbl_mouse_entered() -> void:
	selected_category_index = 4


func _on_category_4_lbl_mouse_exited() -> void:
	if (selected_category_index == 4):
		selected_category_index = -1


func _on_category_5_lbl_mouse_entered() -> void:
	selected_category_index = 5


func _on_category_5_lbl_mouse_exited() -> void:
	if (selected_category_index == 5):
		selected_category_index = -1


func _on_category_0_display_mouse_entered() -> void:
	selected_category_index = 0


func _on_category_0_display_mouse_exited() -> void:
	if (selected_category_index == 0):
		selected_category_index = -1
