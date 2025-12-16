extends Resource

func evaluate(player_data: Dictionary) -> bool:
	return player_data.get("has_gun", false)

func can_choose(player_data: Dictionary) -> bool:
	# Used by DialogueChoice to enable/disable choices
	return evaluate(player_data)
