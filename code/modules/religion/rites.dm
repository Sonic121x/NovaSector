// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/religion_rites
	/// name of the religious rite
	var/name = "religious rite"
	/// Description of the religious rite
	var/desc = "immm gonna rooon"
	/// length it takes to complete the ritual
	var/ritual_length = (10 SECONDS) //total length it'll take
	/// list of invocations said (strings) throughout the rite
	var/list/ritual_invocations //strings that are by default said evenly throughout the rite
	/// message when you invoke
	var/invoke_msg
	var/favor_cost = 0

	///Rite flags we use mostly to know when it should be deleted.
	// RITE_AUTO_DELETE | RITE_ALLOW_MULTIPLE_PERFORMS | RITE_ONE_TIME_USE
	var/rite_flags = RITE_AUTO_DELETE

/datum/religion_rites/New()
	. = ..()
	if(!GLOB?.religious_sect)
		return
	LAZYADD(GLOB.religious_sect.active_rites, src)

/datum/religion_rites/Destroy()
	if(GLOB?.religious_sect)
		LAZYREMOVE(GLOB.religious_sect.active_rites, src)
	return ..()

/datum/religion_rites/proc/can_afford(mob/living/user)
	if(GLOB.religious_sect?.favor < favor_cost)
		to_chat(user, span_warning(LANG("datum.da23d4c55e2b0fd1", null)))
		return FALSE
	return TRUE

///Called to perform the invocation of the rite, with args being the performer and the altar where it's being performed. Maybe you want it to check for something else?
/datum/religion_rites/proc/perform_rite(mob/living/user, atom/religious_tool)
	if(!can_afford(user))
		return FALSE
	to_chat(user, span_notice(LANG("datum.f24dd58359fff125", list(name))))
	if(!ritual_invocations)
		if(do_after(user, ritual_length))
			return TRUE
		return FALSE
	var/first_invoke = TRUE
	for(var/i in ritual_invocations)
		if(first_invoke) //instant invoke
			user.say(i)
			first_invoke = FALSE
			continue
		if(!length(ritual_invocations)) //we divide so we gotta protect
			return FALSE
		if(!do_after(user, ritual_length/length(ritual_invocations)))
			return FALSE
		user.say(i)
	if(!do_after(user, ritual_length/length(ritual_invocations))) //because we start at 0 and not the first fraction in invocations, we still have another fraction of ritual_length to complete
		return FALSE
	if(invoke_msg)
		user.say(invoke_msg)
	return TRUE


///Does the thing if the rite was successfully performed. return value denotes that the effect successfully (IE a harm rite does harm)
/datum/religion_rites/proc/invoke_effect(mob/living/user, atom/religious_tool)
	SHOULD_CALL_PARENT(TRUE)
	GLOB.religious_sect.on_riteuse(user, religious_tool)
	return TRUE

///Called if invoke effect returns TRUE, for effects meant to occur only if the rite passes.
/datum/religion_rites/proc/post_invoke_effects(mob/living/user, atom/religious_tool)
	SHOULD_CALL_PARENT(TRUE)
	if(!(rite_flags & RITE_ONE_TIME_USE))
		return
	GLOB.religious_sect.rites_list.Remove(src.type)

/datum/religion_rites/proc/refund(percent = 1.0)
	GLOB.religious_sect.adjust_favor(favor_cost * percent)

/**** Mechanical God ****/

/datum/religion_rites/synthconversion
	name = "Synthetic Conversion"
	desc = "Convert a humanoid individual into a (superior) android. Buckle a human to convert them, otherwise this rite will convert you."
	ritual_length = 30 SECONDS
	ritual_invocations = list("By the inner workings of our god ...",
						"... We call upon you, in the face of adversity ...",
						"... to complete us, removing that which is undesirable ...")
	invoke_msg = "... Arise, our champion! Become that which your soul craves, live in the world as your true form!!"
	favor_cost = 1000

/datum/religion_rites/synthconversion/perform_rite(mob/living/user, atom/religious_tool)
	if(!ismovable(religious_tool))
		to_chat(user, span_warning(LANG("datum.3ebb81f1929b18a9", null)))
		return FALSE
	var/atom/movable/movable_reltool = religious_tool
	if(!movable_reltool)
		return FALSE
	if(LAZYLEN(movable_reltool.buckled_mobs))
		to_chat(user, span_warning(LANG("datum.f12b65c720a95f6b", list(movable_reltool))))
	else
		if(!movable_reltool.can_buckle) //yes, if you have somehow managed to have someone buckled to something that now cannot buckle, we will still let you perform the rite!
			to_chat(user, span_warning(LANG("datum.3ebb81f1929b18a9", null)))
			return FALSE
		if(isandroid(user))
			to_chat(user, span_warning(LANG("datum.0f04672bb78ec652", list(movable_reltool))))
			return FALSE
		to_chat(user, span_warning(LANG("datum.64afac39250eddd6", null)))
	return ..()

/datum/religion_rites/synthconversion/invoke_effect(mob/living/user, atom/religious_tool)
	..()
	if(!ismovable(religious_tool))
		CRASH("[name]'s perform_rite had a movable atom that has somehow turned into a non-movable!")
	var/atom/movable/movable_reltool = religious_tool
	var/mob/living/carbon/human/rite_target
	if(!movable_reltool?.buckled_mobs?.len)
		rite_target = user
	else
		for(var/buckled in movable_reltool.buckled_mobs)
			if(ishuman(buckled))
				rite_target = buckled
				break
	if(!rite_target)
		return FALSE
	rite_target.set_species(/datum/species/android)
	rite_target.visible_message(span_notice(LANG("datum.22f6e65883a0dd1f", list(rite_target, name))))
	return TRUE


/datum/religion_rites/machine_blessing
	name = "Receive Blessing"
	desc = "Receive a blessing from the machine god to further your ascension."
	ritual_length = 5 SECONDS
	ritual_invocations = list(
		"Let your will power our forges.",
		"...Help us in our great conquest!",
	)
	invoke_msg = "The end of flesh is near!"
	favor_cost = 2000

/datum/religion_rites/machine_blessing/invoke_effect(mob/living/user, atom/movable/religious_tool)
	..()
	var/altar_turf = get_turf(religious_tool)
	var/blessing = pick_weight_recursive(
		list(
			// Arms
			list(
				/obj/item/organ/cyberimp/arm/toolkit/combat = 1,
				/obj/item/organ/cyberimp/arm/toolkit/surgery = 1000000,
				/obj/item/organ/cyberimp/arm/toolkit/toolset = 1500000,
			) = 15,
			// Eyes
			list(
				/obj/item/organ/cyberimp/eyes/hud/diagnostic = 1,
				/obj/item/organ/cyberimp/eyes/hud/medical = 1,
				/obj/item/organ/eyes/robotic/glow = 1,
				/obj/item/organ/eyes/robotic/shield = 2,
			) = 15,
			// Chest
			list(
				/obj/item/organ/cyberimp/chest/reviver = 1,
				/obj/item/organ/cyberimp/chest/thrusters = 2,
			) = 9,
			// Brain / Head
			list(
				/obj/item/organ/cyberimp/brain/anti_drop = 50,
				/obj/item/organ/cyberimp/brain/connector = 50,
				/obj/item/organ/cyberimp/brain/anti_stun = 10,
			) = 10,
			// Misc
			list(
				/obj/item/organ/cyberimp/mouth/breathing_tube = 1,
			) = 5,
		)
	)
	new blessing(altar_turf)
	return TRUE

/*********Greedy God**********/

///all greed rites cost money instead
/datum/religion_rites/greed
	ritual_length = 5 SECONDS
	invoke_msg = "Sorry I was late, I was just making a shitload of money."
	var/money_cost = 0

/datum/religion_rites/greed/can_afford(mob/living/user)
	var/datum/bank_account/account = user.get_bank_account()
	if(!account)
		to_chat(user, span_warning(LANG("datum.822e86d72d9f2617", null)))
		return FALSE
	if(account.account_balance < money_cost)
		to_chat(user, span_warning(LANG("datum.ff1fd927d65dbd5d", null)))
		return FALSE
	return TRUE

/datum/religion_rites/greed/invoke_effect(mob/living/user, atom/movable/religious_tool)
	var/datum/bank_account/account = user.get_bank_account()
	if(!account || account.account_balance < money_cost)
		to_chat(user, span_warning(LANG("datum.ff1fd927d65dbd5d", null)))
		return FALSE
	account.adjust_money(-money_cost, "Church Donation: Rite")
	. = ..()

/datum/religion_rites/greed/vendatray
	name = "Purchase Vend-A-Tray"
	desc = "Summons a vend-a-tray. You can use it to sell items!"
	invoke_msg = "I need a vend-a-tray to make some more money!"
	money_cost = 300

/datum/religion_rites/greed/vendatray/invoke_effect(mob/living/user, atom/movable/religious_tool)
	..()
	var/altar_turf = get_turf(religious_tool)
	new /obj/structure/displaycase/forsale(altar_turf)
	playsound(get_turf(religious_tool), 'sound/effects/cashregister.ogg', 60, TRUE)
	return TRUE

/datum/religion_rites/greed/custom_vending
	name = "Purchase Personal Vending Machine"
	desc = "Summons a custom vending machine. You can use it to sell MANY items!"
	invoke_msg = "If I get a custom vending machine for my products, I can be RICH!"
	money_cost = 1000 //quite a step up from vendatray

/datum/religion_rites/greed/custom_vending/invoke_effect(mob/living/user, atom/movable/religious_tool)
	..()
	var/altar_turf = get_turf(religious_tool)
	new /obj/machinery/vending/custom/greed(altar_turf)
	playsound(get_turf(religious_tool), 'sound/effects/cashregister.ogg', 60, TRUE)
	return TRUE

/*********Maintenance God**********/

/datum/religion_rites/maint_adaptation
	name = "Maintenance Adaptation"
	desc = "Begin your metamorphasis into a being more fit for Maintenance."
	ritual_length = 10 SECONDS
	ritual_invocations = list("I abandon the world ...",
	"... to become one with the deep ...",
	"... My form will become twisted ...")
	invoke_msg = "... but my smile I will keep!"
	favor_cost = 150 //150u of organic slurry

/datum/religion_rites/maint_adaptation/perform_rite(mob/living/carbon/human/user, atom/religious_tool)
	if(!ishuman(user))
		return FALSE
	//uses HAS_TRAIT_FROM because junkies are also hopelessly addicted
	if(HAS_TRAIT_FROM(user, TRAIT_HOPELESSLY_ADDICTED, "maint_adaptation"))
		to_chat(user, span_warning(LANG("datum.1dc578a34e21b6b1", null)))
		return FALSE
	return ..()

/datum/religion_rites/maint_adaptation/invoke_effect(mob/living/user, atom/movable/religious_tool)
	..()
	to_chat(user, span_warning(LANG("datum.acbe46927d5feae4", null)))
	user.emote("laugh")
	ADD_TRAIT(user, TRAIT_HOPELESSLY_ADDICTED, "maint_adaptation")
	//addiction sends some nasty mood effects but we want the maint adaption to be enjoyed like a fine wine
	user.add_mood_event("maint_adaptation", /datum/mood_event/maintenance_adaptation)
	if(iscarbon(user))
		var/mob/living/carbon/vomitorium = user
		vomitorium.vomit(VOMIT_CATEGORY_DEFAULT)
		var/datum/dna/dna = vomitorium.has_dna()
		dna?.add_mutation(/datum/mutation/stimmed, MUTATION_SOURCE_MAINT_ADAPT) //some fluff mutations
		dna?.add_mutation(/datum/mutation/strong, MUTATION_SOURCE_MAINT_ADAPT)
	user.mind.add_addiction_points(/datum/addiction/maintenance_drugs, 1000)//ensure addiction

/datum/religion_rites/adapted_eyes
	name = "Adapted Eyes"
	desc = "Only available after maintenance adaptation. Your eyes will adapt as well, becoming useless in the light."
	ritual_length = 10 SECONDS
	invoke_msg = "I no longer want to see the light."
	favor_cost = 300 //300u of organic slurry, i'd consider this a reward of the sect

/datum/religion_rites/adapted_eyes/perform_rite(mob/living/carbon/human/user, atom/religious_tool)
	if(!ishuman(user))
		return FALSE
	if(!HAS_TRAIT_FROM(user, TRAIT_HOPELESSLY_ADDICTED, "maint_adaptation"))
		to_chat(user, span_warning(LANG("datum.ed92d0ba4a1e2fb8", null)))
		return FALSE
	var/obj/item/organ/eyes/night_vision/maintenance_adapted/adapted = user.get_organ_slot(ORGAN_SLOT_EYES)
	if(adapted && istype(adapted))
		to_chat(user, span_warning(LANG("datum.81dc0d6962e8f97f", null)))
		return FALSE
	return ..()

/datum/religion_rites/adapted_eyes/invoke_effect(mob/living/carbon/human/user, atom/movable/religious_tool)
	..()
	var/obj/item/organ/eyes/oldeyes = user.get_organ_slot(ORGAN_SLOT_EYES)
	to_chat(user, span_warning(LANG("datum.b050c61e169a14a6", null)))
	if(oldeyes)
		oldeyes.Remove(user, special = TRUE)
		qdel(oldeyes)//eh
	var/obj/item/organ/eyes/night_vision/maintenance_adapted/neweyes = new
	neweyes.Insert(user, special = TRUE)

/datum/religion_rites/adapted_food
	name = "Moldify"
	desc = "Once adapted to the Maintenance, you will not be able to eat regular food. This should help."
	ritual_length = 5 SECONDS
	invoke_msg = "Moldify!"
	favor_cost = 5 //5u of organic slurry
	///the food that will be molded, only one per rite
	var/obj/item/food/mold_target

/datum/religion_rites/adapted_food/perform_rite(mob/living/user, atom/religious_tool)
	for(var/obj/item/food/could_mold in get_turf(religious_tool))
		if(istype(could_mold, /obj/item/food/badrecipe/moldy))
			continue
		mold_target = could_mold //moldify this o great one
		return ..()
	to_chat(user, span_warning(LANG("datum.2689e212c4ea705b", list(religious_tool))))
	return FALSE

/datum/religion_rites/adapted_food/invoke_effect(mob/living/user, atom/movable/religious_tool)
	..()
	var/obj/item/food/moldify = mold_target
	mold_target = null
	if(QDELETED(moldify) || !(get_turf(religious_tool) == moldify.loc)) //check if the same food is still there
		to_chat(user, span_warning(LANG("datum.a4aeac01f2519693", null)))
		return FALSE
	to_chat(user, span_warning(LANG("datum.d83d02909836da72", list(moldify))))
	user.emote("laugh")
	new /obj/item/food/badrecipe/moldy(get_turf(religious_tool))
	qdel(moldify)
	return TRUE

/datum/religion_rites/ritual_totem
	name = "Create Ritual Totem"
	desc = "Creates a ritual totem, a portable tool for performing rites on the go. Requires wood. Can only be picked up by the holy."
	favor_cost = 100
	invoke_msg = "Padala!!"
	///the food that will be molded, only one per rite
	var/obj/item/stack/sheet/mineral/wood/converted

/datum/religion_rites/ritual_totem/perform_rite(mob/living/user, atom/religious_tool)
	for(var/obj/item/stack/sheet/mineral/wood/could_totem in get_turf(religious_tool))
		converted = could_totem //totemify this o great one
		return ..()
	to_chat(user, span_warning(LANG("datum.f2cfa072839faf85", null)))
	return FALSE

/datum/religion_rites/ritual_totem/invoke_effect(mob/living/user, atom/movable/religious_tool)
	..()
	var/altar_turf = get_turf(religious_tool)
	var/obj/item/stack/sheet/mineral/wood/padala = converted
	converted = null
	if(QDELETED(padala) || !(get_turf(religious_tool) == padala.loc)) //check if the same food is still there
		to_chat(user, span_warning(LANG("datum.a4aeac01f2519693", null)))
		return FALSE
	to_chat(user, span_warning(LANG("datum.2938cb176c6e18ab", list(padala))))
	if(!padala.use(1))//use one wood
		return
	user.emote("laugh")
	new /obj/item/ritual_totem(altar_turf)
	return TRUE

///sparring god rites

/datum/religion_rites/sparring_contract
	name = "Summon Sparring Contract"
	desc = "Turns some paper into a sparring contract."
	invoke_msg = "I will train in the name of my god."
	///paper to turn into a sparring contract
	var/obj/item/paper/contract_target

/datum/religion_rites/sparring_contract/perform_rite(mob/living/user, atom/religious_tool)
	for(var/obj/item/paper/could_contract in get_turf(religious_tool))
		if(could_contract.get_total_length()) //blank paper pls
			continue
		contract_target = could_contract
		return ..()
	to_chat(user, span_warning(LANG("datum.24468dd588002b18", list(religious_tool))))
	return FALSE

/datum/religion_rites/sparring_contract/invoke_effect(mob/living/user, atom/movable/religious_tool)
	..()
	var/obj/item/paper/blank_paper = contract_target
	var/turf/tool_turf = get_turf(religious_tool)
	contract_target = null
	if(QDELETED(blank_paper) || !(tool_turf == blank_paper.loc)) //check if the same paper is still there
		to_chat(user, span_warning(LANG("datum.a4aeac01f2519693", null)))
		return FALSE
	blank_paper.visible_message(span_notice(LANG("datum.116a8c91bd760bf1", list(blank_paper))))
	playsound(tool_turf, 'sound/effects/pray.ogg', 50, TRUE)
	var/datum/religion_sect/spar/sect = GLOB.religious_sect
	if(sect.existing_contract)
		sect.existing_contract.visible_message(span_warning(LANG("datum.b8e21fc6925da0a2", list(src))))
		qdel(sect.existing_contract)
	sect.existing_contract = new /obj/item/sparring_contract(tool_turf)
	qdel(blank_paper)
	return TRUE

/datum/religion_rites/declare_arena
	name = "Declare Arena"
	desc = "Declare a new area as fit for sparring. You'll be able to select it in contracts."
	ritual_length = 6 SECONDS
	ritual_invocations = list("I seek new horizons ...")
	invoke_msg = "... may my climb be steep."
	favor_cost = 1 //only costs one holy battle for a new area
	var/area/area_instance

/datum/religion_rites/declare_arena/perform_rite(mob/living/user, atom/religious_tool)
	var/list/filtered = list()
	for(var/area/unfiltered_area as anything in get_sorted_areas())
		if(istype(unfiltered_area, /area/centcom)) //youuu dont need thaaat
			continue
		if(!(unfiltered_area.area_flags & HIDDEN_AREA))
			filtered += unfiltered_area
	area_instance = tgui_input_list(user, LANG("datum.2d87232f3bd5cfd4", null), LANG("datum.fe2c6b9e8a798d31", null), filtered)
	if(isnull(area_instance))
		return FALSE
	. = ..()

/datum/religion_rites/declare_arena/invoke_effect(mob/living/user, atom/movable/religious_tool)
	. = ..()
	var/datum/religion_sect/spar/sect = GLOB.religious_sect
	sect.arenas[area_instance.name] = area_instance.type
	to_chat(user, span_warning(LANG("datum.9de7bc9782c63218", list(area_instance))))

/datum/religion_rites/ceremonial_weapon
	name = "Forge Ceremonial Gear"
	desc = "Turn some material into ceremonial gear. Ceremonial blades are weak outside of sparring and quite heavy to lug around."
	ritual_length = 10 SECONDS
	invoke_msg = "Weapons in your name! Battles with your blood!"
	favor_cost = 0
	///the material that will be attempted to be forged into a weapon
	var/obj/item/stack/sheet/converted

/datum/religion_rites/ceremonial_weapon/perform_rite(mob/living/user, atom/religious_tool)
	var/not_rigid = null
	var/datum/material_requirement/requirement = SSmaterials.requirements[/datum/material_requirement/rigid_material]
	for(var/obj/item/stack/sheet/could_blade in get_turf(religious_tool))
		var/datum/material/blade_mat = SSmaterials.get_material(could_blade.material_type)
		if(!blade_mat)
			continue
		if(!requirement.valid_material(blade_mat))
			not_rigid = blade_mat
			continue
		if(could_blade.amount < 5)
			continue
		converted = could_blade
		return ..()
	// We've found a material but it wasn't solid enough.
	if(not_rigid)
		to_chat(user, span_warning(LANG("datum.a70e585a99f6b2d6", list(not_rigid))))
	else
		to_chat(user, span_warning(LANG("datum.b01c568e55a940c6", null)))
	return FALSE

/datum/religion_rites/ceremonial_weapon/invoke_effect(mob/living/user, atom/movable/religious_tool)
	..()
	var/altar_turf = get_turf(religious_tool)
	var/obj/item/stack/sheet/used_for_blade = converted
	converted = null
	if(QDELETED(used_for_blade) || !(get_turf(religious_tool) == used_for_blade.loc) || used_for_blade.amount < 5) //check if the same food is still there
		to_chat(user, span_warning(LANG("datum.a4aeac01f2519693", null)))
		return FALSE
	var/material_used = used_for_blade.material_type
	to_chat(user, span_warning(LANG("datum.b4a433eabe1cf447", list(used_for_blade))))
	if(!used_for_blade.use(5))//use 5 of the material
		return
	var/obj/item/ceremonial_blade/blade = new(altar_turf)
	blade.set_custom_materials(list(SSmaterials.get_material(material_used) = SHEET_MATERIAL_AMOUNT * 5))
	return TRUE

/datum/religion_rites/unbreakable
	name = "Become Unbreakable"
	desc = "Your training has made you unbreakable. In times of crisis, you will attempt to keep fighting on."
	ritual_length = 10 SECONDS
	invoke_msg = "My will must be unbreakable. Grant me this boon!"
	favor_cost = 4 //4 duels won

/datum/religion_rites/unbreakable/perform_rite(mob/living/carbon/human/user, atom/religious_tool)
	if(!ishuman(user))
		return FALSE
	if(HAS_TRAIT_FROM(user, TRAIT_UNBREAKABLE, INNATE_TRAIT))
		to_chat(user, span_warning(LANG("datum.58ba9c8b841cfe3f", null)))
		return FALSE
	return ..()

/datum/religion_rites/unbreakable/invoke_effect(mob/living/carbon/human/user, atom/movable/religious_tool)
	..()
	to_chat(user, span_nicegreen(LANG("datum.4d0c0eb3d1a2c908", list(GLOB.deity))))
	user.AddComponent(/datum/component/unbreakable)

/datum/religion_rites/tenacious
	name = "Become Tenacious"
	desc = "Your training has made you tenacious. In times of crisis, you will be able to crawl faster."
	ritual_length = 10 SECONDS
	invoke_msg = "Grant me your tenacity! I have proven myself!"
	favor_cost = 3 //3 duels won

/datum/religion_rites/tenacious/perform_rite(mob/living/carbon/human/user, atom/religious_tool)
	if(!ishuman(user))
		return FALSE
	if(HAS_TRAIT_FROM(user, TRAIT_TENACIOUS, INNATE_TRAIT))
		to_chat(user, span_warning(LANG("datum.7c814fcc37cbc20c", null)))
		return FALSE
	return ..()

/datum/religion_rites/tenacious/invoke_effect(mob/living/carbon/human/user, atom/movable/religious_tool)
	..()
	to_chat(user, span_nicegreen(LANG("datum.4eeffa1f518d51d8", list(GLOB.deity))))
	user.AddElement(/datum/element/tenacious)
