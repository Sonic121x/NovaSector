/mob/living/basic/pet/cat/feral
	name = "野猫"
	desc = "小猫咪！！等等，不不不，别咬——"
	health = 30
	maxHealth = 30
	melee_damage_lower = 15
	melee_damage_upper = 15
	wound_bonus = -10
	exposed_wound_bonus = 20
	obj_damage = 0
	ai_controller = /datum/ai_controller/basic_controller/simple/simple_hostile
	faction = list(FACTION_CAT, ROLE_SYNDICATE)
