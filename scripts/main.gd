extends Node2D

@onready var card_scene: PackedScene = preload("res://scenes/card.tscn")

@export var player_character: Character
@export var enemy_character: Character

@export var shop: Shop

@export var game_controller: GameController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_controller = $GameController
	shop = $Shop
	
	load_player()
	load_enemy()
	
#	Give player their initial cards
	for n in 8:
		player_character.add_card_to_hand(generate_random_card())
	
	game_controller.add_money(10)

func load_player() -> void:
	player_character = $GameScreen/PlayerCharacter
	player_character.set_health_values(50, 50)


func load_enemy() -> void:
	enemy_character = $GameScreen/EnemyCharacter
	enemy_character.set_health_values(15, 15)
	for n in 8:
		enemy_character.add_card_to_hand(generate_random_card())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	($StateLbl as Label).set_text(str(game_controller.current_state))
	
	if game_controller.current_state == GameController.GameState.ENEMY_TURN:
		$Shop.visible = false
		$GameScreen.visible = true
		$PlayUI.visible = true
#		AI Logic
		play_enemy_card()

	if game_controller.current_state == GameController.GameState.PLAYER_TURN:
		$Shop.visible = false
		$GameScreen.visible = true
		$PlayUI.visible = true
		
	elif game_controller.current_state == GameController.GameState.ROUND_WON:
		$PlayUI.visible = false
		$CanvasLayer/RoundWonOverlay.visible = true
		
	elif game_controller.current_state == GameController.GameState.VICTORY:
		$PlayUI.visible = false
		$CanvasLayer/VictoryOverlay.visible = true
		
	elif game_controller.current_state == GameController.GameState.GAMEOVER:
		$PlayUI.visible = false
		$CanvasLayer/GameOverOverlay.visible = true
	
	elif game_controller.current_state == GameController.GameState.SHOP:
		$GameScreen.visible = false
		$PlayUI.visible = false
		$CanvasLayer/RoundWonOverlay.visible = false
		$Shop.visible = true


func play_enemy_card() -> void:
	if (!enemy_character.hand_is_empty()):
		var enemy_card = enemy_character.remove_top_card()
		
#		If player has no cards then the enemy just plays theirs
		if player_character.hand_is_empty():
			enemy_card.activate({
				"caster": $GameScreen/EnemyCharacter,
				"targets": [$GameScreen/PlayerCharacter]
			})
			
			game_controller.push_comparison_result(GameController.ComparisonResult.ENEMY_WIN)
		else:
			var rng = RandomNumberGenerator.new()
			var category = enemy_card.stats.keys()[rng.randi_range(0, enemy_card.stats.keys().size() - 1)]
			var player_card = player_character.remove_top_card()
			var comparison_result = game_controller.compare_cards(category, player_card, enemy_card)
			if comparison_result == GameController.ComparisonResult.PLAYER_WIN:
				player_card.activate({
					"caster": $GameScreen/PlayerCharacter,
					"targets": [$GameScreen/EnemyCharacter]
				})
				player_character.add_card_to_hand(player_card)
			
			elif comparison_result == GameController.ComparisonResult.ENEMY_WIN:
				enemy_card.activate({
					"caster": $GameScreen/EnemyCharacter,
					"targets": [$GameScreen/PlayerCharacter]
				})
				
			else:
				print("tie")
	#			Implement tie breaker system in the future
	#			Currently just throw away cards
				pass
			game_controller.push_comparison_result(comparison_result)
	
	transition_game_state()


func play_player_card(_category: String, _card: Card) -> void:
	if (!player_character.hand_is_empty()):
		
#		If player has no cards then the enemy just plays theirs
		if enemy_character.hand_is_empty():
			_card.activate({
				"caster": $GameScreen/PlayerCharacter,
				"targets": [$GameScreen/EnemyCharacter]
			})
			
			game_controller.push_comparison_result(GameController.ComparisonResult.PLAYER_WIN)
		else:
			var enemy_card = enemy_character.remove_top_card()
			var comparison_result = game_controller.compare_cards(_category, _card, enemy_card)
			if comparison_result == GameController.ComparisonResult.PLAYER_WIN:
				_card.activate({
					"caster": $GameScreen/PlayerCharacter,
					"targets": [$GameScreen/EnemyCharacter]
				})
				player_character.add_card_to_hand(_card)
			elif comparison_result == GameController.ComparisonResult.ENEMY_WIN:
				enemy_card.activate({
					"caster": $GameScreen/EnemyCharacter,
					"targets": [$GameScreen/PlayerCharacter]
				})
			else:
				print("tie")
	#			Implement tie breaker system in the future
	#			Currently just throw away cards
				pass
			game_controller.push_comparison_result(comparison_result)
	
	transition_game_state()

func transition_game_state() -> void:
	if ((game_controller.current_state == GameController.GameState.PLAYER_TURN || game_controller.current_state == GameController.GameState.ENEMY_TURN) && enemy_character.health <= 0):
		game_controller.transition(GameController.GameState.ROUND_WON)
	elif ((game_controller.current_state == GameController.GameState.PLAYER_TURN || game_controller.current_state == GameController.GameState.ENEMY_TURN) &&  player_character.health <= 0):
		game_controller.transition(GameController.GameState.GAMEOVER)
	elif game_controller.current_state == GameController.GameState.ENEMY_TURN:
		game_controller.transition(GameController.GameState.PLAYER_TURN)
	elif game_controller.current_state == GameController.GameState.PLAYER_TURN:
		game_controller.transition(GameController.GameState.ENEMY_TURN)
	elif game_controller.current_state == GameController.GameState.ROUND_WON:
		game_controller.transition(GameController.GameState.SHOP)
		shop.set_money(game_controller.get_money())
	elif game_controller.current_state == GameController.GameState.SHOP:
		game_controller.transition(GameController.GameState.PLAYER_TURN)
		load_enemy()
		load_player()


func _on_create_card_button_pressed() -> void:
	var card = generate_random_card()
	player_character.add_card_to_hand(card)

func _on_delete_card_button_pressed() -> void:
	player_character.remove_selected_cards()

func generate_random_card() -> Card:
	var card = card_scene.instantiate()
	var rng = RandomNumberGenerator.new()
	var cardName = rng.randi_range(1, 100)
	var cost = rng.randi_range(1, 10)
	var damage = rng.randi_range(1, 10)
	var stats: Dictionary = {
		"Cuteness": rng.randi_range(1, 100),
		"Fluffyness": rng.randi_range(1, 100),
		"Mischief": rng.randi_range(1, 10),
		"Manners": rng.randi_range(1, 20),
		"Age": rng.randi_range(1, 22)
	}
	card.set_values("Card " + str(cardName), "Card Description", cost, damage, stats)
	return card


func _on_player_character_category_clicked(category: String, card: Card) -> void:
	if game_controller.current_state == GameController.GameState.PLAYER_TURN:
		if card == player_character.get_top_card():
			play_player_card(category, player_character.remove_top_card())


func _on_continue_button_pressed() -> void:
	if (game_controller.current_state == GameController.GameState.ROUND_WON):
		transition_game_state()


func _on_shop_exit_shop_pressed() -> void:
	if (game_controller.current_state == GameController.GameState.SHOP):
		transition_game_state()
