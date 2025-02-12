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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
