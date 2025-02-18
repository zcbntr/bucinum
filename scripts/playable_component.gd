class_name PlayableComponent extends Component

func get_component_name() -> StringName:
	return "PlayableComponent"

func play(play_data: PlayData) -> void:
	var action_component: ActionComponent = Component.find_component(owner, &"ActionComponent")
	
	if action_component != null:
		action_component.pre_play_action(play_data)
		
	if action_component != null:
		action_component.play_action(play_data)
	
	play_function(play_data)
	
	if action_component != null:
		action_component.post_play_action(play_data)

func play_function(play_data: PlayData) -> void:
	var card: CardObject = owner
	for target in play_data.targets:
		target.take_damage(card.card_damage)
	
