extends Node2D

@onready var card_scene: PackedScene = preload("res://scenes/card_object.tscn")

@export var player_character: Character
@export var enemy_character: Character

@export var shop: Shop

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().get_viewport().set_physics_object_picking_sort(true)
	
	load_player()
	load_enemy()
	
#	Give player their initial cards
	for n in 8:
		player_character.add_card_to_hand(CardObject.generate_random_card())
	
	shop = $Shop
	shop.player_character = player_character

func load_player() -> void:
	player_character = $GameScreen/PlayerCharacter
	player_character.set_health_values(50, 50)
	player_character.category_clicked.connect(_on_player_character_category_clicked)


func load_enemy() -> void:
	enemy_character = $GameScreen/EnemyCharacter
	enemy_character.set_health_values(15, 15)
	for n in 10:
		enemy_character.add_card_to_hand(CardObject.generate_random_card())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if GameController.current_state == GameController.GameState.ENEMY_TURN:
		$Shop.visible = false
		$GameScreen.visible = true
		$PlayUI.visible = true
		
#		AI Logic
		play_cards(enemy_character.get_random_category_to_play(), player_character.remove_top_card(), enemy_character.remove_top_card())

	elif GameController.current_state == GameController.GameState.PLAYER_TURN:
		$Shop.visible = false
		$GameScreen.visible = true
		$PlayUI.visible = true
		
	elif GameController.current_state == GameController.GameState.ROUND_WON:
		$PlayUI.visible = false
		$CanvasLayer.visible = true
		$CanvasLayer/RoundWonOverlay.visible = true
		
	elif GameController.current_state == GameController.GameState.VICTORY:
		$PlayUI.visible = false
		$CanvasLayer.visible = true
		$CanvasLayer/VictoryOverlay.visible = true
		
	elif GameController.current_state == GameController.GameState.GAMEOVER:
		$PlayUI.visible = false
		$CanvasLayer.visible = true
		$CanvasLayer/GameOverOverlay.visible = true
	
	elif GameController.current_state == GameController.GameState.SHOP:
		$GameScreen.visible = false
		$PlayUI.visible = false
		$CanvasLayer.visible = false
		$Shop.visible = true

func play_cards(_category: String, _player_card: CardObject, _enemy_card) -> void:	
	var player_card_playable_component = Component.find_component(_player_card, &"PlayableComponent")	
	var enemy_card_playable_component = Component.find_component(_enemy_card, &"PlayableComponent")
	assert(player_card_playable_component != null && enemy_card_playable_component != null)
	var play_data = PlayData.new()
	play_data.category = _category

#	First deal with no card played cases, where either or both cards are null
	if _enemy_card == null && _player_card == null:
		GameController.push_comparison_result(GameController.ComparisonResult.TIE)
	elif _enemy_card == null:
		play_data.caster = player_character
		play_data.targets.push_back(enemy_character)
		player_card_playable_component.play(play_data)
		player_character.add_card_to_hand(_player_card)
		
		GameController.push_comparison_result(GameController.ComparisonResult.PLAYER_WIN)
	elif _player_card == null:
		play_data.caster = enemy_character
		play_data.targets.push_back(player_character)
		enemy_card_playable_component.play(play_data)
		enemy_character.add_card_to_hand(_enemy_card)
		
		GameController.push_comparison_result(GameController.ComparisonResult.ENEMY_WIN)
	else:	
		var comparison_result = GameController.compare_cards(_category, _player_card, _enemy_card)
		if comparison_result == GameController.ComparisonResult.PLAYER_WIN:
			play_data.caster = player_character
			play_data.targets.push_back(enemy_character)
			player_card_playable_component.play(play_data)
			player_character.add_card_to_hand(_player_card)
			player_character.add_card_to_hand(_enemy_card)
		elif comparison_result == GameController.ComparisonResult.ENEMY_WIN:
			play_data.caster = enemy_character
			play_data.targets.push_back(player_character)
			enemy_card_playable_component.play(play_data)
			enemy_character.add_card_to_hand(_enemy_card)
			enemy_character.add_card_to_hand(_player_card)
		else:
			print("tie")
#			Implement tie breaker system in the future
#			Currently just throw away cards
#			Maybe trigger both cards actions but do not damage?
			pass
		GameController.push_comparison_result(comparison_result)
	
	transition_game_state()

func transition_game_state() -> void:
	if ((GameController.current_state == GameController.GameState.PLAYER_TURN || GameController.current_state == GameController.GameState.ENEMY_TURN) && enemy_character.health <= 0):
		GameController.transition(GameController.GameState.ROUND_WON)
	elif ((GameController.current_state == GameController.GameState.PLAYER_TURN || GameController.current_state == GameController.GameState.ENEMY_TURN) &&  player_character.health <= 0):
		GameController.transition(GameController.GameState.GAMEOVER)
	elif GameController.current_state == GameController.GameState.ENEMY_TURN:
		GameController.transition(GameController.GameState.PLAYER_TURN)
	elif GameController.current_state == GameController.GameState.PLAYER_TURN:
		GameController.transition(GameController.GameState.ENEMY_TURN)
	elif GameController.current_state == GameController.GameState.ROUND_WON:
		GameController.transition(GameController.GameState.SHOP)
		GameController.add_money(10)
	elif GameController.current_state == GameController.GameState.SHOP:
		GameController.transition(GameController.GameState.PLAYER_TURN)
		load_enemy()
		load_player()
	
	($StateLbl as Label).set_text(str(GameController.current_state))


func _on_create_card_button_pressed() -> void:
	var card = CardObject.generate_random_card()
	player_character.add_card_to_hand(card)

func _on_delete_card_button_pressed() -> void:
	player_character.remove_selected_cards()

func _on_player_character_category_clicked(category: String, card: CardObject) -> void:
	if GameController.current_state == GameController.GameState.PLAYER_TURN:
		if card == player_character.get_top_card():
			var top_card = player_character.remove_top_card()
			assert(Component.has_component(top_card, "PlayableComponent"))
			play_cards(category, top_card, enemy_character.remove_top_card())


func _on_continue_button_pressed() -> void:
	if (GameController.current_state == GameController.GameState.ROUND_WON):
		transition_game_state()


func _on_shop_exit_shop_pressed() -> void:
	if (GameController.current_state == GameController.GameState.SHOP):
		transition_game_state()
