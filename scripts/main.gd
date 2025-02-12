extends Node2D

@export var player_character: Character
@export var enemy_character: Character

@onready var game_controller: GameController = $GameController

var enemy_character_state: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_character = $GameScreen/PlayerCharacter
	enemy_character = $GameScreen/EnemyCharacter


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_controller.current_state == GameController.GameState.ENEMY_TURN:
#		AI Logic
		if enemy_character_state == 0:
			enemy_character.add_armour(1)
			pass
		elif enemy_character_state == 1:
			enemy_character.add_armour(2)
			pass
		elif enemy_character_state == 2:
			enemy_character.add_armour(3)
			pass
		
		enemy_character_state = posmod(enemy_character_state + 1, 3)
		game_controller.transition(GameController.GameState.PLAYER_TURN)
	
	elif game_controller.current_state == GameController.GameState.VICTORY:
		$CanvasLayer/VictoryOverlay.visible = true
	elif game_controller.current_state == GameController.GameState.GAMEOVER:
		$CanvasLayer/GameOverOverlay.visible = true


func _on_deck_and_hand_card_played(card: Card) -> void:
#	Turn into a player turn method
#		Eventually make a function to calculate card cost - modifiers should change it
	var card_cost: int = 1
	if card_cost <= player_character.cards_left_to_play_in_round:
		card.play({
			"caster": $GameScreen/PlayerCharacter,
			"targets": [$GameScreen/EnemyCharacter]
		})
	
	if (enemy_character.health <= 0):
		game_controller.transition(GameController.GameState.ROUND_WON)
	elif (player_character.health <= 0):
		game_controller.transition(GameController.GameState.GAMEOVER)
	
	game_controller.transition(GameController.GameState.ENEMY_TURN)
#	Run enemy turn method
