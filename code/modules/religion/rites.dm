/datum/religion_rites
	/// name of the religious rite
	var/name = "宗教仪式"
	/// Description of the religious rite
	var/desc = "我就要跑跑跑"
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
		to_chat(user, span_warning("这个仪式需要更多恩惠！"))
		return FALSE
	return TRUE

///Called to perform the invocation of the rite, with args being the performer and the altar where it's being performed. Maybe you want it to check for something else?
/datum/religion_rites/proc/perform_rite(mob/living/user, atom/religious_tool)
	if(!can_afford(user))
		return FALSE
	to_chat(user, span_notice("你开始进行[name]的仪式..."))
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
	name = "合成转换"
	desc = "将类人个体转变为（更优越的）机器人.在祭坛上束缚一个人类来进行转化，否则它将转化你自己."
	ritual_length = 30 SECONDS
	ritual_invocations = list("By the inner workings of our god ...",
						"... We call upon you, in the face of adversity ...",
						"... to complete us, removing that which is undesirable ...")
	invoke_msg = "... Arise, our champion! Become that which your soul craves, live in the world as your true form!!"
	favor_cost = 1000

/datum/religion_rites/synthconversion/perform_rite(mob/living/user, atom/religious_tool)
	if(!ismovable(religious_tool))
		to_chat(user, span_warning("这个仪式需要一个能将个体束缚其上的宗教装置。"))
		return FALSE
	var/atom/movable/movable_reltool = religious_tool
	if(!movable_reltool)
		return FALSE
	if(LAZYLEN(movable_reltool.buckled_mobs))
		to_chat(user, span_warning("你将转化被束缚在[movable_reltool]上的那个个体。"))
	else
		if(!movable_reltool.can_buckle) //yes, if you have somehow managed to have someone buckled to something that now cannot buckle, we will still let you perform the rite!
			to_chat(user, span_warning("这个仪式需要一个能将个体束缚其上的宗教装置。"))
			return FALSE
		if(isandroid(user))
			to_chat(user, span_warning("你已经转化了自己。要转化他人，他们必须被束缚在[movable_reltool]上。"))
			return FALSE
		to_chat(user, span_warning("你将通过这个仪式转化自己。"))
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
	rite_target.visible_message(span_notice("[rite_target]已被[name]的仪式转化！"))
	return TRUE


/datum/religion_rites/machine_blessing
	name = "受祝"
	desc = "接受机械之神的祝福，让你能够进一步飞升."
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
		to_chat(user, span_warning("你需要一种支付仪式费用的方式！"))
		return FALSE
	if(account.account_balance < money_cost)
		to_chat(user, span_warning("这个仪式需要更多金钱！"))
		return FALSE
	return TRUE

/datum/religion_rites/greed/invoke_effect(mob/living/user, atom/movable/religious_tool)
	var/datum/bank_account/account = user.get_bank_account()
	if(!account || account.account_balance < money_cost)
		to_chat(user, span_warning("这个仪式需要更多金钱！"))
		return FALSE
	account.adjust_money(-money_cost, "Church Donation: Rite")
	. = ..()

/datum/religion_rites/greed/vendatray
	name = "购买销售收银台"
	desc = "召唤一个售卖台。您可以用它来出售物品！"
	invoke_msg = "I need a vend-a-tray to make some more money!"
	money_cost = 300

/datum/religion_rites/greed/vendatray/invoke_effect(mob/living/user, atom/movable/religious_tool)
	..()
	var/altar_turf = get_turf(religious_tool)
	new /obj/structure/displaycase/forsale(altar_turf)
	playsound(get_turf(religious_tool), 'sound/effects/cashregister.ogg', 60, TRUE)
	return TRUE

/datum/religion_rites/greed/custom_vending
	name = "购买个人自动售货机"
	desc = "召唤一台定制的自动售货机。您可以用它来出售大量的商品！"
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
	name = "维修道适应"
	desc = "开始你的转变吧，成为更适合维修道生存的角色。"
	ritual_length = 10 SECONDS
	ritual_invocations = list("I abandon the world ...",
	"... to become one with the deep.",
	"My form will become twisted ...")
	invoke_msg = "... but my smile I will keep!"
	favor_cost = 150 //150u of organic slurry

/datum/religion_rites/maint_adaptation/perform_rite(mob/living/carbon/human/user, atom/religious_tool)
	if(!ishuman(user))
		return FALSE
	//uses HAS_TRAIT_FROM because junkies are also hopelessly addicted
	if(HAS_TRAIT_FROM(user, TRAIT_HOPELESSLY_ADDICTED, "maint_adaptation"))
		to_chat(user, span_warning("You've already adapted."))
		return FALSE
	return ..()

/datum/religion_rites/maint_adaptation/invoke_effect(mob/living/user, atom/movable/religious_tool)
	..()
	to_chat(user, span_warning("你感到自己的基因被撼动并重塑。<b>你正在变成某种新事物。</b>"))
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
	name = "夜适应眼"
	desc = "只有在完成维修道适应后才能使用。你的双眼也会随之适应，而在强光下就会变得无法看清。"
	ritual_length = 10 SECONDS
	invoke_msg = "I no longer want to see the light."
	favor_cost = 300 //300u of organic slurry, i'd consider this a reward of the sect

/datum/religion_rites/adapted_eyes/perform_rite(mob/living/carbon/human/user, atom/religious_tool)
	if(!ishuman(user))
		return FALSE
	if(!HAS_TRAIT_FROM(user, TRAIT_HOPELESSLY_ADDICTED, "maint_adaptation"))
		to_chat(user, span_warning("你需要先适应维护区。"))
		return FALSE
	var/obj/item/organ/eyes/night_vision/maintenance_adapted/adapted = user.get_organ_slot(ORGAN_SLOT_EYES)
	if(adapted && istype(adapted))
		to_chat(user, span_warning("你的眼睛已经适应了！"))
		return FALSE
	return ..()

/datum/religion_rites/adapted_eyes/invoke_effect(mob/living/carbon/human/user, atom/movable/religious_tool)
	..()
	var/obj/item/organ/eyes/oldeyes = user.get_organ_slot(ORGAN_SLOT_EYES)
	to_chat(user, span_warning("你感到自己的眼睛适应了黑暗！"))
	if(oldeyes)
		oldeyes.Remove(user, special = TRUE)
		qdel(oldeyes)//eh
	var/obj/item/organ/eyes/night_vision/maintenance_adapted/neweyes = new
	neweyes.Insert(user, special = TRUE)

/datum/religion_rites/adapted_food
	name = "不食烟火"
	desc = "一旦适应了这种维修道状态，你就不能再吃普通食物了。这样应该会有帮助。"
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
	to_chat(user, span_warning("你需要将食物放在[religious_tool]上才能进行此操作！"))
	return FALSE

/datum/religion_rites/adapted_food/invoke_effect(mob/living/user, atom/movable/religious_tool)
	..()
	var/obj/item/food/moldify = mold_target
	mold_target = null
	if(QDELETED(moldify) || !(get_turf(religious_tool) == moldify.loc)) //check if the same food is still there
		to_chat(user, span_warning("你的目标离开了祭坛！"))
		return FALSE
	to_chat(user, span_warning("[moldify]变得腐坏了！"))
	user.emote("laugh")
	new /obj/item/food/badrecipe/moldy(get_turf(religious_tool))
	qdel(moldify)
	return TRUE

/datum/religion_rites/ritual_totem
	name = "创建仪式图腾"
	desc = "创建一个仪式图腾，这是一种便于携带的工具，可用于随时随地进行仪式活动。但是需要木材。只能由圣职者拾取。"
	favor_cost = 100
	invoke_msg = "Padala!!"
	///the food that will be molded, only one per rite
	var/obj/item/stack/sheet/mineral/wood/converted

/datum/religion_rites/ritual_totem/perform_rite(mob/living/user, atom/religious_tool)
	for(var/obj/item/stack/sheet/mineral/wood/could_totem in get_turf(religious_tool))
		converted = could_totem //totemify this o great one
		return ..()
	to_chat(user, span_warning("你至少需要1个木材才能进行此操作！"))
	return FALSE

/datum/religion_rites/ritual_totem/invoke_effect(mob/living/user, atom/movable/religious_tool)
	..()
	var/altar_turf = get_turf(religious_tool)
	var/obj/item/stack/sheet/mineral/wood/padala = converted
	converted = null
	if(QDELETED(padala) || !(get_turf(religious_tool) == padala.loc)) //check if the same food is still there
		to_chat(user, span_warning("你的目标离开了祭坛！"))
		return FALSE
	to_chat(user, span_warning("[padala] 重塑成了一个图腾！"))
	if(!padala.use(1))//use one wood
		return
	user.emote("laugh")
	new /obj/item/ritual_totem(altar_turf)
	return TRUE

///sparring god rites

/datum/religion_rites/sparring_contract
	name = "生成对练契约"
	desc = "将一些纸张变成一份协议书。"
	invoke_msg = "I will train in the name of my god."
	///paper to turn into a sparring contract
	var/obj/item/paper/contract_target

/datum/religion_rites/sparring_contract/perform_rite(mob/living/user, atom/religious_tool)
	for(var/obj/item/paper/could_contract in get_turf(religious_tool))
		if(could_contract.get_total_length()) //blank paper pls
			continue
		contract_target = could_contract
		return ..()
	to_chat(user, span_warning("你需要将空白纸张放在 [religious_tool] 上才能进行此操作！"))
	return FALSE

/datum/religion_rites/sparring_contract/invoke_effect(mob/living/user, atom/movable/religious_tool)
	..()
	var/obj/item/paper/blank_paper = contract_target
	var/turf/tool_turf = get_turf(religious_tool)
	contract_target = null
	if(QDELETED(blank_paper) || !(tool_turf == blank_paper.loc)) //check if the same paper is still there
		to_chat(user, span_warning("你的目标离开了祭坛！"))
		return FALSE
	blank_paper.visible_message(span_notice("文字在 [blank_paper] 上神奇地显现出来！"))
	playsound(tool_turf, 'sound/effects/pray.ogg', 50, TRUE)
	var/datum/religion_sect/spar/sect = GLOB.religious_sect
	if(sect.existing_contract)
		sect.existing_contract.visible_message(span_warning("[src] 嘶嘶作响，化为乌有！"))
		qdel(sect.existing_contract)
	sect.existing_contract = new /obj/item/sparring_contract(tool_turf)
	qdel(blank_paper)
	return TRUE

/datum/religion_rites/declare_arena
	name = "竞技场声明"
	desc = "将一个新的区域声明为适合进行格斗训练的区域。这样您就可以在合同中选择该区域了。"
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
	area_instance = tgui_input_list(user, "选择一个区域标记为竞技场！", "竞技场宣告", filtered)
	if(isnull(area_instance))
		return FALSE
	. = ..()

/datum/religion_rites/declare_arena/invoke_effect(mob/living/user, atom/movable/religious_tool)
	. = ..()
	var/datum/religion_sect/spar/sect = GLOB.religious_sect
	sect.arenas[area_instance.name] = area_instance.type
	to_chat(user, span_warning("[area_instance] 现在可以作为格斗契约的可选场地了。"))

/datum/religion_rites/ceremonial_weapon
	name = "打造仪式装备"
	desc = "锻造仪式装备，将某种材料转化为仪式装备。仪式用的刀剑在非实战情况下威力较弱，而且携带起来非常不便。"
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
		to_chat(user, span_warning("[not_rigid] is not suitable for being made into gear!"))
	else
		to_chat(user, span_warning("You need at least 5 sheets of a rigid material that can be made into gear!"))
	return FALSE

/datum/religion_rites/ceremonial_weapon/invoke_effect(mob/living/user, atom/movable/religious_tool)
	..()
	var/altar_turf = get_turf(religious_tool)
	var/obj/item/stack/sheet/used_for_blade = converted
	converted = null
	if(QDELETED(used_for_blade) || !(get_turf(religious_tool) == used_for_blade.loc) || used_for_blade.amount < 5) //check if the same food is still there
		to_chat(user, span_warning("你的目标离开了祭坛！"))
		return FALSE
	var/material_used = used_for_blade.material_type
	to_chat(user, span_warning("[used_for_blade] 重塑成了一把仪式刀刃！"))
	if(!used_for_blade.use(5))//use 5 of the material
		return
	var/obj/item/ceremonial_blade/blade = new(altar_turf)
	blade.set_custom_materials(list(SSmaterials.get_material(material_used) = SHEET_MATERIAL_AMOUNT * 5))
	return TRUE

/datum/religion_rites/unbreakable
	name = "变得坚不可摧"
	desc = "你的训练使你变得坚不可摧。在面临危机之时，你也会努力坚持战斗下去。"
	ritual_length = 10 SECONDS
	invoke_msg = "My will must be unbreakable. Grant me this boon!"
	favor_cost = 4 //4 duels won

/datum/religion_rites/unbreakable/perform_rite(mob/living/carbon/human/user, atom/religious_tool)
	if(!ishuman(user))
		return FALSE
	if(HAS_TRAIT_FROM(user, TRAIT_UNBREAKABLE, INNATE_TRAIT))
		to_chat(user, span_warning("你的精神已经坚不可摧了！"))
		return FALSE
	return ..()

/datum/religion_rites/unbreakable/invoke_effect(mob/living/carbon/human/user, atom/movable/religious_tool)
	..()
	to_chat(user, span_nicegreen("你感到 [GLOB.deity] 那继续战斗的意志正涌入你的身体！"))
	user.AddComponent(/datum/component/unbreakable)

/datum/religion_rites/tenacious
	name = "变得坚韧不拔"
	desc = "你的训练使你变得坚韧不拔。在面临危机的时候，你将能够更快地爬行。"
	ritual_length = 10 SECONDS
	invoke_msg = "Grant me your tenacity! I have proven myself!"
	favor_cost = 3 //3 duels won

/datum/religion_rites/tenacious/perform_rite(mob/living/carbon/human/user, atom/religious_tool)
	if(!ishuman(user))
		return FALSE
	if(HAS_TRAIT_FROM(user, TRAIT_TENACIOUS, INNATE_TRAIT))
		to_chat(user, span_warning("你的精神已经坚韧不拔了！"))
		return FALSE
	return ..()

/datum/religion_rites/tenacious/invoke_effect(mob/living/carbon/human/user, atom/movable/religious_tool)
	..()
	to_chat(user, span_nicegreen("你感到 [GLOB.deity] 的坚韧正涌入你的身体！"))
	user.AddElement(/datum/element/tenacious)
