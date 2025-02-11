class_name Card extends Node2D

signal mouse_entered(card: Card)
signal mouse_exited(card: Card)

@export var action: Node2D

@export var stats: Dictionary = {
	"Cuteness": 99,
	"Fluffyness": 99,
	"Mischief": 100,
	"Manners": 14,
	"Age": 5
}

@export var card_name: String = "Card Name"
@export var card_description: String = "Card Description"
@export var card_cost: int = 1
@export var card_damage: int = 1
@export var card_image: Node2D

@onready var cost_lbl: Label = $CostDisplay/CostLbl
@onready var damage_lbl: Label = $DamageDisplay/DamageLbl
@onready var name_lbl: Label = $NameDisplay/NameLbl
@onready var base_sprite: Sprite2D = $BaseCardSprite
@onready var categories_names_lbl: Label = $Categories/CategoryNamesLbl
@onready var categories_stats_lbl: Label = $Categories/CategoryStatsLbl

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
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
	if cost_lbl.get_text() != str(card_cost):
		cost_lbl.set_text(str(card_cost))
	
	if damage_lbl.get_text() != str(card_damage):
		damage_lbl.set_text(str(card_damage))
	
	if name_lbl.get_text() != card_name:
		name_lbl.set_text(card_name)
	
#	CBA to check if it needs doing, just do it
	var categories_name_lbl_string: String = ''
	var categories_stats_lbl_string: String = ''
	for category_name in stats.keys():
		categories_name_lbl_string += str(category_name) + ":\n"
	
	for category_stat in stats.values():
		categories_stats_lbl_string += str(category_stat) + "\n"
	
	categories_names_lbl.set_text(categories_name_lbl_string)
	categories_stats_lbl.set_text(categories_stats_lbl_string)
	
	visible = true
	
func highlight():
	base_sprite.set_modulate(Color(1, 0.9, 0.9, 1))

func unhighlight():
	base_sprite.set_modulate(Color(1,1,1,1))

func select():
	base_sprite.set_modulate(Color(0.42, 0.25, 0.8, 1))
	
func highlight_select():
	base_sprite.set_modulate(Color(0.5, 0.3, 1, 1))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_card_graphics()


func _on_clickable_area_mouse_entered() -> void:
	mouse_entered.emit(self)


func _on_clickable_area_mouse_exited() -> void:
	mouse_exited.emit(self)

func play(game_state: Dictionary):
	action.activate(game_state)
