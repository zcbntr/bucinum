class_name CardObject extends Node2D

signal card_hovered(card: CardObject)
signal card_unhovered(card: CardObject)
signal category_hovered(category: String, card: CardObject)
signal category_unhovered(card: CardObject)
signal category_clicked(category: String, card: CardObject)
signal card_selected(card: CardObject)
signal card_unselected

static var hovered_cards: Array[CardObject]

static var card_scene: PackedScene = preload("res://scenes/card_object.tscn")
static var card_category_display_scene: PackedScene = preload("res://scenes/card_category_display.tscn")

static var playable_component_scene: PackedScene = preload("res://scenes/playable_component.tscn")
static var action_component_scene: PackedScene = preload("res://scenes/action_component.tscn")

@export var card_stats: Dictionary = {
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
@export var is_hovered: bool = false
@export var is_selected: bool = false

@onready var cost_lbl: Label = $CostDisplay/CostLbl
@onready var damage_lbl: Label = $DamageDisplay/DamageLbl
@onready var name_lbl: Label = $NameDisplay/NameLbl
@onready var base_sprite: Sprite2D = $BaseCardSprite
@onready var category_displays: Array[Node2D]
@onready var clickable_collision_area: CollisionShape2D = $ClickableArea/CollisionShape2D

static func new_card(_name: String, _description: String, _cost: int, _damage: int, _stats: Dictionary) -> CardObject:
	var card: CardObject = card_scene.instantiate()
	
	card.set_values(_name, _description, _cost, _damage, _stats)
	
	return card


static func generate_random_card() -> CardObject:
	var rng = RandomNumberGenerator.new()
	var cname = "Card " + str(rng.randi_range(1, 100))
	var ccost = rng.randi_range(1, 10)
	var cdamage = rng.randi_range(1, 10)
	var cstats: Dictionary = {
		"Cuteness": rng.randi_range(1, 100),
		"Fluffyness": rng.randi_range(1, 100),
		"Mischief": rng.randi_range(1, 10),
		"Manners": rng.randi_range(1, 20),
		"Age": rng.randi_range(1, 22)
	}
	
	var card = CardObject.new_card(cname, "", ccost, cdamage, cstats)
	return card


func make_playable() -> void:
	if !Component.has_component(self, &"PlayableComponent"):
		var playable_component: PlayableComponent = playable_component_scene.instantiate()
		playable_component.register_component(self, playable_component)

func make_actionable() -> void:
	if !Component.has_component(self, &"ActionComponent"):
		var action_component: ActionComponent = action_component_scene.instantiate()
		action_component.register_component(self, action_component)


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
	card_stats = _stats

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

func set_card_stats(_stats: Dictionary) -> void:
	#	Create category displays for each stat
	clear_category_displays()
	for i in card_stats.keys().size():
		var cat_display = card_category_display_scene.instantiate()
		cat_display.category_name = card_stats.keys()[i]
		cat_display.category_value = card_stats.values()[i]
		cat_display.position = Vector2(-39, -12 + (14 * i))
		cat_display.mouse_entered.connect(_on_category_mouse_entered)
		cat_display.mouse_exited.connect(_on_category_mouse_exited)
		cat_display.z_index = i
		add_child(cat_display)
		category_displays.push_back(cat_display)

# Syncs the card's graphics with the card's data
# Should only be run once the card is added to the scene tree otherwise the labels will be null
func update_card_graphics() -> void:	
	name_lbl.set_text(card_name)
	
	cost_lbl.set_text(str(card_cost))
	
	damage_lbl.set_text(str(card_damage))
	
	#	Create category displays for each stat
	if !category_displays.is_empty():
		clear_category_displays()
		
	for i in card_stats.keys().size():
		var cat_display = card_category_display_scene.instantiate()
		cat_display.category_name = card_stats.keys()[i]
		cat_display.category_value = card_stats.values()[i]
		cat_display.position = Vector2(-39, -12 + (14 * i))
		cat_display.mouse_entered.connect(_on_category_mouse_entered)
		cat_display.mouse_exited.connect(_on_category_mouse_exited)
		add_child(cat_display)
		category_displays.push_back(cat_display)

func clear_category_displays() -> void:
	for cd in category_displays:
		cd.queue_free()
	category_displays.clear()

func set_hovered():
	if (!is_hovered):
		is_hovered = true
		base_sprite.set_modulate(Color(0.75, 0.6, 0.75, 1))
		set_position(Vector2(position.x, position.y - 5))
		card_hovered.emit(self)

func set_unhovered():
	if (is_hovered):
		is_hovered = false
		base_sprite.set_modulate(Color(1,1,1,1))
		set_position(Vector2(position.x, position.y + 5))
		card_unhovered.emit(self)

func set_selected():
	if (!is_selected):
		is_selected = true
		set_position(Vector2(position.x, position.y - 15))
		card_selected.emit(self)

func set_unselected():
	if (is_selected):
		is_selected = false
		set_position(Vector2(position.x, position.y + 15))
		card_unselected.emit(self)
	
func highlight_select():
	is_hovered = true
	is_selected = true
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
	pass
	

static func rehighlight_hovered_card() -> void:
	if (hovered_cards.is_empty()):
		return
	
	var top_card_index = -1
	var top_card_z_index = -1
	for i in range(0, hovered_cards.size()):
		hovered_cards[i].set_unhovered()
		if hovered_cards[i].z_index > top_card_z_index:
			top_card_index = i
			top_card_z_index = hovered_cards[i].z_index
	
	hovered_cards[top_card_index].set_hovered()


func _on_clickable_area_mouse_entered() -> void:
	hovered_cards.push_back(self)
	rehighlight_hovered_card()


func _on_clickable_area_mouse_exited() -> void:
	hovered_cards.remove_at(hovered_cards.find(self))
	set_unhovered()
	rehighlight_hovered_card()


func _on_category_mouse_entered(_category: String) -> void:
	highlight_category(_category)
	category_hovered.emit(_category, self)


func _on_category_mouse_exited(_category: String) -> void:
	unhighlight_category(_category)
	category_unhovered.emit(self)


func get_selected_category() -> String:
	for cat in category_displays:
		if cat.highlighted:
			return cat.category_name
	return ""


func _on_clickable_area_input_event(viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("mouse_click"):
		viewport.set_input_as_handled() # Ignore items with lower z-index
		if (is_selected):
			set_unselected()
		elif (!is_selected):
			set_selected()
		
		var selected_category = get_selected_category()
		if selected_category != "":
			category_clicked.emit(selected_category, self)
