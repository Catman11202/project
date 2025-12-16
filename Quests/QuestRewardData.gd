class_name QuestRewardData
extends Resource

enum RewardType { ITEM, HEALTH, EXPERIENCE, UNLOCK_ABILITY, UNLOCK_QUEST }

@export var type: RewardType
@export var target_id: String = "" # Item ID, ability ID, quest ID
@export var amount: int = 0 # Quantity for items, health points, XP

func apply_reward(player_node: Node):
	# This function would be called by the QuestManager when a quest is completed.
	# 'player_node' would be the main player scene instance.
	match type:
		RewardType.ITEM:
			# Example: Add item to player's inventory
			if player_node.has_method("add_to_inventory"):
				player_node.add_to_inventory(target_id, amount)
			else:
				print("Player node does not have 'add_to_inventory' method.")
		RewardType.HEALTH:
			if player_node.has_method("heal"):
				player_node.heal(amount)
			else:
				print("Player node does not have 'heal' method.")
		RewardType.EXPERIENCE:
			if player_node.has_method("gain_xp"):
				player_node.gain_xp(amount)
			else:
				print("Player node does not have 'gain_xp' method.")
		RewardType.UNLOCK_ABILITY:
			if player_node.has_method("unlock_ability"):
				player_node.unlock_ability(target_id)
			else:
				print("Player node does not have 'unlock_ability' method.")
		RewardType.UNLOCK_QUEST:
			# This would likely involve informing the QuestManager to activate a quest
			# or make it available.
			# For now, let's just print a message.
			print("Unlocked quest: {target_id}")
