#define ALCOHOL_THRESHOLD_MODIFIER 1 //Greater numbers mean that less alcohol has greater intoxication potential
#define ALCOHOL_EXPONENT 1.6 //The exponent applied to boozepwr to make higher volume alcohol at least a little bit damaging to the liver

/datum/reagent/consumable/ethanol
	name = "Ethanol-乙醇"
	description = "一种广为人知、用途多样的酒精。"
	color = "#404030" // rgb: 64, 64, 48
	nutriment_factor = 0
	taste_description = "alcohol"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	creation_purity = 1 // impure base reagents are a big no-no
	ph = 7.33
	burning_temperature = 2193//ethanol burns at 1970C (at its peak)
	burning_volume = 0.1
	default_container = /obj/item/reagent_containers/cup/glass/bottle/beer
	fallback_icon = 'icons/obj/drinks/bottles.dmi'
	fallback_icon_state = "beer"
	/**
	 * Boozepwr Chart
	 *
	 * Higher numbers equal higher hardness, higher hardness equals more intense alcohol poisoning
	 *
	 * Note that all higher effects of alcohol poisoning will inherit effects for smaller amounts
	 * (i.e. light poisoning inherts from slight poisoning)
	 * In addition, severe effects won't always trigger unless the drink is poisonously strong
	 * All effects don't start immediately, but rather get worse over time; the rate is affected by the imbiber's alcohol tolerance
	 * (see [/datum/status_effect/inebriated])
	 *
	 * * 0: Non-alcoholic
	 * * 1-10: Barely classifiable as alcohol - occassional slurring
	 * * 11-20: Slight alcohol content - slurring
	 * * 21-30: Below average - imbiber begins to look slightly drunk
	 * * 31-40: Just below average - no unique effects
	 * * 41-50: Average - mild disorientation, imbiber begins to look drunk
	 * * 51-60: Just above average - disorientation, vomiting, imbiber begins to look heavily drunk
	 * * 61-70: Above average - small chance of blurry vision, imbiber begins to look smashed
	 * * 71-80: High alcohol content - blurry vision, imbiber completely shitfaced
	 * * 81-90: Extremely high alcohol content - heavy toxin damage, passing out
	 * * 91-100: Dangerously toxic - swift death
	 */
	var/boozepwr = 65

/datum/reagent/consumable/ethanol/New(list/data)
	if(LAZYLEN(data))
		if(!isnull(data["quality"]))
			quality = data["quality"]
			name = "Natural" + name
		if(data["boozepwr"])
			boozepwr = data["boozepwr"]
	if(boozepwr > 0)
		// the stronger the drink, the less total of the drink is needed to reach addiction
		LAZYSET(addiction_types, /datum/addiction/alcohol, max(50, round(150 - boozepwr, 5)))
	return ..()

/datum/reagent/consumable/ethanol/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(drinker.get_drunk_amount() < volume * boozepwr * ALCOHOL_THRESHOLD_MODIFIER || boozepwr < 0)
		var/booze_power = boozepwr
		if(HAS_TRAIT(drinker, TRAIT_ALCOHOL_TOLERANCE)) // we're an accomplished drinker
			booze_power *= 0.7
		if(HAS_TRAIT(drinker, TRAIT_LIGHT_DRINKER))
			booze_power *= 1.33 // NOVA EDIT CHANGE - ALCOHOL_PROCESSING - Original: booze_power *= 2

		// water will dilute alcohol effects
		var/total_water_volume = 0
		var/total_alcohol_volume = 0
		for(var/datum/reagent/water/sobriety in drinker.reagents.reagent_list)
			total_water_volume += sobriety.volume

		for(var/datum/reagent/consumable/ethanol/alcohol in drinker.reagents.reagent_list)
			total_alcohol_volume += alcohol.volume

		var/combined_dilute_volume = total_alcohol_volume + total_water_volume
		if(combined_dilute_volume) // safety check to prevent division by zero
			booze_power *= (total_alcohol_volume / combined_dilute_volume)

		for(var/mob/living/enemy as anything in drinker.ai_controller?.blackboard[BB_MONKEY_ENEMIES])
			drinker.ai_controller.add_blackboard_key_assoc(BB_MONKEY_ENEMIES, enemy, MONKEY_ANGERED_HATRED_AMOUNT * (boozepwr / 100) * metabolization_ratio * seconds_per_tick)

		// Volume, power, and server alcohol rate effect how quickly one gets drunk
		drinker.adjust_drunk_effect(1 * booze_power * ALCOHOL_RATE * metabolization_ratio * seconds_per_tick) // NOVA EDIT CHANGE - ALCOHOL_PROCESSING - Original: drinker.adjust_drunk_effect(1 * sqrt(volume) * booze_power * ALCOHOL_RATE * metabolization_ratio * seconds_per_tick)
		if(boozepwr > 0)
			var/obj/item/organ/liver/liver = drinker.get_organ_slot(ORGAN_SLOT_LIVER)
			var/heavy_drinker_multiplier = (HAS_TRAIT(drinker, TRAIT_HEAVY_DRINKER) ? 0.5 : 1)
			if (istype(liver))
				if(liver.apply_organ_damage(((max(sqrt(volume) * (boozepwr ** ALCOHOL_EXPONENT) * liver.alcohol_tolerance * heavy_drinker_multiplier * seconds_per_tick, 0))/300))) // NOVA EDIT CHANGE - ALCOHOL_PROCESSING - Original: if((((max(sqrt(volume) * (boozepwr ** ALCOHOL_EXPONENT) * liver.alcohol_tolerance * heavy_drinker_multiplier * seconds_per_tick, 0))/150)))
					return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/expose_obj(obj/exposed_obj, reac_volume, methods=TOUCH, show_message=TRUE)
	if(istype(exposed_obj, /obj/item/paper))
		var/obj/item/paper/paperaffected = exposed_obj
		paperaffected.clear_paper()
		to_chat(usr, span_notice("[paperaffected]的墨迹被洗掉了。"))
	if(istype(exposed_obj, /obj/item/book))
		if(reac_volume >= 5)
			var/obj/item/book/affectedbook = exposed_obj
			affectedbook.book_data.set_content("")
			exposed_obj.visible_message(span_notice("[exposed_obj]上的字迹被[name]洗掉了！"))
		else
			exposed_obj.visible_message(span_warning("[exposed_obj]的墨迹被[name]弄花了，但没有被洗掉！"))
	return ..()

/datum/reagent/consumable/ethanol/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)//Splashing people with ethanol isn't quite as good as fuel.
	. = ..()
	if(methods & INGEST)
		exposed_mob.check_allergic_reaction(ALCOHOL, chance = reac_volume * 5, histamine_add = min(10, reac_volume))

	if(methods & (TOUCH|VAPOR|PATCH))
		exposed_mob.adjust_fire_stacks(reac_volume / 15)
		exposed_mob.add_surgery_speed_mod("alcohol", round(1 - (boozepwr / 650), 0.05), min(reac_volume * 1 MINUTES, 5 MINUTES)) // Weak alcohol has less sterilizing power

/datum/reagent/consumable/ethanol/beer
	name = "Beer-啤酒"
	description = "一种自古地球时代就已酿造的酒精饮料。至今仍很受欢迎。"
	color = "#D7BC31" // rgb: 215, 188, 49
	nutriment_factor = 1
	boozepwr = 25
	taste_description = "mild carbonated malt"
	ph = 4
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_STOCK

// Beer is a chemical composition of alcohol and various other things. It's a garbage nutrient but hey, it's still one. Also alcohol is bad, mmmkay?
/datum/reagent/consumable/ethanol/beer/on_hydroponics_apply(obj/machinery/hydroponics/mytray, mob/user)
	mytray.adjust_plant_health(-round(volume * 0.05))
	mytray.adjust_waterlevel(round(volume * 0.7))

/datum/reagent/consumable/ethanol/beer/light
	name = "Light Beer-淡啤酒"
	description = "一种自古地球时代就已酿造的酒精饮料。这种品种降低了卡路里和酒精含量。"
	boozepwr = 5 //Space Europeans hate it
	taste_description = "dish water"
	ph = 5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/beer/maltliquor
	name = "Malt Liquor-麦芽酒"
	description = "一种自古在地球上酿造的酒精饮料。这种品种比通常的更烈、超便宜，也超难喝。"
	boozepwr = 35
	taste_description = "sweet corn beer and the hood life"
	ph = 4.8
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/beer/green
	name = "Green Beer-绿啤酒"
	description = "一种自古在地球上酿造的酒精饮料。这种品种被染成了喜庆的绿色。"
	color = COLOR_CRAYON_GREEN
	overdose_threshold = 55 //More than a glass
	taste_description = "green piss water"
	ph = 6
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/beer/green/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(drinker.color != color)
		drinker.add_atom_colour(color, TEMPORARY_COLOUR_PRIORITY)

/datum/reagent/consumable/ethanol/beer/green/on_mob_end_metabolize(mob/living/drinker)
	. = ..()
	drinker.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, color)

/datum/reagent/consumable/ethanol/beer/green/overdose_process(mob/living/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	metabolization_rate = REAGENTS_METABOLISM

	if(!ishuman(affected_mob))
		return

	var/mob/living/carbon/human/affected_human = affected_mob
	if(HAS_TRAIT(affected_human, TRAIT_USES_SKINTONES))
		affected_human.skin_tone = "green"
	else if(HAS_TRAIT(affected_human, TRAIT_MUTANT_COLORS) && !HAS_TRAIT(affected_human, TRAIT_FIXED_MUTANT_COLORS)) //Code stolen from spraytan overdose
		affected_human.dna.features[FEATURE_MUTANT_COLOR] = "#a8e61d"
	affected_human.update_body(is_creating = TRUE)

/datum/reagent/consumable/ethanol/kahlua
	name = "Kahlua-可可利口酒"
	description = "一种广为人知的墨西哥咖啡风味利口酒。自1936年起开始生产！"
	color = "#8e8368" // rgb: 142,131,104
	boozepwr = 45
	ph = 6
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	metabolized_traits = list(TRAIT_STIMULATED)

/datum/reagent/consumable/ethanol/kahlua/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	drinker.set_dizzy_if_lower(10 SECONDS * metabolization_ratio * seconds_per_tick)
	drinker.adjust_drowsiness(-6 SECONDS * metabolization_ratio * seconds_per_tick)
	drinker.AdjustSleeping(-4 SECONDS * metabolization_ratio * seconds_per_tick)
	if(!HAS_TRAIT(drinker, TRAIT_ALCOHOL_TOLERANCE))
		drinker.set_jitter_if_lower(10 SECONDS)

/datum/reagent/consumable/ethanol/whiskey
	name = "Whiskey-威士忌"
	description = "一种优质且陈年已久的单一麦芽威士忌。真棒。"
	color = "#b4a287" // rgb: 180,162,135
	boozepwr = 75
	taste_description = "molasses"
	ph = 4.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_STOCK

/datum/reagent/consumable/ethanol/whiskey/kong
	name = "Kong-港酒"
	description = "让你变成猿！&#174;"
	color = "#332100" // rgb: 51, 33, 0
	taste_description = "the grip of a giant ape"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/whiskey/candycorn
	name = "candy corn liquor-甜玉米酒"
	description = "就像他们在2D地下酒吧里喝的那样。"
	color = "#ccb800" // rgb: 204, 184, 0
	taste_description = "pancake syrup"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/whiskey/candycorn/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(SPT_PROB(5, seconds_per_tick))
		drinker.adjust_hallucinations(4 SECONDS * metabolization_ratio)

/datum/reagent/consumable/ethanol/thirteenloko
	name = "Thirteen Loko-十三乐可"
	description = "这是一杯十三乐可（Thirteen Loko），看起来品质上乘。我说的是饮料，不是杯子。"
	color = "#102000" // rgb: 16, 32, 0
	nutriment_factor = 1
	boozepwr = 80
	quality = DRINK_GOOD
	overdose_threshold = 60
	taste_description = "jitters and death"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	metabolized_traits = list(TRAIT_STIMULATED)

/datum/reagent/consumable/ethanol/thirteenloko/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	drinker.adjust_drowsiness(-14 SECONDS * metabolization_ratio * seconds_per_tick)
	drinker.AdjustSleeping(-4 SECONDS * metabolization_ratio * seconds_per_tick)
	drinker.adjust_bodytemperature(-5 * metabolization_ratio * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, drinker.get_body_temp_normal())
	if(!HAS_TRAIT(drinker, TRAIT_ALCOHOL_TOLERANCE))
		drinker.set_jitter_if_lower(10 SECONDS)

/datum/reagent/consumable/ethanol/thirteenloko/overdose_start(mob/living/drinker, metabolization_ratio)
	. = ..()
	to_chat(drinker, span_userdanger("你的整个身体剧烈颤抖，开始感到恶心。你真不该把那些[name]全喝掉！"))
	drinker.set_jitter_if_lower(40 SECONDS)
	drinker.Stun(1.5 SECONDS)

/datum/reagent/consumable/ethanol/thirteenloko/overdose_process(mob/living/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(SPT_PROB(3.5, seconds_per_tick) && iscarbon(drinker))
		var/obj/item/held_item = drinker.get_active_held_item()
		if(held_item)
			drinker.dropItemToGround(held_item)
			to_chat(drinker, span_notice("你的手在颤抖，把拿着的东西掉在了地上！"))
			drinker.set_jitter_if_lower(20 SECONDS)

	if(SPT_PROB(3.5, seconds_per_tick))
		to_chat(drinker, span_notice("[pick("You have a really bad headache.", "Your eyes hurt.", "You find it hard to stay still.", "You feel your heart practically beating out of your chest.")]"))

	if(SPT_PROB(2.5, seconds_per_tick) && iscarbon(drinker))
		var/obj/item/organ/eyes/eyes = drinker.get_organ_slot(ORGAN_SLOT_EYES)
		if(eyes && IS_ORGANIC_ORGAN(eyes)) // doesn't affect robotic eyes
			if(drinker.is_blind())
				eyes.Remove(drinker)
				eyes.forceMove(get_turf(drinker))
				to_chat(drinker, span_userdanger("你痛苦地弯下腰，感觉自己的眼球在脑袋里融化了！"))
				drinker.emote("scream")
				if(drinker.adjust_brute_loss(15 * metabolization_ratio, updating_health = FALSE, required_bodytype = affected_bodytype))
					. = UPDATE_MOB_HEALTH
			else
				to_chat(drinker, span_userdanger("你因失明而惊恐地尖叫！"))
				if(eyes.apply_organ_damage(eyes.maxHealth))
					. = UPDATE_MOB_HEALTH
				drinker.emote("scream")

	if(SPT_PROB(1.5, seconds_per_tick) && iscarbon(drinker))
		drinker.visible_message(span_danger("[drinker] 开始癫痫发作！"), span_userdanger("你癫痫发作了！"))
		if(drinker.Unconscious(10 SECONDS))
			. = UPDATE_MOB_HEALTH
		drinker.set_jitter_if_lower(700 SECONDS)

	if(SPT_PROB(0.5, seconds_per_tick) && iscarbon(drinker))
		drinker.apply_status_effect(/datum/status_effect/heart_attack)
		to_chat(drinker, span_userdanger("你相当确定刚才你的心脏停跳了一秒.."))
		drinker.playsound_local(drinker, 'sound/effects/singlebeat.ogg', 100, 0)

/datum/reagent/consumable/ethanol/vodka
	name = "Vodka-伏特加"
	description = "一杯乌特加。Xynta。"
	color = "#0064C8" // rgb: 0, 100, 200
	boozepwr = 65
	taste_description = "grain alcohol"
	ph = 8.1
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED|REAGENT_CLEANS //Very high proof
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	default_container = /obj/item/reagent_containers/cup/glass/bottle/vodka

/datum/reagent/consumable/ethanol/bilk
	name = "Bilk-奶啤"
	description = "这看起来像是啤酒混合了牛奶。真恶心。"
	color = "#895C4C" // rgb: 137, 92, 76
	nutriment_factor = 2
	boozepwr = 15
	taste_description = "desperation and lactate"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/bilk/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(drinker.get_brute_loss() && SPT_PROB(5, seconds_per_tick))
		if(drinker.heal_bodypart_damage(brute = 1 * metabolization_ratio, updating_health = FALSE))
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/threemileisland
	name = "Three Mile Island Iced Tea-三里岛冰茶"
	description = "为女人调制，但也够男人喝。"
	color = "#666340" // rgb: 102, 99, 64
	boozepwr = 10
	quality = DRINK_FANTASTIC
	taste_description = "dryness"
	ph = 3.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/threemileisland/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	drinker.set_drugginess(100 SECONDS * metabolization_ratio * seconds_per_tick)

/datum/reagent/consumable/ethanol/gin
	name = "Gin-杜松子酒"
	description = "一杯晶莹剔透的Griffeater杜松子酒。"
	color = "#d8e8f0" // rgb: 216,232,240
	boozepwr = 45
	taste_description = "an alcoholic christmas tree"
	ph = 6.9
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_STOCK

/datum/reagent/consumable/ethanol/rum
	name = "Rum-朗姆酒"
	description = "哟嚯嚯，诸如此类。"
	color = "#c9c07e" // rgb: 201,192,126
	boozepwr = 60
	taste_description = "spiked butterscotch"
	ph = 6.5
	default_container = /obj/item/reagent_containers/cup/glass/bottle/rum
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/rum/aged
	name = "陈年朗姆酒"
	description = "老天！这可是能和好哥们分享的顶级朗姆酒。"
	color = "#c0b675" // rgb: 192,183,117
	boozepwr = 70
	taste_description = "extra-spiked butterscotch"
	default_container = /obj/item/reagent_containers/cup/glass/bottle/rum/aged
	quality = DRINK_FANTASTIC
	metabolized_traits = list(TRAIT_STRONG_STOMACH)

/datum/reagent/consumable/ethanol/rum/aged/on_mob_metabolize(mob/living/drinker)
	. = ..()
	drinker.add_blocked_language(subtypesof(/datum/language) - /datum/language/piratespeak, source = LANGUAGE_DRINK)
	drinker.grant_language(/datum/language/piratespeak, source = LANGUAGE_DRINK)

/datum/reagent/consumable/ethanol/rum/aged/on_mob_end_metabolize(mob/living/drinker)
	if(!QDELING(drinker))
		drinker.remove_blocked_language(subtypesof(/datum/language), source = LANGUAGE_DRINK)
		drinker.remove_language(/datum/language/piratespeak, source = LANGUAGE_DRINK)
	return ..()

/datum/reagent/consumable/ethanol/tequila
	name = "Tequila-龙舌兰酒"
	description = "一种产自墨西哥的烈酒，口感浓烈，风味温和。渴了吗，老兄？"
	color = "#FFFF91" // rgb: 255, 255, 145
	boozepwr = 70
	taste_description = "paint stripper"
	ph = 4
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_STOCK

/datum/reagent/consumable/ethanol/vermouth
	name = "Vermouth-威末苦艾酒"
	description = "你突然很想喝一杯马提尼……"
	color = "#91FF91" // rgb: 145, 255, 145
	boozepwr = 45
	taste_description = "dry alcohol"
	ph = 3.25
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/wine
	name = "Wine-葡萄酒"
	description = "一种由蒸馏葡萄汁制成的优质酒精饮料。"
	color = "#7E4043" // rgb: 126, 64, 67
	boozepwr = 35
	taste_description = "bitter sweetness"
	ph = 3.45
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_STOCK
	default_container = /obj/item/reagent_containers/cup/glass/bottle/wine

/datum/reagent/consumable/ethanol/wine/on_merge(list/mix_data, amount)
	. = ..()
	if(data && mix_data && data["vintage"] != mix_data["vintage"])
		data["vintage"] = "mixed wine"

/datum/reagent/consumable/ethanol/wine/get_taste_description(mob/living/taster)
	if(HAS_TRAIT(taster,TRAIT_WINE_TASTER))
		if(data && data["vintage"])
			return list("[data["vintage"]]" = 1)
		else
			return list("synthetic wine"=1)
	return ..()

/datum/reagent/consumable/ethanol/lizardwine
	name = "Lizard Wine-蜥蜴酒"
	description = "一种来自太空中国的酒精饮料，通过将蜥蜴尾巴浸泡在乙醇中制成。"
	color = "#7E4043" // rgb: 126, 64, 67
	boozepwr = 45
	quality = DRINK_FANTASTIC
	taste_description = "scaley sweetness"
	ph = 3
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_STOCK

/datum/reagent/consumable/ethanol/grappa
	name = "Grappa-格拉巴酒"
	description = "一种优质的意大利白兰地，适合当普通葡萄酒对你来说不够劲的时候。"
	color = "#F8EBF1"
	boozepwr = 60
	taste_description = "classy bitter sweetness"
	ph = 3.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_STOCK

/datum/reagent/consumable/ethanol/amaretto
	name = "Amaretto-苦杏仁酒"
	description = "一种口感柔和、带有甜香的饮品。"
	color = "#E17600"
	boozepwr = 25
	taste_description = "fruity and nutty sweetness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_STOCK

/datum/reagent/consumable/ethanol/cognac
	name = "Cognac-干邑白兰地"
	description = "一种经过多次蒸馏和多年陈酿制成的甜味烈酒。优雅得如同交媾。"
	color = "#AB3C05" // rgb: 171, 60, 5
	boozepwr = 75
	taste_description = "smooth and french"
	ph = 3.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_STOCK

/datum/reagent/consumable/ethanol/absinthe
	name = "Absinthe-苦艾酒"
	description = "一种烈性酒精饮料。传闻会致幻，但其实不会。"
	color = rgb(10, 206, 0)
	boozepwr = 80 //Very strong even by default
	taste_description = "death and licorice"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/absinthe/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(SPT_PROB(5, seconds_per_tick) && !HAS_TRAIT(drinker, TRAIT_ALCOHOL_TOLERANCE))
		drinker.adjust_hallucinations(8 SECONDS * metabolization_ratio)

/datum/reagent/consumable/ethanol/hooch
	name = "私酿烈酒"
	description = "要么是某人调酒失败了，要么是尝试酿酒的结果。不管怎样，你真的想喝这个吗？"
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 100
	taste_description = "pure resignation"
	addiction_types = list(/datum/addiction/maintenance_drugs = 600)
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/ale
	name = "Ale-淡麦芽酒"
	description = "一种用麦芽大麦和酵母制成的深色酒精饮料。"
	color = "#976063" // rgb: 151,96,99
	boozepwr = 65
	taste_description = "hearty barley ale"
	ph = 4.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_STOCK

/datum/reagent/consumable/ethanol/goldschlager
	name = "Goldschlager-金箔伏特加"
	description = "100度的肉桂味烈酒，专为春假期间酗酒的少女们准备。"
	color = "#FFFF91" // rgb: 255, 255, 145
	boozepwr = 25
	quality = DRINK_NICE
	taste_description = "burning cinnamon"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

	// This drink is really popular with a certain demographic.
	var/teenage_girl_quality = DRINK_VERYGOOD

/datum/reagent/consumable/ethanol/goldschlager/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	// Reset quality each time, since the bottle can be shared
	quality = initial(quality)

	if(ishuman(exposed_mob))
		var/mob/living/carbon/human/human = exposed_mob
		// tgstation13 does not endorse underage drinking. laws may vary by your jurisdiction.
		if(human.age >= 13 && human.age <= 19 && human.gender == FEMALE)
			quality = teenage_girl_quality

	return ..()

/datum/reagent/consumable/ethanol/goldschlager/expose_mob(mob/living/exposed_mob, methods, reac_volume)
	. = ..()
	if(!(methods & INGEST))
		return

	var/convert_amount = reac_volume * min(GOLDSCHLAGER_GOLD_RATIO, 1)
	var/datum/reagents/mob_reagents = exposed_mob.reagents

	mob_reagents.remove_reagent(/datum/reagent/consumable/ethanol/goldschlager, convert_amount)
	mob_reagents.add_reagent(/datum/reagent/gold, convert_amount)


/datum/reagent/consumable/ethanol/patron
	name = "Patron-守护神"
	description = "龙舌兰酒中掺有银粉，是俱乐部场景中嗜酒女性的最爱。"
	color = "#585840" // rgb: 88, 88, 64
	boozepwr = 60
	quality = DRINK_VERYGOOD
	taste_description = "metallic and expensive"
	ph = 4.5
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_HIGH

/datum/reagent/consumable/ethanol/gintonic
	name = "金汤力"
	description = "永恒的经典，温和的鸡尾酒。"
	color = "#cae7ec" // rgb: 202,231,236
	boozepwr = 20
	quality = DRINK_NICE
	taste_description = "mild and tart"
	ph = 3
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_EASY

/datum/reagent/consumable/ethanol/rum_coke
	name = "朗姆可乐"
	description = "朗姆酒，混合了可乐。"
	taste_description = "cola"
	boozepwr = 30
	quality = DRINK_NICE
	color = "#3E1B00"
	ph = 4
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/cuba_libre
	name = "自由古巴"
	description = "革命万岁！古巴自由万岁！"
	color = "#3E1B00" // rgb: 62, 27, 0
	boozepwr = 50
	quality = DRINK_GOOD
	taste_description = "a refreshing marriage of citrus and rum"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/cuba_libre/on_mob_life(mob/living/carbon/cubano, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/need_mob_update
	if(cubano.mind && cubano.mind.has_antag_datum(/datum/antagonist/rev)) //Cuba Libre, the traditional drink of revolutions! Heals revolutionaries.
		need_mob_update = cubano.adjust_brute_loss(-1 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
		need_mob_update += cubano.adjust_fire_loss(-1 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
		need_mob_update += cubano.adjust_tox_loss(-1 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)
		need_mob_update += cubano.adjust_oxy_loss(-5 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/whiskey_cola
	name = "威士忌可乐"
	description = "威士忌，混合了可乐。出乎意料地提神。"
	color = "#3E1B00" // rgb: 62, 27, 0
	boozepwr = 40
	quality = DRINK_NICE
	taste_description = "cola"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/martini
	name = "经典马提尼"
	description = "味美思与金酒的混合。虽然不完全像007喜欢的那样，但依然美味。"
	color = "#cddbac" // rgb: 205,219,172
	boozepwr = 60
	quality = DRINK_NICE
	taste_description = "dry class"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_EASY

/datum/reagent/consumable/ethanol/vodkamartini
	name = "伏特加马提尼"
	description = "伏特加与金酒的混合。虽然不完全像007喜欢的那样，但依然美味。"
	color = "#cddcad" // rgb: 205,220,173
	boozepwr = 65
	quality = DRINK_NICE
	taste_description = "shaken, not stirred"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS


/datum/reagent/consumable/ethanol/white_russian
	name = "白俄人"
	description = "那只是，呃，你的个人看法，伙计……"
	color = "#A68340" // rgb: 166, 131, 64
	boozepwr = 50
	quality = DRINK_GOOD
	taste_description = "bitter cream"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/screwdrivercocktail
	name = "螺丝起子"
	description = "伏特加，混合了普通的橙汁。结果出奇地美味。"
	color = "#A68310" // rgb: 166, 131, 16
	boozepwr = 40
	quality = DRINK_NICE
	taste_description = "oranges"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/screwdrivercocktail/on_new(data)
	. = ..()
	// We want to turn only base drinking glasses with screwdriver(cocktail) into screwdrivers(tool),
	// but we can't check style so we have to check type, and we don't want it match subtypes like istype does
	if(holder?.my_atom && holder.my_atom.type == /obj/item/reagent_containers/cup/glass/drinkingglass/)
		RegisterSignal(holder, COMSIG_REAGENTS_HOLDER_UPDATED, PROC_REF(on_reagent_change))
		if(src == holder.get_master_reagent())
			var/obj/item/reagent_containers/cup/glass/drinkingglass/drink = holder.my_atom
			drink.tool_behaviour = TOOL_SCREWDRIVER
			drink.usesound = list('sound/items/tools/screwdriver.ogg', 'sound/items/tools/screwdriver2.ogg')

/datum/reagent/consumable/ethanol/screwdrivercocktail/Destroy()
	var/obj/item/reagent_containers/cup/glass/drinkingglass/drink = holder.my_atom
	if(istype(drink))
		if(drink.tool_behaviour == TOOL_SCREWDRIVER)
			drink.tool_behaviour = initial(drink.tool_behaviour)
			drink.usesound = initial(drink.usesound)
		UnregisterSignal(holder, COMSIG_REAGENTS_HOLDER_UPDATED)
	return ..()

/datum/reagent/consumable/ethanol/screwdrivercocktail/proc/on_reagent_change(datum/reagents/reagents)
	SIGNAL_HANDLER
	var/obj/item/reagent_containers/cup/glass/drinkingglass/drink = reagents.my_atom
	if(reagents.get_master_reagent() == src)
		drink.tool_behaviour = TOOL_SCREWDRIVER
		drink.usesound = list('sound/items/tools/screwdriver.ogg', 'sound/items/tools/screwdriver2.ogg')
	else
		drink.tool_behaviour = initial(drink.tool_behaviour)
		drink.usesound = initial(drink.usesound)

/datum/reagent/consumable/ethanol/screwdrivercocktail/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/obj/item/organ/liver/liver = drinker.get_organ_slot(ORGAN_SLOT_LIVER)
	if(HAS_TRAIT(liver, TRAIT_ENGINEER_METABOLISM))
		ADD_TRAIT(drinker, TRAIT_HALT_RADIATION_EFFECTS, "[type]")
		if (HAS_TRAIT(drinker, TRAIT_IRRADIATED))
			if(drinker.adjust_tox_loss(-2 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
				return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/screwdrivercocktail/on_mob_end_metabolize(mob/living/drinker)
	. = ..()
	REMOVE_TRAIT(drinker, TRAIT_HALT_RADIATION_EFFECTS, "[type]")

/datum/reagent/consumable/ethanol/booger
	name = "鼻涕虫"
	description = "呃……"
	color = "#8CFF8C" // rgb: 140, 255, 140
	boozepwr = 45
	quality = DRINK_GOOD
	taste_description = "sweet 'n creamy"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/bloody_mary
	name = "血腥玛丽"
	description = "一种由伏特加、番茄和酸橙汁制成的奇特而愉悦的混合物。或者至少你认为那红色的东西是番茄汁。"
	color = "#bf707c" // rgb: 191,112,124
	boozepwr = 55
	quality = DRINK_GOOD
	taste_description = "tomatoes with a hint of lime and liquid murder"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/bloody_mary/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	drinker.adjust_blood_volume(min(0.25 + round(0.75 * drinker.get_drunk_amount() / 40, 0.1), 2) * metabolization_ratio * seconds_per_tick, maximum = BLOOD_VOLUME_NORMAL) // Bloody Mary restores blood loss based on how drunk you are drinker. // NOVA EDIT CHANGE - ORIGINAL: adjust_blood_volume((0.25 + round(2 * drinker.get_drunk_amount() / 40, 0.1)) * metabolization_ratio * seconds_per_tick, maximum = BLOOD_VOLUME_NORMAL) // Bloody Mary restores blood loss based on how drunk you are

/datum/reagent/consumable/ethanol/brave_bull
	name = "勇敢公牛"
	description = "它的效果和荷兰勇气酒一样好！"
	color = "#a79f98" // rgb: 167,159,152
	boozepwr = 60
	quality = DRINK_NICE
	taste_description = "alcoholic bravery"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_EASY
	metabolized_traits = list(TRAIT_FEARLESS, TRAIT_ANALGESIA)
	var/tough_text

/datum/reagent/consumable/ethanol/brave_bull/on_mob_metabolize(mob/living/drinker)
	. = ..()
	tough_text = pick("brawny", "tenacious", "tough", "hardy", "sturdy") //Tuff stuff
	to_chat(drinker, span_notice("你感觉[tough_text]！"))
	drinker.maxHealth += 10 //Brave Bull makes you sturdier, and thus capable of withstanding a tiny bit more punishment.
	drinker.health += 10

/datum/reagent/consumable/ethanol/brave_bull/on_mob_end_metabolize(mob/living/drinker)
	. = ..()
	to_chat(drinker, span_notice("你不再感觉[tough_text]。"))
	drinker.maxHealth -= 10
	drinker.health = min(drinker.health - 10, drinker.maxHealth) //This can indeed crit you if you're alive solely based on alchol ingestion

/datum/reagent/consumable/ethanol/tequila_sunrise
	name = "龙舌兰日出"
	description = "龙舌兰、石榴糖浆和橙汁。"
	color = "#FFE48C" // rgb: 255, 228, 140
	boozepwr = 45
	quality = DRINK_GOOD
	taste_description = "oranges with a hint of pomegranate"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_MEDIUM
	var/obj/effect/light_holder

/datum/reagent/consumable/ethanol/tequila_sunrise/on_mob_metabolize(mob/living/drinker)
	. = ..()
	to_chat(drinker, span_notice("你感到一股温和的暖流流遍全身！"))
	light_holder = new(drinker)
	light_holder.set_light(3, 0.7, COLOR_TANGERINE_YELLOW) //Tequila Sunrise makes you radiate dim light, like a sunrise!

/datum/reagent/consumable/ethanol/tequila_sunrise/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	if(QDELETED(light_holder))
		holder.del_reagent(type) //If we lost our light object somehow, remove the reagent
	else if(light_holder.loc != drinker)
		light_holder.forceMove(drinker)
	return ..()

/datum/reagent/consumable/ethanol/tequila_sunrise/on_mob_end_metabolize(mob/living/drinker)
	. = ..()
	to_chat(drinker, span_notice("你体内的暖意消退了。"))
	QDEL_NULL(light_holder)

/datum/reagent/consumable/ethanol/toxins_special
	name = "毒素特调"
	description = "这东西着火了！快叫该死的穿梭机！"
	color = "#8880a8" // rgb: 136,128,168
	boozepwr = 25
	quality = DRINK_VERYGOOD
	taste_description = "spicy toxins"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/toxins_special/on_mob_life(mob/living/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	drinker.adjust_bodytemperature(15 * metabolization_ratio * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, 0, drinker.get_body_temp_normal() + 20) //310.15 is the normal bodytemp.

/datum/reagent/consumable/ethanol/beepsky_smash
	name = "比普斯基粉碎"
	description = "喝下这个，准备迎接法律吧。"
	color = COLOR_OLIVE // rgb: 128,128,0
	boozepwr = 60 //THE FIST OF THE LAW IS STRONG AND HARD
	quality = DRINK_GOOD
	metabolization_rate = 1.25 * REAGENTS_METABOLISM
	taste_description = "JUSTICE"
	overdose_threshold = 40
	ph = 2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	var/datum/brain_trauma/special/beepsky/beepsky_hallucination

/datum/reagent/consumable/ethanol/beepsky_smash/on_mob_metabolize(mob/living/carbon/drinker)
	. = ..()
	if(HAS_TRAIT(drinker, TRAIT_ALCOHOL_TOLERANCE))
		metabolization_rate = 4 * REAGENTS_METABOLISM
	// if you don't have a liver, or your liver isn't an officer's liver
	var/obj/item/organ/liver/liver = drinker.get_organ_slot(ORGAN_SLOT_LIVER)
	if(!liver || !HAS_TRAIT(liver, TRAIT_LAW_ENFORCEMENT_METABOLISM))
		beepsky_hallucination = new()
		drinker.gain_trauma(beepsky_hallucination, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/reagent/consumable/ethanol/beepsky_smash/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	drinker.set_jitter_if_lower(4 SECONDS)
	var/obj/item/organ/liver/liver = drinker.get_organ_slot(ORGAN_SLOT_LIVER)
	// if you have a liver and that liver is an officer's liver
	if(liver && HAS_TRAIT(liver, TRAIT_LAW_ENFORCEMENT_METABOLISM))
		if(drinker.adjust_stamina_loss(-4 * metabolization_ratio * seconds_per_tick, updating_stamina = FALSE, required_biotype = affected_biotype))
			. = UPDATE_MOB_HEALTH
		if(SPT_PROB(10, seconds_per_tick))
			drinker.cause_hallucination(get_random_valid_hallucination_subtype(/datum/hallucination/nearby_fake_item), name)
		if(SPT_PROB(5, seconds_per_tick))
			drinker.cause_hallucination(/datum/hallucination/stray_bullet, name)

/datum/reagent/consumable/ethanol/beepsky_smash/on_mob_end_metabolize(mob/living/carbon/drinker)
	. = ..()
	if(beepsky_hallucination)
		QDEL_NULL(beepsky_hallucination)

/datum/reagent/consumable/ethanol/beepsky_smash/overdose_start(mob/living/carbon/drinker, metabolization_ratio)
	. = ..()
	var/obj/item/organ/liver/liver = drinker.get_organ_slot(ORGAN_SLOT_LIVER)
	// if you don't have a liver, or your liver isn't an officer's liver
	if(!liver || !HAS_TRAIT(liver, TRAIT_LAW_ENFORCEMENT_METABOLISM))
		drinker.gain_trauma(/datum/brain_trauma/mild/phobia/security, TRAUMA_RESILIENCE_BASIC)

/datum/reagent/consumable/ethanol/irish_cream
	name = "爱尔兰奶油"
	description = "威士忌浸泡的奶油，你还能指望爱尔兰人做出什么别的？"
	color = "#e3d0b2" // rgb: 227,208,178
	boozepwr = 35
	quality = DRINK_NICE
	taste_description = "creamy alcohol"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/manly_dorf
	name = "纯爷们矮人"
	description = "啤酒和麦芽酒，混合成美味的饮品。仅供真汉子享用。"
	color = "#815336" // rgb: 129,83,54
	boozepwr = 100 //For the manly only
	quality = DRINK_NICE
	taste_description = "hair on your chest and your chin"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	var/dorf_mode = FALSE

/datum/reagent/consumable/ethanol/manly_dorf/on_mob_metabolize(mob/living/drinker)
	. = ..()
	if(ishuman(drinker))
		var/mob/living/carbon/human/potential_dwarf = drinker
		if(HAS_TRAIT(potential_dwarf, TRAIT_DWARF))
			to_chat(potential_dwarf, span_notice("这才叫爷们！"))
			boozepwr = 50 // will still smash but not as much.
			dorf_mode = TRUE

/datum/reagent/consumable/ethanol/manly_dorf/on_mob_life(mob/living/carbon/dwarf, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(dorf_mode)
		var/need_mob_update
		need_mob_update = dwarf.adjust_brute_loss(-2 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
		need_mob_update += dwarf.adjust_fire_loss(-2 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
		if(need_mob_update)
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/longislandicedtea
	name = "长岛冰茶"
	description = "整个酒柜的精华，混合成美味的饮品。仅供中年酗酒女性享用。"
	color = "#ff6633" // rgb: 255,102,51
	boozepwr = 50
	quality = DRINK_VERYGOOD
	taste_description = "a mixture of cola and alcohol"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/moonshine
	name = "月光酒"
	description = "你现在真的跌到谷底了……你的肝脏昨晚已经收拾行李离开了。"
	color = "#AAAAAA77" // rgb: 170, 170, 170, 77 (alpha) (like water)
	boozepwr = 95
	taste_description = "bitterness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/b52
	name = "B-52"
	description = "咖啡、爱尔兰奶油和白兰地。你会被炸翻的。"
	color = "#8f1733" // rgb: 143,23,51
	boozepwr = 85
	quality = DRINK_GOOD
	taste_description = "angry and irish"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_EASY

/datum/reagent/consumable/ethanol/b52/on_mob_metabolize(mob/living/drinker)
	. = ..()
	playsound(drinker, 'sound/effects/explosion/explosion_distant.ogg', 100, FALSE)

/datum/reagent/consumable/ethanol/irishcoffee
	name = "爱尔兰咖啡"
	description = "咖啡和酒精。比早晨喝含羞草更有趣。"
	color = "#874010" // rgb: 135,64,16
	boozepwr = 30
	quality = DRINK_NICE
	taste_description = "giving up on the day"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	metabolized_traits = list(TRAIT_STIMULATED)

/datum/reagent/consumable/ethanol/margarita
	name = "玛格丽塔"
	description = "加冰，杯沿撒盐。干杯~！"
	color = "#8CFF8C" // rgb: 140, 255, 140
	boozepwr = 35
	quality = DRINK_NICE
	taste_description = "dry and salty"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/ethanol/black_russian
	name = "黑俄罗斯"
	description = "为乳糖不耐受者准备。依然像白俄罗斯人一样优雅。"
	color = "#360000" // rgb: 54, 0, 0
	boozepwr = 60
	quality = DRINK_NICE
	taste_description = "bitterness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/manhattan
	name = "曼哈顿"
	description = "侦探卧底时的首选饮品。他从来都受不了杜松子酒……"
	color = "#ff3300" // rgb: 255,51,0
	boozepwr = 50
	quality = DRINK_NICE
	taste_description = "mild dryness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_EASY

/datum/reagent/consumable/ethanol/manhattan_proj
	name = "曼哈顿计划"
	description = "科学家们的最爱，用于思考如何炸掉空间站。"
	color = COLOR_MOSTLY_PURE_RED
	boozepwr = 60
	quality = DRINK_VERYGOOD
	taste_description = "death, the destroyer of worlds"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/manhattan_proj/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	drinker.set_drugginess(1 MINUTES * metabolization_ratio * seconds_per_tick)

/datum/reagent/consumable/ethanol/whiskeysoda
	name = "Whiskey Soda-苏打威士忌"
	description = "献给更优雅的狮鹫。"
	color = "#ffcc33" // rgb: 255,204,51
	boozepwr = 40
	quality = DRINK_NICE
	taste_description = "soda"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/antifreeze
	name = "防冻液"
	description = "终极提神饮品。并非字面意思。"
	color = "#30f0f8" // rgb: 48,240,248
	boozepwr = 35
	quality = DRINK_NICE
	taste_description = "Jack Frost's piss"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/antifreeze/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	drinker.adjust_bodytemperature(20 * metabolization_ratio * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, 0, drinker.get_body_temp_normal() + 20) //310.15 is the normal bodytemp.

/datum/reagent/consumable/ethanol/barefoot
	name = "赤足"
	description = "赤脚与怀孕。"
	color = "#fc5acc" // rgb: 252,90,204
	boozepwr = 30
	quality = DRINK_VERYGOOD
	taste_description = "creamy berries"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/barefoot/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(ishuman(drinker)) //Barefoot causes the imbiber to quickly regenerate brute trauma if they're not wearing shoes.
		var/mob/living/carbon/human/unshoed = drinker
		if(!unshoed.shoes)
			if(unshoed.adjust_brute_loss(-3 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype))
				return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/snowwhite
	name = "白雪公主"
	description = "冰爽的提神饮品。"
	color = COLOR_WHITE // rgb: 255, 255, 255
	boozepwr = 20
	quality = DRINK_NICE
	taste_description = "refreshing cold"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/demonsblood
	name = "Demon's Blood-恶魔之血"
	description = "啊啊啊啊!!!!"
	color = "#820000" // rgb: 130, 0, 0
	boozepwr = 75
	quality = DRINK_VERYGOOD
	taste_description = "sweet tasting iron"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	metabolized_traits = list(TRAIT_STIMULATED)

/datum/reagent/consumable/ethanol/demonsblood/on_mob_metabolize(mob/living/metabolizer)
	. = ..()
	RegisterSignal(metabolizer, COMSIG_LIVING_BLOOD_CRAWL_PRE_CONSUMED, PROC_REF(pre_bloodcrawl_consumed))

/datum/reagent/consumable/ethanol/demonsblood/on_mob_end_metabolize(mob/living/metabolizer)
	. = ..()
	UnregisterSignal(metabolizer, COMSIG_LIVING_BLOOD_CRAWL_PRE_CONSUMED)

/// Prevents the imbiber from being dragged into a pool of blood by a slaughter demon.
/datum/reagent/consumable/ethanol/demonsblood/proc/pre_bloodcrawl_consumed(
	mob/living/source,
	datum/action/cooldown/spell/jaunt/bloodcrawl/crawl,
	mob/living/jaunter,
	obj/effect/decal/cleanable/blood,
)

	SIGNAL_HANDLER

	var/turf/jaunt_turf = get_turf(jaunter)
	jaunt_turf.visible_message(
		span_warning("有什么东西阻止了[source]进入[blood]！"),
		blind_message = span_notice("你听到一阵水花声和重物落地声。")
	)
	to_chat(jaunter, span_warning("一股奇怪的力量阻止了[source]进入！"))

	return COMPONENT_STOP_CONSUMPTION

/datum/reagent/consumable/ethanol/devilskiss
	name = "Devil's Kiss-恶魔之吻"
	description = "惊悚时刻！"
	color = "#A68310" // rgb: 166, 131, 16
	boozepwr = 70
	quality = DRINK_VERYGOOD
	taste_description = "bitter iron"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/devilskiss/on_mob_metabolize(mob/living/metabolizer)
	. = ..()
	RegisterSignal(metabolizer, COMSIG_LIVING_BLOOD_CRAWL_CONSUMED, PROC_REF(on_bloodcrawl_consumed))

/datum/reagent/consumable/ethanol/devilskiss/on_mob_end_metabolize(mob/living/metabolizer)
	. = ..()
	UnregisterSignal(metabolizer, COMSIG_LIVING_BLOOD_CRAWL_CONSUMED)

/// If eaten by a slaughter demon, the demon will regret it.
/datum/reagent/consumable/ethanol/devilskiss/proc/on_bloodcrawl_consumed(
	mob/living/source,
	datum/action/cooldown/spell/jaunt/bloodcrawl/crawl,
	mob/living/jaunter,
)

	SIGNAL_HANDLER

	. = COMPONENT_STOP_CONSUMPTION

	to_chat(jaunter, span_boldwarning("啊！他们的血肉！它在燃烧！"))
	jaunter.apply_damage(25, BRUTE, wound_bonus = CANT_WOUND)

	for(var/obj/effect/decal/cleanable/nearby_blood in range(1, get_turf(source)))
		if(!nearby_blood.can_bloodcrawl_in())
			continue
		source.forceMove(get_turf(nearby_blood))
		source.visible_message(span_warning("[nearby_blood]猛烈地将[source]排挤出来！"))
		crawl.exit_blood_effect(source)
		return

	// Fuck it, just eject them, thanks to some split second cleaning
	source.forceMove(get_turf(source))
	source.visible_message(span_warning("[source]凭空出现，浑身是血！"))
	crawl.exit_blood_effect(source)

/datum/reagent/consumable/ethanol/vodkatonic
	name = "伏特加汤力"
	description = "当金汤力还不够俄罗斯的时候。"
	color = "#0064C8" // rgb: 0, 100, 200
	boozepwr = 40
	quality = DRINK_NICE
	taste_description = "tart bitterness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/ginfizz
	name = "金菲士"
	description = "清爽的柠檬味，美妙地干爽。"
	color = "#ffffcc" // rgb: 255,255,204
	boozepwr = 25
	quality = DRINK_GOOD
	taste_description = "dry, tart lemons"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/bahama_mama
	name = "巴哈马妈妈"
	description = "一款风味层次复杂的热带鸡尾酒。"
	color = "#FF7F3B" // rgb: 255, 127, 59
	boozepwr = 35
	quality = DRINK_GOOD
	taste_description = "pineapple, coconut, and a hint of coffee"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/singulo
	name = "奇点"
	description = "一杯蓝空间饮品！"
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 35
	quality = DRINK_VERYGOOD
	taste_description = "concentrated matter"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	metabolized_traits = list(TRAIT_MADNESS_IMMUNE)
	var/static/list/ray_filter = list(type = "rays", size = 40, density = 15, color = SUPERMATTER_SINGULARITY_RAYS_COLOUR, factor = 15)

/datum/reagent/consumable/ethanol/singulo/on_mob_end_metabolize(mob/living/drinker)
	. = ..()
	drinker.remove_filter("singulo_rays")

/datum/reagent/consumable/ethanol/singulo/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(SPT_PROB(2.5, seconds_per_tick))
		// 20u = 1x1, 45u = 2x2, 80u = 3x3
		var/volume_to_radius = FLOOR(sqrt(volume/5), 1) - 1
		var/suck_range = clamp(volume_to_radius, 0, 3)

		if(!suck_range)
			return ..()

		var/turf/gravity_well_turf = get_turf(drinker)
		goonchem_vortex(gravity_well_turf, 0, suck_range)
		playsound(get_turf(drinker), 'sound/effects/supermatter.ogg', 150, TRUE)
		drinker.add_filter("singulo_rays", 1, ray_filter)
		animate(drinker.get_filter("singulo_rays"), offset = 10, time = 1.5 SECONDS, loop = -1)
		addtimer(CALLBACK(drinker, TYPE_PROC_REF(/datum, remove_filter), "singulo_rays"), 1.5 SECONDS)
		drinker.emote("burp")

/datum/reagent/consumable/ethanol/sbiten
	name = "斯比特恩"
	description = "辛辣的伏特加！对小个子来说可能有点太烈了！"
	color = "#d8d5ae" // rgb: 216,213,174
	boozepwr = 70
	quality = DRINK_GOOD
	taste_description = "hot and spice"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/sbiten/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	drinker.adjust_bodytemperature(50 * metabolization_ratio * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, 0, BODYTEMP_HEAT_DAMAGE_LIMIT) //310.15 is the normal bodytemp.

/datum/reagent/consumable/ethanol/red_mead
	name = "红蜜酒"
	description = "真正的维京饮品！尽管它有着奇怪的红色。"
	color = "#C73C00" // rgb: 199, 60, 0
	boozepwr = 31 //Red drinks are stronger
	quality = DRINK_GOOD
	taste_description = "sweet and salty alcohol"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/mead
	name = "蜜酒"
	description = "一种维京饮品，尽管是便宜货。"
	color = "#e0c058" // rgb: 224,192,88
	nutriment_factor = 1
	boozepwr = 30
	quality = DRINK_NICE
	taste_description = "sweet, sweet alcohol"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/iced_beer
	name = "冰镇啤酒"
	description = "一种冰到周围空气都会冻结的啤酒。"
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 15
	taste_description = "refreshingly cold"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/iced_beer/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	drinker.adjust_bodytemperature(-20 * metabolization_ratio * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick, T0C) //310.15 is the normal bodytemp.

/datum/reagent/consumable/ethanol/grog
	name = "格罗格酒"
	description = "掺了水的朗姆酒，纳米传讯认可！"
	color = "#e0e058" // rgb: 224,224,88
	boozepwr = 1 //Basically nothing
	taste_description = "a poor excuse for alcohol"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/aloe
	name = "芦荟"
	description = "非常、非常、非常棒。"
	color = "#f8f800" // rgb: 248,248,0
	boozepwr = 30
	quality = DRINK_VERYGOOD
	taste_description = "sweet 'n creamy"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	//somewhat annoying mix
	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/ethanol/andalusia
	name = "安达卢西亚"
	description = "一种不错但名字奇怪的饮品。"
	color = "#c8f860" // rgb: 200,248,96
	boozepwr = 45
	quality = DRINK_GOOD
	taste_description = "lemons"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/alliescocktail
	name = "盟军鸡尾酒"
	description = "用你的盟友调制的饮品。不如用敌人调制的那么甜。"
	color = "#60f8f8" // rgb: 96,248,248
	boozepwr = 50
	quality = DRINK_NICE
	taste_description = "bitter yet free"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_EASY

/datum/reagent/consumable/ethanol/acid_spit
	name = "酸液喷吐"
	description = "Nanotrasen出品的饮料。由活体外星人制成。"
	color = "#365000" // rgb: 54, 80, 0
	boozepwr = 70
	quality = DRINK_VERYGOOD
	taste_description = "stomach acid"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/amasec
	name = "阿玛塞克"
	description = "纳米传讯枪械俱乐部的官方饮品！"
	color = "#e0e058" // rgb: 224,224,88
	boozepwr = 45
	quality = DRINK_GOOD
	taste_description = "dark and metallic"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/changelingsting
	name = "变形者之刺"
	description = "你抿了一小口，感到一阵灼烧感……"
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 50
	quality = DRINK_GOOD
	taste_description = "your brain coming out your nose"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/changelingsting/on_mob_life(mob/living/carbon/target, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/datum/antagonist/changeling/changeling = IS_CHANGELING(target)
	changeling?.adjust_chemicals(metabolization_rate * metabolization_ratio * seconds_per_tick)

/datum/reagent/consumable/ethanol/irishcarbomb
	name = "爱尔兰汽车炸弹"
	description = "嗯，尝起来像自由的爱尔兰。"
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 25
	quality = DRINK_GOOD
	taste_description = "the spirit of Ireland"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/syndicatebomb
	name = "辛迪加炸弹"
	description = "尝起来像恐怖主义！"
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 90
	quality = DRINK_GOOD
	taste_description = "purified antagonism"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/syndicatebomb/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(SPT_PROB(2.5, seconds_per_tick))
		playsound(get_turf(drinker), 'sound/effects/explosion/explosionfar.ogg', 100, TRUE)

/datum/reagent/consumable/ethanol/hiveminderaser
	name = "蜂群思维清除剂"
	description = "纯粹风味的容器。"
	color = "#FF80FC" // rgb: 255, 128, 252
	boozepwr = 40
	quality = DRINK_GOOD
	taste_description = "psychic links"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/erikasurprise
	name = "艾丽卡惊喜"
	description = "惊喜在于，它是绿色的！"
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 35
	quality = DRINK_VERYGOOD
	taste_description = "tartness and bananas"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/driestmartini
	name = "最干马提尼"
	description = "仅供老手品尝。你觉得你看到沙子在杯子里漂浮。"
	nutriment_factor = 1
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 65
	quality = DRINK_GOOD
	taste_description = "a beach"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/bananahonk
	name = "香蕉鸣叫"
	description = "来自小丑天堂的饮品。"
	nutriment_factor = 1
	color = "#FFFF91" // rgb: 255, 255, 140
	boozepwr = 60
	quality = DRINK_GOOD
	taste_description = "a bad joke"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/bananahonk/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/obj/item/organ/liver/liver = drinker.get_organ_slot(ORGAN_SLOT_LIVER)
	if((liver && HAS_TRAIT(liver, TRAIT_COMEDY_METABOLISM)) || is_simian(drinker))
		var/heal = 1 * metabolization_ratio * seconds_per_tick
		if(drinker.heal_bodypart_damage(brute = heal, burn = heal, updating_health = FALSE))
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/silencer
	name = "消音器"
	description = "来自默剧演员天堂的饮品。"
	nutriment_factor = 2
	color = "#a8a8a8" // rgb: 168,168,168
	boozepwr = 59 //Proof that clowns are better than mimes right here
	quality = DRINK_GOOD
	taste_description = "a pencil eraser"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/silencer/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(ishuman(drinker) && HAS_MIND_TRAIT(drinker, TRAIT_MIMING))
		drinker.set_silence_if_lower(MIMEDRINK_SILENCE_DURATION)
		var/heal = 1 * metabolization_ratio * seconds_per_tick
		if(drinker.heal_bodypart_damage(brute = heal, burn = heal, updating_health = FALSE))
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/drunkenblumpkin
	name = "醉南瓜"
	description = "威士忌和蓝瓜汁的奇怪混合物。"
	color = "#1EA0FF" // rgb: 30,160,255
	boozepwr = 30
	quality = DRINK_VERYGOOD
	taste_description = "molasses and a mouthful of pool water"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/whiskey_sour //Requested since we had whiskey cola and soda but not sour.
	name = "威士忌酸酒"
	description = "柠檬汁/威士忌/糖的混合物。酒精含量适中。"
	color = rgb(255, 201, 49)
	boozepwr = 35
	quality = DRINK_GOOD
	taste_description = "sour lemons"

/datum/reagent/consumable/ethanol/hcider
	name = "烈性苹果酒"
	description = "给成年人的苹果汁。"
	color = "#CD6839"
	nutriment_factor = 1
	boozepwr = 25
	taste_description = "the season that <i>falls</i> between summer and winter"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_STOCK

/datum/reagent/consumable/ethanol/fetching_fizz //A reference to one of my favorite games of all time. Pulls nearby ores to the imbiber!
	name = "取物嘶嘶"
	description = "威士忌酸酒/铁/铀的混合物，形成一种高磁性浆液。酒精含量较低。" //Requires no alcohol to make but has alcohol anyway because ~magic~
	color = rgb(255, 91, 15)
	boozepwr = 10
	quality = DRINK_VERYGOOD
	metabolization_rate = 0.1 * REAGENTS_METABOLISM
	taste_description = "charged metal" // the same as teslium, honk honk.
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/fetching_fizz/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/turf/drinker_turf = get_turf(drinker)
	for(var/obj/item/stack/ore/ore in orange(3, drinker))
		step_towards(ore, drinker_turf)

//Another reference. Heals those in critical condition extremely quickly.
/datum/reagent/consumable/ethanol/hearty_punch
	name = "暖心潘趣酒"
	description = "勇敢公牛/辛迪加炸弹/苦艾酒的混合物，形成一种提神饮料。酒精含量较低。"
	color = rgb(140, 0, 0)
	boozepwr = 90
	quality = DRINK_VERYGOOD
	metabolization_rate = 0.4 * REAGENTS_METABOLISM
	taste_description = "bravado in the face of disaster"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/hearty_punch/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(drinker.health <= 0)
		var/need_mob_update
		need_mob_update = drinker.adjust_brute_loss(-3.75 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
		need_mob_update += drinker.adjust_fire_loss(-3.75 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
		need_mob_update += drinker.adjust_oxy_loss(-5 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
		need_mob_update += drinker.adjust_tox_loss(-3.75 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)
		if(need_mob_update)
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/bacchus_blessing //An EXTREMELY powerful drink. Smashed in seconds, dead in minutes.
	name = "巴克斯的祝福"
	description = "无法识别的混合物。酒精含量高到无法测量。"
	color = rgb(51, 19, 3) //Sickly brown
	boozepwr = 300 //I warned you
	taste_description = "a wall of bricks"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/atomicbomb
	name = "原子弹"
	description = "核扩散从未如此美味。"
	color = "#666300" // rgb: 102, 99, 0
	boozepwr = 0 //custom drunk effect
	quality = DRINK_FANTASTIC
	taste_description = "da bomb"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_HIGH

/datum/reagent/consumable/ethanol/atomicbomb/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	drinker.set_drugginess(100 SECONDS * metabolization_ratio * seconds_per_tick)
	if(!HAS_TRAIT(drinker, TRAIT_ALCOHOL_TOLERANCE))
		drinker.adjust_confusion(2 SECONDS * metabolization_ratio * seconds_per_tick)
	drinker.set_dizzy_if_lower(20 SECONDS * metabolization_ratio * seconds_per_tick)
	drinker.adjust_slurring(6 SECONDS * metabolization_ratio * seconds_per_tick)
	switch(current_cycle)
		if(52 to 201)
			drinker.Sleeping(100 * metabolization_ratio * seconds_per_tick)
		if(202 to INFINITY)
			drinker.AdjustSleeping(4 SECONDS * metabolization_ratio * seconds_per_tick)
			if(drinker.adjust_tox_loss(2 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
				return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/gargle_blaster
	name = "泛银河系含漱爆破液"
	description = "哇哦，这东西看起来很不稳定！"
	color = "#9cc8b4" // rgb: 156,200,180
	boozepwr = 0 //custom drunk effect
	quality = DRINK_GOOD
	taste_description = "your brains smashed out by a lemon wrapped around a gold brick"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/gargle_blaster/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	drinker.adjust_dizzy(3 SECONDS * metabolization_ratio * seconds_per_tick)
	switch(current_cycle)
		if(16 to 46)
			drinker.adjust_slurring(3 SECONDS * metabolization_ratio * seconds_per_tick)
		if(46 to 56)
			if(SPT_PROB(30, seconds_per_tick))
				drinker.adjust_confusion(3 SECONDS * metabolization_ratio)
		if(56 to 201)
			drinker.set_drugginess(110 SECONDS * metabolization_ratio * seconds_per_tick)
		if(201 to INFINITY)
			if(drinker.adjust_tox_loss(2 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
				return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/neurotoxin
	name = "神经毒素"
	description = "一种强效神经毒素，能使患者进入类死亡状态。"
	color = "#2E2E61" // rgb: 46, 46, 97
	boozepwr = 50
	quality = DRINK_VERYGOOD
	taste_description = "a numbing sensation"
	metabolization_rate = REAGENTS_METABOLISM
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/neurotoxin/proc/pick_paralyzed_limb()
	return (pick(TRAIT_PARALYSIS_L_ARM,TRAIT_PARALYSIS_R_ARM,TRAIT_PARALYSIS_R_LEG,TRAIT_PARALYSIS_L_LEG))

/datum/reagent/consumable/ethanol/neurotoxin/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	drinker.set_drugginess(50 SECONDS * metabolization_ratio * seconds_per_tick)
	drinker.adjust_dizzy(2 SECONDS * metabolization_ratio * seconds_per_tick)
	var/need_mob_update
	need_mob_update = drinker.adjust_organ_loss(ORGAN_SLOT_BRAIN, 0.5 * metabolization_ratio * seconds_per_tick, 150, required_organ_flag = affected_organ_flags)
	if(SPT_PROB(10, seconds_per_tick))
		need_mob_update += drinker.adjust_stamina_loss(5 * metabolization_ratio, updating_stamina = FALSE, required_biotype = affected_biotype)
		drinker.drop_all_held_items()
		to_chat(drinker, span_notice("你感觉不到自己的手了！"))
	if(current_cycle > 6)
		if(SPT_PROB(10, seconds_per_tick))
			var/paralyzed_limb = pick_paralyzed_limb()
			ADD_TRAIT(drinker, paralyzed_limb, type)
			need_mob_update += drinker.adjust_stamina_loss(5 * metabolization_ratio, updating_stamina = FALSE, required_biotype = affected_biotype)
		if(current_cycle > 31)
			need_mob_update += drinker.adjust_organ_loss(ORGAN_SLOT_BRAIN, 1 * metabolization_ratio * seconds_per_tick, required_organ_flag = affected_organ_flags)
			if(current_cycle > 51 && SPT_PROB(7.5, seconds_per_tick))
				if(!drinker.undergoing_cardiac_arrest() && drinker.can_heartattack())
					drinker.set_heartattack(TRUE)
					if(drinker.stat == CONSCIOUS)
						drinker.visible_message(span_userdanger("[drinker] 紧抓着 [drinker.p_their()] 胸口，仿佛 [drinker.p_their()] 心脏停止了跳动！"))
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/neurotoxin/on_mob_end_metabolize(mob/living/carbon/drinker)
	. = ..()
	REMOVE_TRAIT(drinker, TRAIT_PARALYSIS_L_ARM, type)
	REMOVE_TRAIT(drinker, TRAIT_PARALYSIS_R_ARM, type)
	REMOVE_TRAIT(drinker, TRAIT_PARALYSIS_R_LEG, type)
	REMOVE_TRAIT(drinker, TRAIT_PARALYSIS_L_LEG, type)
	drinker.adjust_stamina_loss(10, required_biotype = affected_biotype)

/datum/reagent/consumable/ethanol/hippies_delight
	name = "嬉皮士的喜悦"
	description = "你根本不懂，老兄~~~。"
	color = "#b16e8b" // rgb: 177,110,139
	nutriment_factor = 0
	boozepwr = 0 //custom drunk effect
	quality = DRINK_FANTASTIC
	metabolization_rate = 0.2 * REAGENTS_METABOLISM
	taste_description = "giving peace a chance"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/hippies_delight/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	drinker.set_slurring_if_lower(2.5 SECONDS * metabolization_ratio * seconds_per_tick)

	switch(current_cycle)
		if(2 to 6)
			drinker.set_dizzy_if_lower(50 SECONDS * metabolization_ratio * seconds_per_tick)
			drinker.set_drugginess(150 SECONDS * metabolization_ratio * seconds_per_tick)
			if(SPT_PROB(5, seconds_per_tick))
				drinker.emote(pick("twitch","giggle"))
		if(6 to 11)
			drinker.set_jitter_if_lower(100 SECONDS * metabolization_ratio * seconds_per_tick)
			drinker.set_dizzy_if_lower(100 SECONDS * metabolization_ratio * seconds_per_tick)
			drinker.set_drugginess(225 SECONDS * metabolization_ratio * seconds_per_tick)
			if(SPT_PROB(10, seconds_per_tick))
				drinker.emote(pick("twitch","giggle"))
		if (11 to 201)
			drinker.set_jitter_if_lower(200 SECONDS * metabolization_ratio * seconds_per_tick)
			drinker.set_dizzy_if_lower(200 SECONDS * metabolization_ratio * seconds_per_tick)
			drinker.set_drugginess(5 MINUTES * metabolization_ratio * seconds_per_tick)
			if(SPT_PROB(16, seconds_per_tick))
				drinker.emote(pick("twitch","giggle"))
		if(201 to INFINITY)
			drinker.set_jitter_if_lower(300 SECONDS * metabolization_ratio * seconds_per_tick)
			drinker.set_dizzy_if_lower(300 SECONDS * metabolization_ratio * seconds_per_tick)
			drinker.set_drugginess(6.25 MINUTES * metabolization_ratio * seconds_per_tick)
			if(SPT_PROB(23, seconds_per_tick))
				drinker.emote(pick("twitch","giggle"))
			if(SPT_PROB(16, seconds_per_tick))
				if(drinker.adjust_tox_loss(5 * metabolization_ratio, updating_health = FALSE, required_biotype = affected_biotype))
					return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/eggnog
	name = "蛋奶酒"
	description = "用于享受一年中最美妙的时光。"
	color = "#ffe2ad" // rgb: 255, 226, 173
	nutriment_factor = 2
	boozepwr = 1
	quality = DRINK_VERYGOOD
	taste_description = "custard and alcohol"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/dreadnog
	name = "恐惧蛋奶酒"
	description = "用于在欢乐的时节里受苦。"
	color = "#f7ffad" // rgb: 247, 255, 173
	nutriment_factor = 3 * REAGENTS_METABOLISM
	boozepwr = 1
	quality = DRINK_REVOLTING
	taste_description = "custard and alcohol"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/narsour
	name = "纳尔酸酒"
	description = "一款受THE ARM啤酒厂启发的新热门鸡尾酒，让你很快就会喊出“Fuu ma'jin”！"
	color = RUNE_COLOR_DARKRED
	boozepwr = 10
	quality = DRINK_FANTASTIC
	taste_description = "bloody"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/narsour/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	drinker.adjust_timed_status_effect(6 SECONDS * metabolization_ratio * seconds_per_tick, /datum/status_effect/speech/slurring/cult, max_duration = 6 SECONDS)
	drinker.adjust_stutter_up_to(6 SECONDS * metabolization_ratio * seconds_per_tick, 6 SECONDS)

/datum/reagent/consumable/ethanol/triple_sec
	name = "三重干橙酒"
	description = "一种甜美而充满活力的橙味利口酒。"
	color = COLOR_ICECREAM_PEACH
	boozepwr = 30
	taste_description = "a warm flowery orange taste which recalls the ocean air and summer wind of the caribbean"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/creme_de_menthe
	name = "薄荷甜酒"
	description = "一种薄荷利口酒，非常适合制作清爽、凉爽的饮品。"
	color = "#467446" //rgb: 70, 116, 70
	boozepwr = 20
	taste_description = "a minty, cool, and invigorating splash of cold streamwater"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/creme_de_cacao
	name = "可可甜酒"
	description = "一种巧克力利口酒，非常适合为饮料增添甜点风味，以及贿赂女生联谊会。"
	color = "#350900" // rgb: 53, 9, 0
	boozepwr = 20
	taste_description = "a slick and aromatic hint of chocolates swirling in a bite of alcohol"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/creme_de_coconut
	name = "椰子甜酒"
	description = "一种椰子利口酒，用于制作顺滑、奶油般的热带饮品。"
	color = "#F7F0D0"
	boozepwr = 20
	taste_description = "a sweet milky flavor with notes of toasted sugar"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/quadruple_sec
	name = "四重干橙酒"
	description = "劲头就像舔电击棒的能量电池一样猛，但味道更好。"
	color = "#cc0000"
	boozepwr = 35
	quality = DRINK_GOOD
	taste_description = "an invigorating bitter freshness which suffuses your being; no enemy of the station will go unrobusted this day"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/quadruple_sec/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	//Securidrink in line with the Screwdriver for engineers or Nothing for mimes
	var/obj/item/organ/liver/liver = drinker.get_organ_slot(ORGAN_SLOT_LIVER)
	if(liver && HAS_TRAIT(liver, TRAIT_LAW_ENFORCEMENT_METABOLISM))
		var/heal = 1 * metabolization_ratio * seconds_per_tick
		if(drinker.heal_bodypart_damage(brute = heal, burn = heal, updating_health = FALSE))
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/quintuple_sec
	name = "五重橙酒"
	description = "法律、秩序、酒精和警察暴力被蒸馏成一种单一的正义灵药。"
	color = "#ff3300"
	boozepwr = 55
	quality = DRINK_FANTASTIC
	taste_description = "THE LAW"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/quintuple_sec/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	//Securidrink in line with the Screwdriver for engineers or Nothing for mimes but STRONG..
	var/obj/item/organ/liver/liver = drinker.get_organ_slot(ORGAN_SLOT_LIVER)
	if(liver && HAS_TRAIT(liver, TRAIT_LAW_ENFORCEMENT_METABOLISM))
		var/need_mob_update
		need_mob_update = drinker.heal_bodypart_damage(2 * metabolization_ratio * seconds_per_tick, 1 * metabolization_ratio *  seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
		need_mob_update += drinker.adjust_stamina_loss(-5 * metabolization_ratio * seconds_per_tick, updating_stamina = FALSE, required_biotype = affected_biotype)
		if(need_mob_update)
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/grasshopper
	name = "蚱蜢"
	description = "一款清新甜美的餐后短饮。喝这个很难显得有男子气概。"
	color = "#00ff00"
	boozepwr = 15
	quality = DRINK_GOOD
	taste_description = "chocolate and mint dancing around your mouth"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/stinger
	name = "毒刺"
	description = "结束一天时光的爽快方式。"
	color = "#ccff99"
	boozepwr = 55
	quality = DRINK_NICE
	taste_description = "a slap on the face in the best possible way"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/bastion_bourbon
	name = "堡垒波本"
	description = "具有恢复功效、舒缓身心的热草本饮品。带有一丝柑橘和浆果风味。"
	color = COLOR_CYAN
	boozepwr = 30
	quality = DRINK_FANTASTIC
	taste_description = "hot herbal brew with a hint of fruit"
	metabolization_rate = 2 * REAGENTS_METABOLISM //0.4u per second
	ph = 4
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_HIGH

/datum/reagent/consumable/ethanol/bastion_bourbon/on_mob_metabolize(mob/living/drinker)
	. = ..()
	var/heal_points = 10
	if(drinker.health <= 0)
		heal_points = 20 //heal more if we're in softcrit
	var/need_mob_update
	var/heal_amt = min(volume, heal_points) //only heals 1 point of damage per unit on add, for balance reasons
	need_mob_update = drinker.adjust_brute_loss(-heal_amt, updating_health = FALSE, required_bodytype = affected_bodytype)
	need_mob_update += drinker.adjust_fire_loss(-heal_amt, updating_health = FALSE, required_bodytype = affected_bodytype)
	need_mob_update += drinker.adjust_tox_loss(-heal_amt, updating_health = FALSE, required_biotype = affected_biotype)
	need_mob_update += drinker.adjust_oxy_loss(-heal_amt, updating_health = FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
	// heal stamina loss on first metabolization, but only to a max of 20
	need_mob_update += drinker.adjust_stamina_loss(max(-heal_amt * 5, -20), updating_stamina = FALSE, required_biotype = affected_biotype)
	if(need_mob_update)
		drinker.updatehealth()
	drinker.visible_message(span_warning("[drinker] 因重获活力而颤抖！"), span_notice("一口 [LOWER_TEXT(name)] 让你充满能量！"))
	if(!drinker.stat && heal_points == 20) //brought us out of softcrit
		drinker.visible_message(span_danger("[drinker] 踉跄着站[drinker.p_their()]起来！"), span_boldnotice("起来干活了，小子。"))

/datum/reagent/consumable/ethanol/bastion_bourbon/on_mob_life(mob/living/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(drinker.health > 0)
		var/need_mob_update
		need_mob_update = drinker.adjust_brute_loss(-0.25 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
		need_mob_update += drinker.adjust_fire_loss(-0.25 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
		need_mob_update += drinker.adjust_tox_loss(-0.125 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)
		need_mob_update += drinker.adjust_oxy_loss(-0.75 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
		need_mob_update += drinker.adjust_stamina_loss(-1.25 * metabolization_ratio * seconds_per_tick, updating_stamina = FALSE, required_biotype = affected_biotype)
		if(need_mob_update)
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/squirt_cider
	name = "喷射苹果酒"
	description = "发酵的喷射提取物，带有陈面包和海水的味道。管它喷射是什么东西。"
	color = COLOR_RED
	boozepwr = 40
	taste_description = "stale bread with a staler aftertaste"
	nutriment_factor = 2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/squirt_cider/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	drinker.satiety += 5 * metabolization_ratio * seconds_per_tick //for context, vitamins give 15 satiety per second

/datum/reagent/consumable/ethanol/fringe_weaver
	name = "边缘编织者"
	description = "气泡丰富、格调高雅、无疑强劲——故障城的经典之作。"
	color = "#FFEAC4"
	boozepwr = 90 //classy hooch, essentially, but lower pwr to make up for slightly easier access
	quality = DRINK_GOOD
	taste_description = "ethylic alcohol with a hint of sugar"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/sugar_rush
	name = "糖分冲击"
	description = "甜美、清淡、果味十足——要多女孩子气有多女孩子气。"
	color = "#FF226C"
	boozepwr = 10
	quality = DRINK_GOOD
	taste_description = "your arteries clogging with sugar"
	nutriment_factor = 2
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/sugar_rush/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	drinker.satiety -= 10 * metabolization_ratio * seconds_per_tick //junky as hell! a whole glass will keep you from being able to eat junk food

/datum/reagent/consumable/ethanol/crevice_spike
	name = "裂隙尖刺"
	description = "酸涩、苦口、醒酒效果惊人。"
	color = "#5BD231"
	boozepwr = -10 //sobers you up - ideally, one would drink to get hit with brute damage now to avoid alcohol problems later
	quality = DRINK_VERYGOOD
	taste_description = "a bitter SPIKE with a sour aftertaste"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/crevice_spike/on_mob_metabolize(mob/living/drinker) //damage only applies when drink first enters system and won't again until drink metabolizes out
	. = ..()
	drinker.adjust_brute_loss(3 * min(5,volume), required_bodytype = affected_bodytype) //minimum 3 brute damage on ingestion to limit non-drink means of injury - a full 5 unit gulp of the drink trucks you for the full 15

/datum/reagent/consumable/ethanol/sake
	name = "Sake-清酒"
	description = "一种甜米酒，合法性存疑且酒劲极强。"
	color = "#DDDDDD"
	boozepwr = 70
	taste_description = "sweet rice wine"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_STOCK

/datum/reagent/consumable/ethanol/peppermint_patty
	name = "薄荷帕蒂"
	description = "这款低度酒精饮料结合了薄荷醇和可可的益处。"
	color = "#45ca7a"
	taste_description = "mint and chocolate"
	boozepwr = 25
	quality = DRINK_GOOD
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/peppermint_patty/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	drinker.apply_status_effect(/datum/status_effect/throat_soothed)
	drinker.adjust_bodytemperature(5 * TEMPERATURE_DAMAGE_COEFFICIENT * metabolization_ratio * seconds_per_tick, 0, drinker.get_body_temp_normal())

/datum/reagent/consumable/ethanol/alexander
	name = "亚历山大"
	description = "以一位希腊英雄命名，据说这种调酒能增强使用者的防护，仿佛身处方阵之中。"
	color = "#F5E9D3"
	boozepwr = 50
	quality = DRINK_GOOD
	taste_description = "bitter, creamy cacao"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	var/datum/weakref/mighty_shield

/datum/reagent/consumable/ethanol/alexander/on_mob_metabolize(mob/living/drinker)
	. = ..()
	if(ishuman(drinker))
		var/mob/living/carbon/human/the_human = drinker
		for(var/obj/item/shield/the_shield in the_human.contents)
			mighty_shield = WEAKREF(the_shield)
			the_shield.block_chance += 10
			to_chat(the_human, span_notice("[the_shield] 看起来被擦亮了，虽然你不记得擦过它。"))
			break

/datum/reagent/consumable/ethanol/alexander/on_mob_life(mob/living/drinker, seconds_per_tick, metabolization_ratio)
	var/obj/item/shield/the_shield = mighty_shield?.resolve()
	if(the_shield && !(the_shield in drinker.contents)) //If you had a shield and lose it, you lose the reagent as well. Otherwise this is just a normal drink.
		holder.remove_reagent(type, volume)
		return
	return ..()

/datum/reagent/consumable/ethanol/alexander/on_mob_end_metabolize(mob/living/drinker)
	. = ..()
	var/obj/item/shield/the_shield = mighty_shield?.resolve()
	if(the_shield)
		the_shield.block_chance -= 10
		to_chat(drinker,span_notice("你注意到 [the_shield] 看起来又变旧了。真奇怪。"))
		mighty_shield = null

/datum/reagent/consumable/ethanol/amaretto_alexander
	name = "杏仁亚历山大"
	description = "亚历山大的弱化版，虽力道不足，却以风味弥补。"
	color = "#DBD5AE"
	boozepwr = 35
	quality = DRINK_VERYGOOD
	taste_description = "sweet, creamy cacao"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/sidecar
	name = "边车"
	description = "一杯让你心甘情愿交出方向盘的美酒。"
	color = "#FFC55B"
	boozepwr = 45
	quality = DRINK_GOOD
	taste_description = "delicious freedom"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/ethanol/between_the_sheets
	name = "床笫之间"
	description = "一款名字挑逗的经典鸡尾酒。有趣的是，医生建议在床单下小憩前饮用它。"
	color = "#F4C35A"
	boozepwr = 55
	quality = DRINK_GOOD
	taste_description = "seduction"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/ethanol/between_the_sheets/on_mob_life(mob/living/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/is_between_the_sheets = FALSE
	for(var/obj/item/bedsheet/bedsheet in range(drinker.loc, 0))
		if(bedsheet.loc != drinker.loc) // bedsheets in your backpack/neck don't count
			continue
		is_between_the_sheets = TRUE
		break

	if(!drinker.IsSleeping() || !is_between_the_sheets)
		return

	var/need_mob_update
	if(drinker.get_brute_loss() && drinker.get_fire_loss()) //If you are damaged by both types, slightly increased healing but it only heals one. The more the merrier wink wink.
		if(prob(50))
			need_mob_update = drinker.adjust_brute_loss(-0.25 * metabolization_ratio * seconds_per_tick, updating_health = FALSE,  required_bodytype = affected_bodytype)
		else
			need_mob_update = drinker.adjust_fire_loss(-0.25 * metabolization_ratio * seconds_per_tick, updating_health = FALSE,  required_bodytype = affected_bodytype)
	else if(drinker.get_brute_loss()) //If you have only one, it still heals but not as well.
		need_mob_update = drinker.adjust_brute_loss(-0.2 * metabolization_ratio * seconds_per_tick, updating_health = FALSE,  required_bodytype = affected_bodytype)
	else if(drinker.get_fire_loss())
		need_mob_update = drinker.adjust_fire_loss(-0.2 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype)
	if(need_mob_update)
		return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/kamikaze
	name = "神风特攻"
	description = "神圣之风。"
	color = "#EEF191"
	boozepwr = 35
	quality = DRINK_GOOD
	taste_description = "divine windiness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/mojito
	name = "莫吉托"
	description = "一款看起来和尝起来一样清爽的饮品。"
	color = "#DFFAD9"
	boozepwr = 20
	quality = DRINK_GOOD
	taste_description = "refreshing mint"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/ethanol/moscow_mule
	name = "莫斯科骡子"
	description = "一杯让你想起废弃站的冰凉饮品。"
	color = "#EEF1AA"
	boozepwr = 30
	quality = DRINK_GOOD
	taste_description = "refreshing spiciness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/fernet
	name = "菲奈特"
	description = "一种极其苦涩的草本利口酒，用作餐后消化酒。"
	color = "#1B2E24" // rgb: 27, 46, 36
	boozepwr = 80
	taste_description = "utter bitterness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/fernet/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(drinker.nutrition <= NUTRITION_LEVEL_STARVING)
		if(drinker.adjust_tox_loss(1 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
			. = UPDATE_MOB_HEALTH
	drinker.adjust_nutrition(-5 * metabolization_ratio * seconds_per_tick)
	drinker.overeatduration = 0

/datum/reagent/consumable/ethanol/fernet_cola
	name = "菲奈特可乐"
	description = "一种非常受欢迎且苦甜参半的餐后消化酒，适合在饱餐后饮用。按照传统，最好装在锯断的可乐瓶里享用。"
	color = "#390600" // rgb: 57, 6,
	boozepwr = 25
	quality = DRINK_NICE
	taste_description = "sweet relief"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/fernet_cola/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(drinker.nutrition <= NUTRITION_LEVEL_STARVING)
		if(drinker.adjust_tox_loss(0.5 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
			. = UPDATE_MOB_HEALTH
	drinker.adjust_nutrition(-3 * metabolization_ratio * seconds_per_tick)
	drinker.overeatduration = 0

/datum/reagent/consumable/ethanol/fanciulli
	name = "范丘利"
	description = "如果曼哈顿鸡尾酒真的用了苦味草本利口酒会怎样？它能帮你醒酒。" //also causes a bit of stamina damage to symbolize the afterdrink lazyness
	color = "#CA933F" // rgb: 202, 147, 63
	boozepwr = -10
	quality = DRINK_NICE
	taste_description = "a sweet sobering mix"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_HIGH

/datum/reagent/consumable/ethanol/fanciulli/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	drinker.adjust_nutrition(-5 * metabolization_ratio * seconds_per_tick)
	drinker.overeatduration = 0

/datum/reagent/consumable/ethanol/fanciulli/on_mob_metabolize(mob/living/drinker)
	. = ..()
	if(drinker.health > 0)
		drinker.adjust_stamina_loss(20, required_biotype = affected_biotype)

/datum/reagent/consumable/ethanol/branca_menta
	name = "布兰卡薄荷"
	description = "苦味菲奈特与薄荷奶油利口酒的清爽混合。"
	color = "#4B5746" // rgb: 75, 87, 70
	boozepwr = 35
	quality = DRINK_GOOD
	taste_description = "a bitter freshness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/ethanol/branca_menta/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	drinker.adjust_bodytemperature(-20 * TEMPERATURE_DAMAGE_COEFFICIENT * metabolization_ratio * seconds_per_tick, T0C)

/datum/reagent/consumable/ethanol/branca_menta/on_mob_metabolize(mob/living/drinker)
	. = ..()
	if(drinker.health > 0)
		drinker.adjust_stamina_loss(35, required_biotype = affected_biotype)

/datum/reagent/consumable/ethanol/blank_paper
	name = "Blank Paper-白纸"
	description = "一杯冒着气泡的空白纸。光是看着它就让你感到清新。"
	nutriment_factor = 1
	color = "#DCDCDC" // rgb: 220, 220, 220
	boozepwr = 20
	quality = DRINK_GOOD
	taste_description = "bubbling possibility"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/blank_paper/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(ishuman(drinker) && HAS_MIND_TRAIT(drinker, TRAIT_MIMING))
		drinker.set_silence_if_lower(MIMEDRINK_SILENCE_DURATION)
		var/heal = 1 * metabolization_ratio * seconds_per_tick
		if(drinker.heal_bodypart_damage(brute = heal, burn = heal, updating_health = FALSE))
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/fruit_wine
	name = "Fruit Wine-果酒"
	description = "一种用种植的植物酿造的葡萄酒。"
	color = COLOR_WHITE
	boozepwr = 35
	quality = DRINK_GOOD
	taste_description = "bad coding"
	ph = 4
	var/list/names = list("null fruit" = 1) //Names of the fruits used. Associative list where name is key, value is the percentage of that fruit.
	var/list/tastes = list("bad coding" = 1) //List of tastes. See above.

/datum/reagent/consumable/ethanol/fruit_wine/on_new(list/data)
	if(!data)
		return

	src.data = data
	names = data["names"]
	tastes = data["tastes"]
	boozepwr = data["boozepwr"]
	color = data["color"]
	generate_data_info(data)

/datum/reagent/consumable/ethanol/fruit_wine/on_merge(list/mix_data, amount)
	. = ..()
	var/diff = (amount/volume)
	if(diff < 1)
		color = BlendRGB(color, mix_data["color"], diff/2) //The percentage difference over two, so that they take average if equal.
	else
		color = BlendRGB(color, mix_data["color"], (1/diff)/2) //Adjust so it's always blending properly.
	var/oldvolume = volume-amount

	var/list/cachednames = mix_data["names"]
	for(var/name in names | cachednames)
		names[name] = ((names[name] * oldvolume) + (cachednames[name] * amount)) / volume

	var/list/cachedtastes = mix_data["tastes"]
	for(var/taste in tastes | cachedtastes)
		tastes[taste] = ((tastes[taste] * oldvolume) + (cachedtastes[taste] * amount)) / volume

	boozepwr *= oldvolume
	var/newzepwr = mix_data["boozepwr"] * amount
	boozepwr += newzepwr
	boozepwr /= volume //Blending boozepwr to volume.
	generate_data_info(data)

/datum/reagent/consumable/ethanol/fruit_wine/proc/generate_data_info(list/data)
	// BYOND's compiler fails to catch non-consts in a ranged switch case, and it causes incorrect behavior. So this needs to explicitly be a constant.
	var/const/minimum_percent = 0.15 //Percentages measured between 0 and 1.
	var/list/primary_tastes = list()
	var/list/secondary_tastes = list()
	for(var/taste in tastes)
		switch(tastes[taste])
			if(minimum_percent*2 to INFINITY)
				primary_tastes += taste
			if(minimum_percent to minimum_percent*2)
				secondary_tastes += taste

	var/minimum_name_percent = 0.35
	name = ""
	var/list/names_in_order = sortTim(names, GLOBAL_PROC_REF(cmp_numeric_dsc), TRUE)
	var/named = FALSE
	for(var/fruit_name in names)
		if(names[fruit_name] >= minimum_name_percent)
			name += "[fruit_name] "
			named = TRUE
	if(named)
		name += "Wine"
	else
		name = "混合的[names_in_order[1]]葡萄酒"

	var/alcohol_description
	switch(boozepwr)
		if(120 to INFINITY)
			alcohol_description = "suicidally strong"
		if(90 to 120)
			alcohol_description = "rather strong"
		if(70 to 90)
			alcohol_description = "strong"
		if(40 to 70)
			alcohol_description = "rich"
		if(20 to 40)
			alcohol_description = "mild"
		if(0 to 20)
			alcohol_description = "sweet"
		else
			alcohol_description = "watery" //How the hell did you get negative boozepwr?

	var/list/fruits = list()
	if(names_in_order.len <= 3)
		fruits = names_in_order
	else
		for(var/i in 1 to 3)
			fruits += names_in_order[i]
		fruits += "other plants"
	var/fruit_list = english_list(fruits)
	description = "一种由[alcohol_description]酿造的[fruit_list]葡萄酒。"

	var/flavor = ""
	if(!primary_tastes.len)
		primary_tastes = list("[alcohol_description] alcohol")
	flavor += english_list(primary_tastes)
	if(secondary_tastes.len)
		flavor += ", with a hint of "
		flavor += english_list(secondary_tastes)
	taste_description = flavor

/datum/reagent/consumable/ethanol/champagne //How the hell did we not have champagne already!?
	name = "香槟"
	description = "一种以其快速猛烈效果而闻名的起泡酒。"
	color = "#ffffc1"
	boozepwr = 40
	taste_description = "auspicious occasions and bad decisions"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_EASY

/datum/reagent/consumable/ethanol/wizz_fizz
	name = "巫师嘶嘶"
	description = "一种神奇的药水，嘶嘶作响，狂野不羁！然而你会发现，它的味道相当温和。"
	color = "#4235d0" //Just pretend that the triple-sec was blue curacao.
	boozepwr = 50
	quality = DRINK_GOOD
	taste_description = "friendship! It is magic, after all"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/wizz_fizz/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	//A healing drink similar to Quadruple Sec, Ling Stings, and Screwdrivers for the Wizznerds; the check is consistent with the changeling sting
	if(drinker?.mind?.has_antag_datum(/datum/antagonist/wizard))
		var/need_mob_update
		need_mob_update = drinker.heal_bodypart_damage(1 * metabolization_ratio * seconds_per_tick, 1 * metabolization_ratio * seconds_per_tick, updating_health = FALSE)
		need_mob_update += drinker.adjust_oxy_loss(-1 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype, required_respiration_type = affected_respiration_type)
		need_mob_update += drinker.adjust_tox_loss(-1 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype)
		need_mob_update += drinker.adjust_stamina_loss(-5 * metabolization_ratio * seconds_per_tick, updating_stamina = FALSE, required_biotype = affected_biotype)
		if(need_mob_update)
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/bug_spray
	name = "杀虫喷雾"
	description = "一种辛辣、刺鼻、苦涩的饮品，适合那些需要提神的人。"
	color = "#33ff33"
	boozepwr = 45
	quality = DRINK_GOOD
	taste_description = "the pain of ten thousand slain mosquitos"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	affected_biotype = MOB_BUG

/datum/reagent/consumable/ethanol/bug_spray/on_new(data)
	. = ..()
	AddElement(/datum/element/bugkiller_reagent)

/datum/reagent/consumable/ethanol/bug_spray/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	// Does some damage to bug biotypes
	if(drinker.adjust_tox_loss(1 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_biotype = affected_biotype))
		. = UPDATE_MOB_HEALTH
		// Random chance of causing a screm if we did some damage
		if(SPT_PROB(2, seconds_per_tick))
			drinker.emote("scream")

/datum/reagent/consumable/ethanol/applejack
	name = "苹果杰克"
	description = "当你感觉需要胡闹一番时的完美饮品。"
	color = "#ff6633"
	boozepwr = 20
	taste_description = "an honest day's work at the orchard"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/jack_rose
	name = "杰克玫瑰"
	description = "一种清淡的鸡尾酒，非常适合配着一片派细细品味。"
	color = "#ff6633"
	boozepwr = 15
	quality = DRINK_NICE
	taste_description = "a sweet and sour slice of apple"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/turbo
	name = "涡轮"
	description = "一种与非法悬浮摩托赛车相关的狂野鸡尾酒。不适合胆小的人。"
	color = "#e94c3a"
	boozepwr = 85
	quality = DRINK_VERYGOOD
	taste_description = "the outlaw spirit"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/turbo/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(SPT_PROB(2, seconds_per_tick))
		to_chat(drinker, span_notice("[pick("You feel disregard for the rule of law.", "You feel pumped!", "Your head is pounding.", "Your thoughts are racing..")]"))
	if(drinker.adjust_stamina_loss(-0.5 * drinker.get_drunk_amount() * metabolization_ratio * seconds_per_tick, updating_stamina = FALSE, required_biotype = affected_biotype))
		return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/old_timer
	name = "老古董"
	description = "一种古老的饮品，深受各个年龄段的守旧派喜爱。"
	color = "#996835"
	boozepwr = 35
	quality = DRINK_NICE
	taste_description = "simpler times"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/old_timer/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(SPT_PROB(10, seconds_per_tick) && ishuman(drinker))
		var/mob/living/carbon/human/metabolizer = drinker
		metabolizer.age += 1
		if(metabolizer.age > 70)
			metabolizer.set_facial_haircolor("#cccccc", update = FALSE)
			metabolizer.set_haircolor("#cccccc", update = TRUE)
			if(metabolizer.age > 100)
				metabolizer.become_nearsighted(type)
				if(metabolizer.gender == MALE)
					metabolizer.set_facial_hairstyle("Beard (Very Long)", update = TRUE)

				if(metabolizer.age > 969) //Best not let people get older than this or i might incur G-ds wrath
					metabolizer.visible_message(span_notice("[metabolizer] 变得比任何人应有的年纪都要老……然后化为了尘埃！"))
					metabolizer.dust(just_ash = FALSE, drop_items = TRUE, force = FALSE)

/datum/reagent/consumable/ethanol/rubberneck
	name = "橡胶脖子"
	description = "一款优质的橡胶颈酒不应含有任何恶心的天然成分。"
	color = "#ffe65b"
	boozepwr = 60
	quality = DRINK_GOOD
	taste_description = "artificial fruitiness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	metabolized_traits = list(TRAIT_SHOCKIMMUNE)

/datum/reagent/consumable/ethanol/duplex
	name = "双工"
	description = "两种果味饮品不可分割的组合。"
	color = "#50e5cf"
	boozepwr = 25
	quality = DRINK_NICE
	taste_description = "green apples and blue raspberries"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/trappist
	name = "特拉普啤酒"
	description = "一种由太空僧侣酿造的烈性黑啤酒。"
	color = "#390c00"
	boozepwr = 40
	quality = DRINK_VERYGOOD
	taste_description = "dried plums and malt"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/trappist/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(drinker.mind?.holy_role)
		if(drinker.adjust_fire_loss(-2.5 * metabolization_ratio * seconds_per_tick, updating_health = FALSE, required_bodytype = affected_bodytype))
			. = UPDATE_MOB_HEALTH
		drinker.adjust_jitter(-2 SECONDS * metabolization_ratio * seconds_per_tick)
		drinker.adjust_stutter(-2 SECONDS * metabolization_ratio * seconds_per_tick)

/datum/reagent/consumable/ethanol/blazaam
	name = "布拉扎姆"
	description = "一种奇怪的饮品，似乎没几个人记得它存在过。同时也可作为贝伦斯坦移除剂。"
	boozepwr = 70
	quality = DRINK_FANTASTIC
	taste_description = "alternate realities"
	var/stored_teleports = 0

/datum/reagent/consumable/ethanol/blazaam/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(drinker.get_drunk_amount() > 40)
		if(stored_teleports)
			do_teleport(drinker, get_turf(drinker), rand(1,3), channel = TELEPORT_CHANNEL_WORMHOLE)
			stored_teleports--

		if(SPT_PROB(5, seconds_per_tick))
			stored_teleports += rand(2, 6)
			if(prob(70))
				drinker.vomit(vomit_flags = VOMIT_CATEGORY_DEFAULT, vomit_type = /obj/effect/decal/cleanable/vomit/purple)

/datum/reagent/consumable/ethanol/planet_cracker
	name = "行星破碎者"
	description = "这款欢庆的饮品纪念人类战胜外星威胁的胜利。可能冒犯非人类船员。"
	boozepwr = 50
	quality = DRINK_FANTASTIC
	taste_description = "triumph with a hint of bitterness"

/datum/reagent/consumable/ethanol/mauna_loa
	name = "Mauna Loa-长山"
	description = "极其辛辣；不适合胆小的人！"
	boozepwr = 40
	color = "#fe8308" // 254, 131, 8
	quality = DRINK_FANTASTIC
	taste_description = "fiery, with an aftertaste of burnt flesh"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/mauna_loa/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	// Heats the user up while the reagent is in the body. Occasionally makes you burst into flames.
	drinker.adjust_bodytemperature(25 * metabolization_ratio * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick)
	if (SPT_PROB(2.5, seconds_per_tick))
		drinker.adjust_fire_stacks(1 * metabolization_ratio)
		drinker.ignite_mob()

/datum/reagent/consumable/ethanol/painkiller
	name = "止痛剂"
	description = "能缓解你的痛苦。当然，指的是情感上的痛苦。"
	boozepwr = 20
	color = "#EAD677"
	quality = DRINK_NICE
	taste_description = "sugary tartness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	metabolized_traits = list(TRAIT_ANALGESIA)

/datum/reagent/consumable/ethanol/pina_colada
	name = "椰林飘香"
	description = "一款新鲜的菠萝饮品，加入了椰子朗姆酒。美味。"
	boozepwr = 40
	color = "#FFF1B2"
	quality = DRINK_FANTASTIC
	taste_description = "pineapple, coconut, and a hint of the ocean"

/datum/reagent/consumable/ethanol/pina_olivada
	name = "橄榄椰林飘香"
	description = "一种由橄榄油和菠萝汁混合而成的奇怪调制品。"
	boozepwr = 20 // the oil coats your gastrointestinal tract, meaning you can't absorb as much alcohol. horrifying
	color = "#493c00"
	quality = DRINK_NICE
	taste_description = "a horrible emulsion of pineapple and olive oil"

/datum/reagent/consumable/ethanol/pina_olivada/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(SPT_PROB(8, seconds_per_tick))
		drinker.manual_emote(pick("coughs up some oil", "swallows the lump in [drinker.p_their()] throat", "gags", "chokes up a bit"))
	if(SPT_PROB(3, seconds_per_tick))
		var/static/list/messages = list(
			"A horrible aftertaste coats your mouth.",
			"You feel like you're going to choke on the oil in your throat.",
			"You start to feel some heartburn coming on.",
			"You want to throw up, but you know that nothing can come out due to the clog in your esophagus.",
			"Your throat feels horrible.",
		)
		to_chat(drinker, span_notice(pick(messages)))

/datum/reagent/consumable/ethanol/pruno // pruno mix is in drink_reagents
	name = "Pruno-监狱酒"
	color = "#E78108"
	description = "用水果、糖和绝望发酵而成的监狱私酿酒。安保部门最爱没收这个，这也是安保部门唯一做过的善事。"
	boozepwr = 85
	taste_description = "your tastebuds being individually shanked"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/pruno/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	drinker.adjust_disgust(5 * metabolization_ratio * seconds_per_tick)

/datum/reagent/consumable/ethanol/ginger_amaretto
	name = "姜味杏仁酒"
	description = "一款令人愉悦的简单鸡尾酒，取悦感官。"
	boozepwr = 30
	color = "#EFB42A"
	quality = DRINK_GOOD
	taste_description = "sweetness followed by a soft sourness and warmth"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/godfather
	name = "教父"
	description = "一款粗犷且与非法勾当有联系的鸡尾酒。"
	boozepwr = 50
	color = "#E68F00"
	quality = DRINK_GOOD
	taste_description = "a delightful softened punch"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/ethanol/godmother
	name = "教母"
	description = "经典鸡尾酒的变体，更受成熟女性喜爱。"
	boozepwr = 50
	color = "#E68F00"
	quality = DRINK_GOOD
	taste_description = "sweetness and a zesty twist"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/kortara
	name = "Kortara-科塔拉"
	description = "一种在提兹拉受欢迎的、以坚果为基底、香甜奶味的饮品。常与果汁和可可混合以增添清爽感。"
	boozepwr = 25
	color = "#EEC39A"
	quality = DRINK_GOOD
	taste_description = "sweet nectar"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/kortara/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(drinker.get_brute_loss() && SPT_PROB(10, seconds_per_tick))
		if(drinker.heal_bodypart_damage(brute = 1 * metabolization_ratio, burn = 0, updating_health = FALSE))
			return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/sea_breeze
	name = "海风"
	description = "清淡爽口，带有薄荷和可可的冲击感——就像可以喝的薄荷巧克力碎冰淇淋！"
	boozepwr = 15
	color = "#CFFFE5"
	quality = DRINK_VERYGOOD
	taste_description = "mint choc chip"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/sea_breeze/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	drinker.apply_status_effect(/datum/status_effect/throat_soothed)

/datum/reagent/consumable/ethanol/white_tiziran
	name = "白提兹兰"
	description = "伏特加与科尔塔拉的混合。蜥蜴人畅饮之选。"
	boozepwr = 50
	color = "#A68340"
	quality = DRINK_GOOD
	taste_description = "strikes and gutters"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/drunken_espatier
	name = "醉醺醺的太空陆战队员"
	description = "听着，如果你不得不在冰冷真空的太空里卷入一场枪战，你也会想喝醉的。"
	boozepwr = 65
	color = "#A68340"
	quality = DRINK_GOOD
	taste_description = "sorrow"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/drunken_espatier/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	drinker.add_mood_event("numb", /datum/mood_event/narcotic_medium, name) //comfortably numb

/datum/reagent/consumable/ethanol/drunken_espatier/on_mob_metabolize(mob/living/drinker)
	. = ..()
	drinker.apply_status_effect(/datum/status_effect/grouped/screwy_hud/fake_healthy, type)

/datum/reagent/consumable/ethanol/drunken_espatier/on_mob_end_metabolize(mob/living/drinker)
	. = ..()
	drinker.remove_status_effect(/datum/status_effect/grouped/screwy_hud/fake_healthy, type)

/datum/reagent/consumable/ethanol/protein_blend
	name = "蛋白质混合液"
	description = "一种由蛋白质、纯谷物酒精、科塔面粉和血液混合而成的恶心饮品。如果你能忍住不吐出来，对增肌很有用。"
	boozepwr = 65
	color = "#FF5B69"
	quality = DRINK_NICE
	taste_description = "regret"
	nutriment_factor = 3
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/protein_blend/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. =	..()
	drinker.adjust_nutrition(2 * metabolization_ratio * seconds_per_tick)
	if(!islizard(drinker))
		drinker.adjust_disgust(5 * metabolization_ratio * seconds_per_tick)
	else
		drinker.adjust_disgust(2 * metabolization_ratio * seconds_per_tick)

/datum/reagent/consumable/ethanol/mushi_kombucha
	name = "Mushi Kombucha-虫康普茶"
	description = "提兹拉上流行的夏季饮品，由甜味蘑菇茶制成。"
	boozepwr = 10
	color = "#C46400"
	quality = DRINK_VERYGOOD
	taste_description = "sweet 'shrooms"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/triumphal_arch
	name = "凯旋门"
	description = "一种庆祝蜥蜴帝国及其军事胜利的饮品。在统一日的酒吧里很受欢迎。"
	boozepwr = 60
	color = COLOR_GOLD
	quality = DRINK_FANTASTIC
	taste_description = "victory"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/triumphal_arch/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(islizard(drinker))
		drinker.add_mood_event("triumph", /datum/mood_event/memories_of_home, name)

/datum/reagent/consumable/ethanol/the_juice
	name = "果汁"
	description = "哇，老兄，这感觉，对你来说好像有点熟悉啊，伙计。"
	color = "#4c14be"
	boozepwr = 50
	quality = DRINK_GOOD
	taste_description = "like, the future, man"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	var/datum/brain_trauma/special/bluespace_prophet/prophet_trauma

/datum/reagent/consumable/ethanol/the_juice/on_mob_metabolize(mob/living/carbon/drinker)
	. = ..()
	prophet_trauma = new()
	drinker.gain_trauma(prophet_trauma, TRAUMA_RESILIENCE_ABSOLUTE)

/datum/reagent/consumable/ethanol/the_juice/on_mob_end_metabolize(mob/living/carbon/drinker)
	. = ..()
	if(prophet_trauma)
		QDEL_NULL(prophet_trauma)

//a jacked up absinthe that causes hallucinations to the game master controller basically, used in smuggling objectives
/datum/reagent/consumable/ethanol/ritual_wine
	name = "Ritual Wine-祭酒"
	description = "仪式用酒中危险、浓烈、含酒精的成分。"
	color = rgb(35, 231, 25)
	boozepwr = 90 //enjoy near death intoxication
	taste_mult = 6
	taste_description = "concentrated herbs"

/datum/reagent/consumable/ethanol/ritual_wine/on_mob_metabolize(mob/living/psychonaut)
	. = ..()
	if(!psychonaut.hud_used)
		return
	var/atom/movable/plane_master_controller/game_plane_master_controller = psychonaut.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]
	game_plane_master_controller.add_filter("ritual_wine", 1, list("type" = "wave", "size" = 1, "x" = 5, "y" = 0, "flags" = WAVE_SIDEWAYS))

/datum/reagent/consumable/ethanol/ritual_wine/on_mob_end_metabolize(mob/living/psychonaut)
	. = ..()
	if(!psychonaut.hud_used)
		return
	var/atom/movable/plane_master_controller/game_plane_master_controller = psychonaut.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]
	game_plane_master_controller.remove_filter("ritual_wine")

//Moth Drinks
/datum/reagent/consumable/ethanol/curacao
	name = "Curaçao-蓝橙酒"
	description = "用拉哈橙制成，带来芬芳的余味。"
	boozepwr = 30
	color = "#1a5fa1"
	quality = DRINK_NICE
	taste_description = "blue orange"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/navy_rum //IN THE NAVY
	name = "Navy Rum-海军朗姆酒"
	description = "最优秀水手饮用的朗姆酒。"
	boozepwr = 90 //the finest sailors are often drunk
	color = "#d8e8f0"
	quality = DRINK_NICE
	taste_description = "a life on the waves"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/bitters //why do they call them bitters, anyway? they're more spicy than anything else
	name = "Andromeda Bitters-苦涩仙女座"
	description = "调酒师最好的朋友，常用来为任何饮品增添一丝精致的辛辣味。产自新特立尼达，现在如此，永远如此。"
	boozepwr = 70
	color = "#1c0000"
	quality = DRINK_NICE
	taste_description = "spiced alcohol"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/admiralty //navy rum, vermouth, fernet
	name = "海军上将"
	description = "一种用海军朗姆酒、苦艾酒和菲奈特制成的精致苦味饮品。"
	boozepwr = 80
	color = "#1F0001"
	quality = DRINK_VERYGOOD
	taste_description = "haughty arrogance"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/long_haul //Rum, Curacao, Sugar, dash of bitters, lengthened with soda water
	name = "长途跋涉"
	description = "深受货运飞行员、无良走私者和沙牛牧人喜爱的饮品。"
	boozepwr = 20
	color = "#003153"
	quality = DRINK_VERYGOOD
	taste_description = "companionship"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/long_john_silver //navy rum, bitters, lemonade
	name = "朗·约翰·西尔弗"
	description = "一种由海军朗姆酒、苦精和柠檬水调制的长饮。在飞蛾舰队上特别受欢迎，因为它消耗的配给点数少，风味却很足。"
	boozepwr = 45
	color = "#c4b35c"
	quality = DRINK_VERYGOOD
	taste_description = "rum and spices"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/tropical_storm //dark rum, pineapple juice, triple citrus, curacao
	name = "热带风暴"
	description = "一杯尽享加勒比风情。"
	boozepwr = 25
	color = "#00bfa3"
	quality = DRINK_VERYGOOD
	taste_description = "the tropics"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/dark_and_stormy //rum and ginger beer- simple and classic
	name = "黑暗与风暴"
	description = "一款经典饮品，伴随着雷鸣般的掌声登场。" //thank you, thank you, I'll be here forever
	boozepwr = 30
	color = "#8c5046"
	quality = DRINK_GOOD
	taste_description = "ginger and rum"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/salt_and_swell //navy rum, tochtause syrup, egg whites, dash of saline-glucose solution
	name = "盐与浪涌"
	description = "一款清爽的酸味饮品，带有有趣的咸味。"
	boozepwr = 60
	color = "#b4abd0"
	quality = DRINK_FANTASTIC
	taste_description = "salt and spice"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/tiltaellen //yoghurt, salt, vinegar
	name = "Tiltällen-酵酸奶"
	description = "一种轻度发酵的酸奶饮料，加了盐和少许醋。带有独特的酸味奶酪风味。"
	boozepwr = 10
	color = "#F4EFE2"
	quality = DRINK_NICE
	taste_description = "sour cheesy yoghurt"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/tich_toch
	name = "提奇托奇"
	description = "由Tiltällen、Töchtaüse糖浆和伏特加混合而成。并非人人都喜欢。"
	boozepwr = 75
	color = "#b4abd0"
	quality = DRINK_VERYGOOD
	taste_description = "spicy sour cheesy yoghurt"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/helianthus
	name = "向日葵"
	description = "苦艾酒与致幻剂的混合物，色泽深沉却光彩夺目。所有真正艺术家的选择。"
	boozepwr = 75
	color = "#fba914"
	quality = DRINK_VERYGOOD
	taste_description = "golden memories"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	var/hal_amt = 4
	var/hal_cap = 24

/datum/reagent/consumable/ethanol/helianthus/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(SPT_PROB(5, seconds_per_tick))
		drinker.adjust_hallucinations_up_to(4 SECONDS * metabolization_ratio, 48 SECONDS)

/datum/reagent/consumable/ethanol/plumwine
	name = "梅子酒"
	description = "李子酿成的酒。"
	color = "#8a0421"
	nutriment_factor = 1
	boozepwr = 20
	taste_description = "a poet's love and undoing"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_STOCK

/datum/reagent/consumable/ethanol/the_hat
	name = "帽子"
	description = "一种精致的饮品，通常盛在男士帽子里供应。"
	color = "#b90a5c"
	boozepwr = 80
	quality = DRINK_NICE
	taste_description = "something perfumy"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_STOCK

/datum/reagent/consumable/ethanol/gin_garden
	name = "金酒花园"
	description = "极佳的清凉酒精饮料，口味非同寻常。"
	boozepwr = 20
	color = "#6cd87a"
	quality = DRINK_VERYGOOD
	taste_description = "light gin with sweet ginger and cucumber"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/ethanol/gin_garden/on_mob_life(mob/living/carbon/doll, seconds_per_tick, metabolization_ratio)
	. = ..()
	doll.adjust_bodytemperature(-5 * TEMPERATURE_DAMAGE_COEFFICIENT * metabolization_ratio * seconds_per_tick, doll.get_body_temp_normal())

/datum/reagent/consumable/ethanol/wine_voltaic
	name = "伏打黄酒"
	description = "带电的葡萄酒。能为以太族充电，且无毒。"
	boozepwr = 30
	color = "#FFAA00"
	taste_description = "static with a hint of sweetness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/wine_voltaic/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume) //can't be on life because of the way blood works.
	. = ..()
	if(!(methods & (INGEST|INJECT|PATCH)) || !iscarbon(exposed_mob))
		return

	var/mob/living/carbon/exposed_carbon = exposed_mob
	var/obj/item/organ/stomach/ethereal/stomach = exposed_carbon.get_organ_slot(ORGAN_SLOT_STOMACH)
	if(istype(stomach))
		stomach.adjust_charge(reac_volume * 10 * ETHEREAL_DISCHARGE_RATE)

/datum/reagent/consumable/ethanol/telepole
	name = "传送杆"
	description = "以饮品形式呈现的接地棒。能为以太族充电，并提供暂时的电击抗性。"
	boozepwr = 50
	color = "#b300ff"
	quality = DRINK_NICE
	taste_description = "the howling storm"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	metabolized_traits = list(TRAIT_SHOCKIMMUNE)

/datum/reagent/consumable/ethanol/telepole/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume) //can't be on life because of the way blood works.
	. = ..()
	if(!(methods & (INGEST|INJECT|PATCH)) || !iscarbon(exposed_mob))
		return

	var/mob/living/carbon/exposed_carbon = exposed_mob
	var/obj/item/organ/stomach/ethereal/stomach = exposed_carbon.get_organ_slot(ORGAN_SLOT_STOMACH)
	if(istype(stomach))
		stomach.adjust_charge(reac_volume * 20 * ETHEREAL_DISCHARGE_RATE)

/datum/reagent/consumable/ethanol/pod_tesla
	name = "豆荚特斯拉"
	description = "驾驭闪电！能为以太族充电，抑制恐惧症，并提供强大的暂时电击抗性。"
	boozepwr = 80
	color = "#00fbff"
	quality = DRINK_FANTASTIC
	taste_description = "victory, with a hint of insanity"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/pod_tesla/on_mob_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob.add_traits(list(TRAIT_SHOCKIMMUNE,TRAIT_TESLA_SHOCKIMMUNE,TRAIT_FEARLESS), type)

/datum/reagent/consumable/ethanol/pod_tesla/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob.remove_traits(list(TRAIT_SHOCKIMMUNE,TRAIT_TESLA_SHOCKIMMUNE,TRAIT_FEARLESS), type)

/datum/reagent/consumable/ethanol/pod_tesla/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume) //can't be on life because of the way blood works.
	. = ..()
	if(!(methods & (INGEST|INJECT|PATCH)) || !iscarbon(exposed_mob))
		return

	var/mob/living/carbon/exposed_carbon = exposed_mob
	var/obj/item/organ/stomach/ethereal/stomach = exposed_carbon.get_organ_slot(ORGAN_SLOT_STOMACH)
	if(istype(stomach))
		stomach.adjust_charge(reac_volume * 30 * ETHEREAL_DISCHARGE_RATE)

// Welcome to the Blue Room Bar and Grill, home to Mars' finest cocktails
/datum/reagent/consumable/ethanol/rice_beer
	name = "米酒"
	description = "一种在火星上流行的清淡、以大米为基础的贮藏啤酒。根据1516年的《纯净法》，这被视为对巴伐利亚人的仇恨犯罪。"
	boozepwr = 5
	color = "#664300"
	quality = DRINK_NICE
	taste_description = "mild carbonated malt"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/shochu
	name = "烧酒"
	description = "也被称为烧酒或白酒，这种饮料由发酵大米制成，很像清酒，但通常酒精度更高，使其更接近真正的烈酒。"
	boozepwr = 45
	color = "#DDDDDD"
	quality = DRINK_NICE
	taste_description = "stiff rice wine"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/yuyake
	name = "夕烧"
	description = "一种来自日本的甜瓜利口酒。在大多数人看来，它是20世纪80年代的遗物，在鸡尾酒调制中有一些小众用途，部分原因在于其鲜红的颜色。"
	boozepwr = 40
	color = "#F54040"
	quality = DRINK_NICE
	taste_description = "sweet melon"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/coconut_rum
	name = "椰林飘香朗姆酒"
	description = "海滩的蒸馏精华。尝起来像漂白的金发和防晒霜。"
	boozepwr = 21
	color = "#e4f2f5"
	quality = DRINK_NICE
	taste_description = "coconut rum"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

// Mixed Martian Drinks
/datum/reagent/consumable/ethanol/yuyakita
	name = "夕烧北"
	description = "一位无名顾客释放到世间的炼狱。"
	boozepwr = 40
	color = "#e43414"
	quality = DRINK_NICE
	taste_description = "death"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/saibasan
	name = "赛博桑"
	description = "一种颂扬赛博太阳公司持久业务的饮品。"
	boozepwr = 20
	color = "#f25100"
	quality = DRINK_FANTASTIC
	taste_description = "betrayal"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/banzai_ti
	name = "万岁提"
	description = "长岛冰茶的变体，使用夕烧酒带来一种难以名状的独特风味。"
	boozepwr = 40
	color = "#fd3b00"
	quality = DRINK_VERYGOOD
	taste_description = "an asian twist on the liquor cabinet"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/sanraizusoda
	name = "三垒苏打"
	description = "这是一种瓜味奶油苏打，只不过加了酒精——有什么不喜欢的呢？嗯……可能是宿醉吧。"
	boozepwr = 6
	color = "#f37d7b"
	quality = DRINK_GOOD
	taste_description = "creamy melon soda"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/kumicho
	name = "组长"
	description = "对经典鸡尾酒的新诠释，组长鸡尾酒采用教父配方并加入烧酒，增添了亚洲风情。"
	boozepwr = 62
	color = "#b87456"
	quality = DRINK_VERYGOOD
	taste_description = "rice and rye"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/red_planet
	name = "红色星球"
	description = "为庆祝火星特许权而创制，红色星球鸡尾酒基于经典的总统鸡尾酒，既充满爱国情怀又呈现亮丽的深红色。"
	boozepwr = 45
	color = "#ac4948"
	quality = DRINK_VERYGOOD
	taste_description = "the spirit of freedom"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/amaterasu
	name = "天照"
	description = "以日本神道教太阳女神天照大神命名，这款鸡尾酒体现了光辉——或者大致是那么回事。"
	boozepwr = 54 //1 part bitters is a lot
	color = "#e43414"
	quality = DRINK_VERYGOOD
	taste_description = "sweet nectar of the gods"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/nekomimosa
	name = "猫耳含羞草"
	description = "一种过于甜腻的鸡尾酒，由瓜味利口酒、瓜汁和香槟（可惜不含瓜）制成。"
	boozepwr = 17
	color = "#FF0C8D"
	quality = DRINK_GOOD
	taste_description = "MELON"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/sentai_quencha //melon soda, triple citrus, shochu, blue curacao
	name = "战队奎恩查"
	description = "基于银河系著名的\"Kyūkyoku no Ninja Pawā Sentai\"，战队解渴饮是动漫展和宅吧的最爱。"
	boozepwr = 28
	color = "#00ffa6"
	quality = DRINK_GOOD
	taste_description = "ultimate ninja power"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/bosozoku
	name = "暴走族"
	description = "一种来自火星的简单夏日饮品，由米酒和柠檬水按1:1混合而成。"
	boozepwr = 6
	color = "#d7d84f"
	quality = DRINK_GOOD
	taste_description = "bittersweet lemon"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/ersatzche
	name = "替代者"
	description = "甜、苦、辣——绝妙的组合。"
	boozepwr = 6
	color = "#bc6a2b"
	quality = DRINK_VERYGOOD
	taste_description = "spicy pineapple beer"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/red_city_am
	name = "红城上午"
	description = "来自新大阪的早餐饮品，适用于当你真的需要在早上9:30喝醉，但又想比在新干线上喝袋装葡萄酒更体面一些的时候。不过你也不应该在新干线上喝这个。"
	boozepwr = 5 //this thing is fucking disgusting and both less tasty and less alcoholic than a bloody mary. it is against god and nature
	color = "#ef0903"
	quality = DRINK_NICE
	taste_description = "breakfast in a glass"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/kings_ransom
	name = "国王的赎金"
	description = "一种烈性、苦涩的饮品，名字古怪，配方更怪。"
	boozepwr = 26
	color = "#bd2e20"
	quality = DRINK_VERYGOOD
	taste_description = "bitter raspberry"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/four_bit
	name = "四比特"
	description = "一种为你的打字双手提供动力的饮品。"
	boozepwr = 26
	color = "#c4b000"
	quality = DRINK_GOOD
	taste_description = "cyberspace"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/white_hawaiian //coconut milk, coconut rum, coffee liqueur
	name = "白色夏威夷"
	description = "对经典白俄罗斯人的一种演绎，用热带风味替换了经典成分。"
	boozepwr = 16
	color = "#ffffeb"
	quality = DRINK_GOOD
	taste_description = "COCONUT"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/maui_sunrise //coconut rum, pineapple juice, yuyake, triple citrus, lemon-lime soda
	name = "毛伊岛日出"
	description = "在这款饮品红色的外表下，隐藏着尖锐而复杂的风味。"
	boozepwr = 15
	color = "#f1922b"
	quality = DRINK_VERYGOOD
	taste_description = "sunrise over the pacific"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/imperial_mai_tai //navy rum, rum, lime, triple sec, korta nectar
	name = "帝国迈泰"
	description = "当杏仁糖浆短缺时，就像太空居民那样——将就凑合，修修补补。"
	boozepwr = 52
	color = "#cf7d61"
	quality = DRINK_VERYGOOD
	taste_description = "spicy nutty rum"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/konococo_rumtini //todo: add espresso | coffee, coffee liqueur, coconut rum, sugar
	name = "科诺可可朗姆提尼"
	description = "椰子朗姆酒、咖啡利口酒和浓缩咖啡——一种奇怪的组合，但无疑是一种受欢迎的搭配。"
	boozepwr = 20
	color = "#421711"
	quality = DRINK_VERYGOOD
	taste_description = "coconut coffee"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	metabolized_traits = list(TRAIT_STIMULATED)

/datum/reagent/consumable/ethanol/blue_hawaiian //pineapple juice, lemon juice, coconut rum, blue curacao
	name = "蓝色夏威夷"
	description = "香甜、尖锐且带有椰子味。"
	boozepwr = 30
	color = "#295875"
	quality = DRINK_VERYGOOD
	taste_description = "the aloha state"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/boston_sour
	name = "波士顿酸酒"
	description = "通过蛋清在口感上提升的威士忌酸酒。"
	boozepwr = 35
	color = "#ddc28b"
	quality = DRINK_VERYGOOD
	taste_description = "foamy lemony sourness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/star
	name = "星辰"
	description = "一种苹果白兰地与苦艾酒的混合酒，点缀着苦精。"
	boozepwr = 40
	color = "#e5a654"
	quality = DRINK_GOOD
	taste_description = "vinous apples"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/old_fashioned
	name = "古典鸡尾酒"
	description = "在某些标准下，这是最早的鸡尾酒，通过用糖和苦精为烈酒调味制成，现代最常用的烈酒通常是威士忌。"
	boozepwr = 60
	color = "#b4a287"
	quality = DRINK_GOOD
	taste_description = "rounded out whiskey"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_EASY

/datum/reagent/consumable/ethanol/sazerac
	name = "萨泽拉克"
	description = "用苦艾酒和克里奥尔苦精增添香气的威士忌。"
	boozepwr = 65
	color = "#f43f69"
	quality = DRINK_GOOD
	taste_description = "flowery anise-scented whiskey"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_EASY

/datum/reagent/consumable/ethanol/amaretto_sour
	name = "杏仁酸酒"
	description = "用甜杏仁酒调制的酸酒。"
	boozepwr = 15
	color = "#ddc28b"
	quality = DRINK_VERYGOOD
	taste_description = "foamy lemony sweetness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/ethanol/ramos_gin_fizz
	name = "拉莫斯金菲士"
	description = "对金菲士概念的复杂演绎，加入了奶油和蛋清以及柠檬汁，带来无与伦比的口感体验。在这个版本中，标志性的橙花水被一滴橙味利口酒所取代。"
	boozepwr = 35
	color = "#f9e7c2"
	quality = DRINK_FANTASTIC
	taste_description = "creamy fluffy citrusy gin"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/french_75
	name = "法兰西75"
	description = "一种精致的鸡尾酒，用金酒强化香槟，然后用柠檬汁和糖调味。"
	boozepwr = 35
	color = "#ffffc1"
	quality = DRINK_GOOD
	taste_description = "glory and gunnery"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/ethanol/sangria
	name = "桑格利亚"
	description = "一种血红色的葡萄酒潘趣酒，用烈酒强化，并用尽可能多的切碎水果增甜。"
	boozepwr = 20
	color = "#c4383b"
	quality = DRINK_GOOD
	taste_description = "refreshing fruity wine"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/suffering_bastard
	name = "受苦的混蛋"
	description = "一种提基风格的解酒饮料，由姜汁啤酒、烈酒和苦精制成。"
	boozepwr = 20
	color = "#e8ca78"
	quality = DRINK_VERYGOOD
	taste_description = "ginger-flavored recuperation"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/suffering_bastard/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.apply_status_effect(/datum/status_effect/headache_soothed) //prevents headaches
	affected_mob.adjust_disgust(-5 * metabolization_ratio * seconds_per_tick) //removes disgust, same with sol dry
	if(affected_mob.adjust_organ_loss(ORGAN_SLOT_BRAIN, -0.5 * metabolization_ratio * seconds_per_tick * normalise_creation_purity(), required_organ_flag = affected_organ_flags)) //heals brain damage very slowly, about 12 damage per 5u
		return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/blue_blazer
	name = "蓝色火焰"
	description = "一位19世纪传奇调酒师的招牌饮品。虽然他因革新调酒艺术而被铭记，但归根结底，这款酒其实就是加热过的加糖威士忌。"
	boozepwr = 25
	color = "#b5949b"
	quality = DRINK_NICE
	taste_description = "scorched sweet whiskey"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/blue_blazer/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_bodytemperature(25 * TEMPERATURE_DAMAGE_COEFFICIENT * metabolization_ratio * seconds_per_tick, 0, affected_mob.get_body_temp_normal())

/datum/reagent/consumable/ethanol/hot_toddy
	name = "热托蒂"
	description = "一种加热混合的烈酒、糖和香料。虽然这个概念很古老，但这种用干邑白兰地和精制糖的调配方式则更为现代一些。"
	boozepwr = 25
	color = "#f2d2b4"
	quality = DRINK_GOOD
	taste_description = "the warmth of a comfy fireplace"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/ethanol/hot_toddy/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_bodytemperature(25 * TEMPERATURE_DAMAGE_COEFFICIENT * metabolization_ratio * seconds_per_tick, 0, affected_mob.get_body_temp_normal())

/datum/reagent/consumable/ethanol/tizirian_sour
	name = "提兹里安酸酒"
	description = "对特立尼达酸酒的改良，用科尔塔花蜜代替杏仁糖浆。尽管名字如此，它却是由一位火星调酒师发明的。"
	boozepwr = 35
	color = "#9b4b3a"
	quality = DRINK_VERYGOOD
	taste_description = "sweetened and spiced bitterness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/daiquiri
	name = "代基里"
	description = "在某种意义上，这是终极的热带鸡尾酒，很少有朗姆酒饮品不是这种经典的后代。"
	boozepwr = 35
	color = "#b6d3a6"
	quality = DRINK_NICE
	taste_description = "crisp lime"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/flip_cocktail
	name = "翻转鸡尾酒"
	description = "这是一种更古老饮品的简化现代改编版，其历史早于鸡尾酒。虽然旧版本使用麦芽酒并在饮用前加热，但这个版本是冰镇的。说真的，主要的相似之处在于使用了一整个鸡蛋。"
	boozepwr = 30
	color = "#dddfca"
	quality = DRINK_GOOD
	taste_description = "creamy brandy and nutmeg"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/flip_cocktail/on_mob_metabolize(mob/living/drinker)
	. = ..()
	if(prob(10))
		drinker.emote("flip")

/datum/reagent/consumable/ethanol/aperitivo
	name = "Aperitivo Liqueur"
	description = "An aggressively bittersweet liqueur flavored with cinchona bark and other botanicals. Perfect for stimulating one's appetite or fighting off malaria."
	boozepwr = 40
	color = "#bf1038"
	taste_description = "intense citrusy bitterness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/aperitivo/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired) //This and some of the cocktails it gets mixed into stimulate the apetite, as an aperitivo should
	. = ..()
	drinker.adjust_nutrition(-1 * REM * seconds_per_tick)
	drinker.overeatduration = 0

/datum/reagent/consumable/ethanol/herbal_liqueur
	name = "Herbal Liqueur"
	description = "A liqueur made with a wide variety of herbs and spices, infused into spirit through both distillation and maceration. So many, in fact, that trying to pick them out by scent and taste seems nearly impossible..."
	boozepwr = 75
	color = "#95be7d"
	quality = DRINK_NICE
	taste_description = "confounding herbaceousness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_EASY

/datum/reagent/consumable/ethanol/maraschino
	name = "Maraschino Liqueur"
	description = "A classic sweet liqueur made from the fruits, leaves, and even branches of sour cherries. Surprisingly, it doesn't actually taste much like cherry."
	boozepwr = 50
	color = "#DDDDDD"
	taste_description = "nutty sweetness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/bartenders_handshake
	name = "Bartender's Handshake"
	description = "A tradition of somewhat inconsistent providence, possibly linked to an obscure challenge-coin-based marketing scheme, this drink is a way for bartenders to greet and test each other's mettle via a drink that only a fellow barkeep could appreciate. While there are nearly as many versions of this drink as there are bars, this version tests one's palate by combining two of the most bitter ingredients you're likely to find in a bar."
	boozepwr = 50
	color = "#270101"
	quality = DRINK_VERYGOOD
	taste_description = "pretentious bitterness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/bartenders_handshake/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired) //Heals bartenders brute and burn, disgusts otherwise
	. = ..()
	var/obj/item/organ/liver/liver = drinker.get_organ_slot(ORGAN_SLOT_LIVER)
	if(HAS_TRAIT(liver, TRAIT_BARTENDER_METABOLISM))
		if(drinker.heal_bodypart_damage(brute = 1 * REM * seconds_per_tick, burn = 1 * REM * seconds_per_tick, updating_health = FALSE))
			. = UPDATE_MOB_HEALTH
	else
		drinker.adjust_disgust(2 * REM * seconds_per_tick)

/datum/reagent/consumable/ethanol/brandy_crusta
	name = "Brandy Crusta"
	description = "The far more gussied-up ancestor of the Sidecar, this heavily garnished cocktail is the grandparent of many essential drinks served today."
	boozepwr = 30
	color = "#f8c51c"
	quality = DRINK_VERYGOOD
	taste_description = "orangy sweetness"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/casino
	name = "Casino"
	description = "A gin-heavy classic. Juniper is tempered by scant amounts of citrus and sweetened with liqueur."
	boozepwr = 45
	color = "#fdee65"
	quality = DRINK_GOOD
	taste_description = "sweet juniper"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/garibaldi //Makes revs resitant to wounds and fearless.
	name = "Garibaldi"
	description = "Named for the 19th-century Italian general, the red-orange color scheme of this drink mimics the shirts of those who followed him into battles all across the world."
	boozepwr = 15
	color = "#f77e2e"
	quality = DRINK_GOOD
	taste_description = "bitter oranges"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_EASY

/datum/reagent/consumable/ethanol/garibaldi/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(IS_REVOLUTIONARY(drinker))
		//status effect has a duration of 5 seconds which gets refreshed by this, falls off on it's own in case of running out of drink or deconversion
		drinker.apply_status_effect(/datum/status_effect/rev_resilience)

/datum/reagent/consumable/ethanol/improved_whiskey
	name = "Improved Whiskey Cocktail"
	description = "The Classic Whiskey cocktail improved by the addition of absinthe and maraschino, as well as swapping the typical orange peel garnish for lemon."
	boozepwr = 65
	color = "#b8a385"
	quality = DRINK_VERYGOOD
	taste_description = "nutty anise-scented whiskey"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_MEDIUM

/datum/reagent/consumable/ethanol/jungle_bird
	name = "Jungle Bird"
	description = "This late-tiki concoction leverages the brilliant combination of bitter liqueur and pineapple juice to make a remarkably well-balanced cocktail."
	boozepwr = 25
	color = "#da8370"
	quality = DRINK_VERYGOOD
	taste_description = "pineapple and quinine"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	metabolized_traits = list(TRAIT_SUPERMATTER_SOOTHER) //If you have this in your system, you calm down the SM by being near it.

/datum/reagent/consumable/ethanol/last_word
	name = "Last Word"
	description = "Despite being invented at the turn of the 20th century, this drink fell into obscurity until the cocktail renaissance of the beginning of the 21st, where it then went on to dominate bars and inspire countless twists upon its formula."
	boozepwr = 50
	color = "#dddfcaff"
	quality = DRINK_VERYGOOD
	taste_description = "herbal finality"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/last_word/expose_mob(mob/living/drinker, methods, reac_volume, show_message, touch_protection)
	. = ..()
	//Mutes people for 5 seconds on their first sip every 5 minutes. Requires ingest, you can't savor something that's injected into your eyes or whatever.
	if(!(methods & INGEST) || !iscarbon(drinker) || HAS_TRAIT(drinker, TRAIT_HAD_LAST_WORD))
		return

	ADD_TRAIT(drinker, TRAIT_HAD_LAST_WORD, type)
	to_chat(drinker, span_notice("You take a moment to silently savor your drink..."))
	drinker.set_silence_if_lower(5 SECONDS)
	addtimer(TRAIT_CALLBACK_REMOVE(drinker, TRAIT_HAD_LAST_WORD, type), 300 SECONDS)

/datum/reagent/consumable/ethanol/mary_pickford
	name = "Mary Pickford"
	description = "Named after an early 20th-century film star, this cocktail takes a rum and pineapple flavor profile and presents it in a classier and more elegant form than one would typically expect."
	boozepwr = 35
	color = "#f7b7a7ff"
	quality = DRINK_GOOD
	taste_description = "elegant pineapple"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/negroni //Aperitif that supresses overeating
	name = "Negroni"
	description = "An iconic Italian aperitif, its simple intensity crowns it as perhaps the ultimate bitter cocktail. Supposedly it was named after an Italian count who wanted a stronger version of a spritz and asked his bartender to replace soda with gin."
	boozepwr = 50
	color = "#cf0e00ff"
	quality = DRINK_GOOD
	taste_description = "bittersweet vermouth"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	glass_price = DRINK_PRICE_EASY

/datum/reagent/consumable/ethanol/negroni/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	drinker.overeatduration -= 20

/datum/reagent/consumable/ethanol/nuclear_daiquiri
	name = "Nuclear daiquiri"
	description = "Overproof, funky, pot still rum and herbal liqueur takes the simple elegance of a Cuban daiquiri and turns it on its head."
	boozepwr = 65
	color = "#22cc22"
	quality = DRINK_GOOD
	taste_description = "hogo and herbs"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/nuclear_daiquiri_thermo
	name = "Thermonuclear Daiquiri"
	description = "A drink for those who enjoy the gnarlier things in life, like high-ester rums and Cobalt 60."
	boozepwr = 80
	color = "#00dd00"
	quality = DRINK_FANTASTIC
	taste_description = "approximately 3.6 roentgen"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/nuclear_daiquiri_thermo/on_mob_add(mob/living/living_mob)
	. = ..()
	living_mob.apply_status_effect(/datum/status_effect/cherenkov_radiation) //makes the drinker glow blue, and rarely emit high-energy nuclear particles.

/datum/reagent/consumable/ethanol/nuclear_daiquiri_thermo/on_mob_delete(mob/living/living_mob)
	. = ..()
	living_mob.remove_status_effect(/datum/status_effect/cherenkov_radiation)

/datum/reagent/consumable/ethanol/nuclear_daiquiri_thermo/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	drinker.set_drugginess(100 SECONDS * metabolization_ratio * seconds_per_tick)
	drinker.set_jitter_if_lower(20 SECONDS * metabolization_ratio * seconds_per_tick)
	drinker.set_dizzy_if_lower(10 SECONDS * metabolization_ratio * seconds_per_tick)

/datum/reagent/consumable/ethanol/poets_dream
	name = "Poet's Dream"
	description = "This cocktail takes a classic martini base and twists it into a deliciously sweet and herbal mode. Nanotrasen regulations state not to drink this too soon before sleep, or risk 'oneiric encroachment,' whatever that means."
	boozepwr = 50
	color = "#d4b14f"
	quality = DRINK_GOOD
	taste_description = "honeyed herbal gin"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS

/datum/reagent/consumable/ethanol/poets_dream/on_mob_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob.apply_status_effect(/datum/status_effect/grouped/heretic_dreams, type)

/datum/reagent/consumable/ethanol/poets_dream/on_mob_end_metabolize(mob/living/affected_mob, metabolization_ratio)
	. = ..()
	affected_mob.remove_status_effect(/datum/status_effect/grouped/heretic_dreams, type)

/datum/reagent/consumable/ethanol/pousse_cafe
	name = "Pousse Cafe"
	description = "An aesthetically beautiful cocktail made from the careful and meticulous layering of various liquors. Extremely annoying to make."
	boozepwr = 50
	color = "#93cf33"
	quality = DRINK_FANTASTIC
	taste_description = "a cascade of varying liqueurs"
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_HIGH

/datum/reagent/consumable/ethanol/spritz //Aperitif that supresses overeating
	name = "Spritz" // If someone wants to add an elderflower spritz or something else like that, just rename this to spritz al bitter or whatever
	description = "This bittersweet and refreshing aperitif brings to mind the beautiful summer sunsets of venice."
	boozepwr = 20
	color = "#ee714b"
	quality = DRINK_GOOD
	taste_description = "bittersweet refreshment"
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	glass_price = DRINK_PRICE_EASY

/datum/reagent/consumable/ethanol/spritz/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, times_fired)
	. = ..()
	drinker.overeatduration -= 20

/datum/reagent/consumable/ethanol/vieux_carre
	name = "Vieux Carré"
	description = "One of the best of many great cocktails to come out of New Orleans, this drink does honor to that city's French Quarter both in name and in taste."
	boozepwr = 60
	color = "#b43110"
	quality = DRINK_VERYGOOD
	taste_description = "Creole hospitality"
	randomized_spawns = REAGENT_SPAWN_ALL_RANDOM_SPAWNS
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

#undef ALCOHOL_EXPONENT
#undef ALCOHOL_THRESHOLD_MODIFIER
