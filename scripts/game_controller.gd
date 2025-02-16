class_name GameController extends Node2D

enum GameState {
	PLAYER_TURN,
	ENEMY_TURN,
	GAMEOVER,
	ROUND_WON,
	VICTORY,
	SHOP
}

enum ComparisonResult {
	PLAYER_WIN,
	ENEMY_WIN,
	TIE
}

@onready var current_state: GameState = GameState.PLAYER_TURN
@onready var comparison_history: Array[ComparisonResult]

var money: int = 0

func transition(next_state: GameState):
	current_state = next_state
	match current_state:
		GameState.PLAYER_TURN:
			pass
		GameState.ENEMY_TURN:
			pass
		GameState.GAMEOVER:
			pass
		GameState.ROUND_WON:
			pass
		GameState.VICTORY:
			pass
		GameState.SHOP:
			pass

func get_prev_comparison_result() -> ComparisonResult:
	return comparison_history.front()

func push_comparison_result(_result: ComparisonResult) -> void:
	comparison_history.push_front(_result)

static func compare_cards(_category: String, _player_card: Card, _enemy_card: Card) -> GameController.ComparisonResult:
	if _player_card.stats.get(_category) > _enemy_card.stats.get(_category):
		return GameController.ComparisonResult.PLAYER_WIN
	elif _player_card.stats.get(_category) < _enemy_card.stats.get(_category):
		return GameController.ComparisonResult.ENEMY_WIN
	else:
		return GameController.ComparisonResult.TIE

func add_money(_amount: int) -> void:
	money += _amount

func set_money(_amount: int) -> void:
	money = _amount

func remove_money(_amount: int) -> void:
	money -= _amount

func get_money() -> int:
	return money

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
