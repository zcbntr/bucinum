class_name Card extends Node2D

signal mouse_entered(card: Card)
signal mouse_exited(card: Card)
signal category_hovered(category: String, card: Card)
signal category_unhovered(card: Card)

const card_scene: PackedScene = preload("res://scenes/card.tscn")
const card_category_display_scene: PackedScene = preload("res://scenes/card_category_display.tscn")

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
@export var hovered_category: String

@onready var cost_lbl: Label = $CostDisplay/CostLbl
@onready var damage_lbl: Label = $DamageDisplay/DamageLbl
@onready var name_lbl: Label = $NameDisplay/NameLbl
@onready var base_sprite: Sprite2D = $BaseCardSprite
@onready var category_displays: Array[Node2D]
@onready var clickable_collision_area: CollisionShape2D = $ClickableArea/CollisionShape2D
@onready var action: Node2D = $CardAction

static func new_card(_name: String, _description: String, _cost: int, _damage: int, _stats: Dictionary) -> Card:
	var card: Card = card_scene.instantiate()
	
	card.set_values(_name, _description, _cost, _damage, _stats)
	
	return card


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_card_graphics()


func set_clickable_area_size(_size: Vector2) -> void:
	clickable_collision_area.shape.set_size(_size)


func show_cost() -> void:
	$CostDisplay.visible = true

func hide_cost() -> void:
	$CostDisplay.visible = false

func show_damage() -> void:
	$DamageDisplay.visible = true

func hide_damage() -> void:
	$DamageDisplay.visible = false


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
	name_lbl.set_text(card_name)
	
	cost_lbl.set_text(str(card_cost))
	
	damage_lbl.set_text(str(card_damage))
	
	#	Create category displays for each stat
	category_displays.clear()
	for i in stats.keys().size():
		var cat_display = card_category_display_scene.instantiate()
		cat_display.category_name = stats.keys()[i]
		cat_display.category_value = stats.values()[i]
		cat_display.position = Vector2(-39, -12 + (14 * i))
		cat_display.mouse_entered.connect(_on_category_mouse_entered)
		cat_display.mouse_exited.connect(_on_category_mouse_exited)
		add_child(cat_display)
		category_displays.push_back(cat_display)

func highlight():
	base_sprite.set_modulate(Color(0.75, 0.6, 0.75, 1))

func unhighlight():
	base_sprite.set_modulate(Color(1,1,1,1))

func select():
	base_sprite.set_modulate(Color(0.42, 0.25, 0.55, 1))
	
func highlight_select():
	base_sprite.set_modulate(Color(0.5, 0.3, 1, 1))

func highlight_category(category: String) -> void:
	for category_display in category_displays:
		if category_display.category_name == category:
			category_display.highlight()
			break

func unhighlight_category(category: String) -> void:
	for category_display in category_displays:
		if category_display.category_name == category:
			category_display.unhighlight()
			break

func unhighlight_all_categories() -> void:
	for category_display in category_displays:
		category_display.unhighlight()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	update_card_graphics()


func _on_clickable_area_mouse_entered() -> void:
	mouse_entered.emit(self)


func _on_clickable_area_mouse_exited() -> void:
	mouse_exited.emit(self)


func _on_category_mouse_entered(_category: String) -> void:
	hovered_category = _category
	category_hovered.emit(_category, self)


func _on_category_mouse_exited(_category: String) -> void:
	if (hovered_category == _category):
		hovered_category = ""
		category_unhovered.emit(self)
