/datum/hallucination/message
	random_hallucination_weight = 60
	hallucination_tier = HALLUCINATION_TIER_COMMON

/datum/hallucination/message/start()
	if(hallucinator.stat >= UNCONSCIOUS)
		return FALSE

	var/list/nearby_humans = list()
	var/adjacent_to_us = FALSE
	var/mob/living/carbon/human/suspicious_personnel
	for(var/mob/living/carbon/human/nearby_human in oview(hallucinator, 7))
		if(get_dist(nearby_human, hallucinator) <= 1)
			suspicious_personnel = nearby_human
			adjacent_to_us = TRUE
			break
		nearby_humans += nearby_human

	if(!suspicious_personnel && length(nearby_humans))
		suspicious_personnel = pick(nearby_humans)

	var/list/message_pool = list()
	if(suspicious_personnel)
		if(adjacent_to_us)
			message_pool[span_warning("你感到一阵轻微的刺痛！")] = 5

		var/obj/item/storage/equipped_backpack = suspicious_personnel.get_item_by_slot(ITEM_SLOT_BACK)
		if(istype(equipped_backpack))
			// in the future, this could / should be de-harcoded and
			// just draw from a pool uplink, theft, and antag item typepaths
			var/static/list/stash_item_paths = list(
				/obj/item/blueprints,
				/obj/item/assembly/flash,
				/obj/item/card/id/advanced/gold/captains_spare,
				/obj/item/card/emag,
				/obj/item/circular_saw,
				/obj/item/codex_cicatrix,
				/obj/item/grenade/c4,
				/obj/item/gun/ballistic/revolver,
				/obj/item/gun/energy/e_gun/hos,
				/obj/item/gun/energy/laser/captain,
				/obj/item/gun/energy/recharge/ebow,
				/obj/item/gun/syringe/syndicate,
				/obj/item/hand_tele,
				/obj/item/melee/baton/security,
				/obj/item/melee/cultblade/dagger,
				/obj/item/melee/energy,
				/obj/item/powersink, //this is a bulky item what
				/obj/item/reagent_containers/hypospray/cmo,
				/obj/item/spellbook,
			)
			var/obj/item/stashed_item = pick(stash_item_paths)
			message_pool[span_notice("[suspicious_personnel]将[initial(stashed_item.name)]放进了[equipped_backpack]。")] = 5

		message_pool["[span_bold("[suspicious_personnel]")] [pick("sneezes", "coughs")]."] = 1

	message_pool[span_notice("你听到有什么东西在管道里挤过...")] = 1

	message_pool[span_warning("你的[pick("arm", "leg", "back", "head")]发痒。")] = 1
	message_pool[span_warning("你感到[pick("hot", "cold", "dry", "wet", "woozy", "faint")]。")] = 1
	message_pool[span_warning("你的肚子咕咕叫。")] = 1
	message_pool[span_warning("你的头很痛。")] = 1
	message_pool[span_warning("你听到脑海中传来微弱的嗡嗡声。")] = 1

	if(prob(10))
		message_pool[span_warning("在你身后。")] = 1
		message_pool[span_warning("你听到一阵微弱的笑声。")] = 1
		message_pool[span_warning("你听到天花板上传来窸窸窣窣的声音。")] = 1
		message_pool[span_warning("你看见远处有一个非人般高大的轮廓在移动。")] = 2

	if(prob(30))
		var/some_help = pick_list_replacements(HALLUCINATION_FILE, "advice")
		message_pool[some_help] = 4

	var/chosen = pick_weight(message_pool)
	feedback_details += "Message: [chosen]"
	to_chat(hallucinator, chosen)
	qdel(src)
	return TRUE
