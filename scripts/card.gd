class_name Card extends Node2D


@export var card_name: String = "Card Name"
@export var card_description: String = "Card Description"
@export var card_cost: int = 1
@export var card_damage: int = 1
@export var card_image: Node2D

@onready var cost_lbl: Label = $CostDisplay/CostLbl
@onready var damage_lbl: Label = $DamageDisplay/DamageLbl
@onready var name_lbl: Label = $NameDisplay/NameLbl
@onready var description_lbl: Label = $CardDescription

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_values("Card Name", "Card Description", 1, 2)
	
func set_values(_name: String, _description: String, _cost: int, _damage: int) -> void:
	card_name = _name
	card_description = _description
	card_cost = _cost
	card_damage = _damage

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
	
	if description_lbl.get_text() != card_description:
		description_lbl.set_text(card_description)
	visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_card_graphics()
