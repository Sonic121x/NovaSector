/// Root of shared behaviour for mobs spawned by blobs, is abstract and should not be spawned
/mob/living/basic/blob_minion
	abstract_type = /mob/living/basic/blob_minion
	name = "凝胶错误体"
	desc = "一个由错误代码或天体异常创造出的非功能性真菌生物。指指点点，嘲笑一番吧。"
	icon = 'icons/mob/nonhuman-player/blob.dmi'
	icon_state = "blob_head"
	base_icon_state = "blob_head"
	unique_name = TRUE
	status_flags = CANPUSH
	faction = list(ROLE_BLOB)
	combat_mode = TRUE
	bubble_icon = "blob"
	speak_emote = null
	habitable_atmos = null
	minimum_survivable_temperature = 0
	maximum_survivable_temperature = INFINITY
	lighting_cutoff_red = 20
	lighting_cutoff_green = 40
	lighting_cutoff_blue = 30
	initial_language_holder = /datum/language_holder/empty
	can_buckle_to = FALSE
	damage_coeff = list(BRUTE = 1, BURN = 1, TOX = 1, STAMINA = 0, OXY = 1)
	pull_force = MOVE_FORCE_NONE
	/// Size of cloud produced from a dying spore
	var/death_cloud_size = BLOBMOB_CLOUD_NONE
	var/loot = /obj/item/food/spore_sack

/mob/living/basic/blob_minion/New(loc, blob_borne)
	. = ..()
	if(blob_borne)
		pass_flags = PASSBLOB

/mob/living/basic/blob_minion/Initialize(mapload)
	. = ..()
	add_traits(list(TRAIT_BLOB_ALLY, TRAIT_MUTE), INNATE_TRAIT)
	AddComponent(/datum/component/blob_minion, on_strain_changed = CALLBACK(src, PROC_REF(on_strain_updated)), new_death_cloud_size = death_cloud_size)

	if(loot)
		if (islist(loot))
			loot = string_list(loot)
		AddElement(/datum/element/death_drops, loot)

/// Called when our blob overmind changes their variant, update some of our mob properties
/mob/living/basic/blob_minion/proc/on_strain_updated(mob/eye/blob/overmind, datum/blobstrain/new_strain)
	//revert independent blob mobs to the pale sprite so they can be recoloured
	if(new_strain)
		icon_state = base_icon_state

/// Associates this mob with a specific blob factory node
/mob/living/basic/blob_minion/proc/link_to_factory(obj/structure/blob/special/factory/factory)
	RegisterSignal(factory, COMSIG_QDELETING, PROC_REF(on_factory_destroyed))

/// Called when our factory is destroyed
/mob/living/basic/blob_minion/proc/on_factory_destroyed()
	SIGNAL_HANDLER
	to_chat(src, span_userdanger("你的工厂被摧毁了！你感到自己正在死去！"))
