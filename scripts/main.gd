extends Node2D

@onready var card_scene: PackedScene = preload("res://scenes/card.tscn")

@export var player_character: Character
@export var enemy_character: Character

@onready var game_controller: GameController = $GameController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_character = $GameScreen/PlayerCharacter
	enemy_character = $GameScreen/EnemyCharacter
	var player_cards: Array[Card]
	var enemy_cards: Array[Card]
	for n in 8:
		player_character.add_card_to_hand(generate_random_card())
		enemy_character.add_card_to_hand(generate_random_card())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_controller.current_state == GameController.GameState.ENEMY_TURN:
#		AI Logic
		play_enemy_hand()
		
		game_controller.transition(GameController.GameState.PLAYER_TURN)
	
	check_game_valid()
		

func play_enemy_hand() -> void:
	if (!enemy_character.hand_is_empty()):
		var card = enemy_character.remove_top_card()
		card.play({
			"caster": $GameScreen/EnemyCharacter,
			"targets": [$GameScreen/PlayerCharacter]
		})


func _on_deck_and_hand_card_played(card: Card) -> void:
#	Turn into a player turn method
#		Eventually make a function to calculate card cost - modifiers should change it
	var card_cost: int = 1
	if card_cost <= player_character.cards_left_to_play_in_round:
		card.play({
			"caster": $GameScreen/PlayerCharacter,
			"targets": [$GameScreen/EnemyCharacter]
		})

func check_game_valid() -> void:
	if (enemy_character.health <= 0):
		game_controller.transition(GameController.GameState.ROUND_WON)
	elif (player_character.health <= 0):
		game_controller.transition(GameController.GameState.GAMEOVER)
	elif game_controller.current_state == GameController.GameState.VICTORY:
		$CanvasLayer/VictoryOverlay.visible = true
	elif game_controller.current_state == GameController.GameState.GAMEOVER:
		$CanvasLayer/GameOverOverlay.visible = true
	
	game_controller.transition(GameController.GameState.ENEMY_TURN)


func _on_create_card_button_pressed() -> void:
	var card = generate_random_card()
	player_character.add_card_to_hand(card)

func _on_play_button_pressed() -> void:
	if (!player_character.hand_is_empty()):
		_on_deck_and_hand_card_played(player_character.remove_top_card())

func _on_delete_card_button_pressed() -> void:
	player_character.remove_selected_cards()

func generate_random_card() -> Card:
	var card = card_scene.instantiate()
	var rng = RandomNumberGenerator.new()
	var cost = rng.randi_range(1, 10)
	var damage = rng.randi_range(1, 10)
	var stats: Dictionary = {
		"Cuteness": rng.randi_range(1, 100),
		"Fluffyness": rng.randi_range(1, 100),
		"Mischief": rng.randi_range(1, 10),
		"Manners": rng.randi_range(1, 20),
		"Age": rng.randi_range(1, 22)
	}
	card.set_values("Card Name", "Card Description", cost, damage, stats)
	return card
