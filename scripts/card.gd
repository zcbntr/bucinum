class_name Card extends Node2D


@export var card_name: String = "Card Name"
@export var card_description: String = "Card Description"
@export var card_cost: int = 1
@export var card_image: Node2D

@onready var cost_lbl: Label = $CostDisplay/CostLbl
@onready var name_lbl: Label = $NameDisplay/NameLbl
@onready var description_lbl: Label = $CardDescription

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_card_cost(card_cost)
	set_card_name(card_name)
	set_card_description(card_description)

func set_card_name(_name: String) -> void:
	card_name = _name
	name_lbl.set_text(_name)
	
func set_card_cost(_cost: int) -> void:
	card_cost = _cost
	cost_lbl.set_text(str(_cost))
	
func set_card_description(_description: String) -> void:
	card_description = _description
	description_lbl.set_text(_description)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
