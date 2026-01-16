/mob/living/basic/hamsterking
	name = "hamsterking"
	desc = "A geneticly modified hamster,its big enough to carry you on their back."
	icon = 'modular_z121/icons/mob/pets.dmi'
	icon_state = "hamsterking_crown"
	icon_living = "hamsterking_crown"
	icon_dead = "hamsterking_dead"
	can_be_held = FALSE
	butcher_results = list(/obj/item/food/meat/slab/mouse = 2, /obj/item/clothing/head/costume/crown = 1)
	obj_damage = 0
	melee_damage_lower = 10
	melee_damage_upper = 10
	attack_sound = 'sound/items/weapons/bite.ogg'
	attack_vis_effect = ATTACK_EFFECT_BITE
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	melee_attack_cooldown = 1.5 SECONDS
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	health = 50
	maxHealth = 50
	speak_emote = list("squeaks")
	gold_core_spawnable = NO_SPAWN
	var/tame = FALSE
	var/static/list/food_types = list(
	/obj/item/food/grown/peanut,
	/obj/item/food/peanuts,
	/obj/item/food/semki,
	/obj/item/seeds/peanut,
	/obj/item/seeds/sunflower,
	)
	var/static/list/pet_commands = list(
		/datum/pet_command/idle,
		/datum/pet_command/free,
		/datum/pet_command/follow/start_active,
		/datum/pet_command/perform_trick_sequence,
	)

/mob/living/basic/hamsterking/Initialize(mapload, tame = FALSE, new_body_color)
	. =..()
	AddElement(/datum/element/pet_bonus, "squeak")
	AddComponent(/datum/component/obeys_commands, pet_commands)
	AddComponent(/datum/component/tameable, food_types = food_types, tame_chance = 100)

/mob/living/basic/hamsterking/tamed(mob/living/tamer, atom/food)
	AddElement(/datum/element/ridable, /datum/component/riding/creature/cow)

/obj/item/summon_beacon/donatepet/hamster
	name = "Pet beacon"
	desc = "Summons Pet!snack not included"
	selectable_atoms = list(/mob/living/basic/hamsterking)
