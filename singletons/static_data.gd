extends Node

var card_data = {}

var data_file_path = "res://data/static_data.json"

func _ready() -> void:
	card_data = load_json_file(data_file_path)

func load_json_file(file_path: String) -> Dictionary:
	if FileAccess.file_exists(file_path):
		var data_file = FileAccess.open(file_path, FileAccess.READ)
		var parsed_result = JSON.parse_string(data_file.get_as_text())
		
		if parsed_result is Dictionary:
			return parsed_result
		else:
			print("Error loading \"static_data.json\"")
			assert(false)
	else:
		print("Item data file \"static_data\" doesn't exist")
		assert(false)
	return {}
