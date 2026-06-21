//copy pasta of the space piano, don't hurt me -Pete
/obj/item/instrument
	name = "通用乐器"
	force = 10
	max_integrity = 100
	resistance_flags = FLAMMABLE
	icon = 'icons/obj/art/musician.dmi'
	lefthand_file = 'icons/mob/inhands/equipment/instruments_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/instruments_righthand.dmi'
	abstract_type = /obj/item/instrument
	/// Our song datum.
	var/datum/song/handheld/song
	/// Our allowed list of instrument ids. This is nulled on initialize.
	var/list/allowed_instrument_ids
	/// How far away our song datum can be heard.
	var/instrument_range = 15

/obj/item/instrument/Initialize(mapload)
	. = ..()
	song = new(src, allowed_instrument_ids, instrument_range)
	allowed_instrument_ids = null //We don't need this clogging memory after its used.

/obj/item/instrument/Destroy()
	QDEL_NULL(song)
	return ..()

/obj/item/instrument/proc/can_play(atom/music_player)
	if(!ismob(music_player))
		return FALSE
	var/mob/user = music_player
	if(user.incapacitated)
		return FALSE
	if(!Adjacent(user))
		return FALSE
	return TRUE

/obj/item/instrument/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] 开始演奏《忧郁的星期天》！看起来[user.p_theyre()]想要自杀！"))
	return BRUTELOSS

/obj/item/instrument/ui_interact(mob/user, datum/tgui/ui)
	return song.ui_interact(user)

/obj/item/instrument/violin
	name = "太空小提琴"
	desc = "一种有四根弦且配有弓的木质乐器。“魔鬼飞到了太空，他正在寻找一位能分担悲伤的伙伴。”"
	icon_state = "violin"
	inhand_icon_state = "violin"
	hitsound = SFX_SWING_HIT
	allowed_instrument_ids = "violin"
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 4, /datum/material/iron = SHEET_MATERIAL_AMOUNT)

/obj/item/instrument/violin/golden
	name = "金色小提琴"
	desc = "一把金色的乐器，有四根弦和一根弓。“魔鬼飞到了太空，他正在寻找一位能分担悲伤的伙伴。”"
	icon_state = "golden_violin"
	inhand_icon_state = "golden_violin"
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	custom_materials = list(/datum/material/gold = SHEET_MATERIAL_AMOUNT * 4, /datum/material/iron = SHEET_MATERIAL_AMOUNT)

/obj/item/instrument/banjo
	name = "班卓琴"
	desc = "A 'Mura' brand banjo. It's pretty much just a drum with a neck and strings."
	icon_state = "banjo"
	inhand_icon_state = "banjo"
	attack_verb_continuous = list("scruggs-styles", "hum-diggitys", "shin-digs", "clawhammers")
	attack_verb_simple = list("scruggs-style", "hum-diggity", "shin-dig", "clawhammer")
	hitsound = 'sound/items/weapons/banjoslap.ogg'
	allowed_instrument_ids = "banjo"

/obj/item/instrument/guitar
	name = "吉他"
	desc = "由木材制成，并配有铜琴弦。"
	icon_state = "guitar"
	inhand_icon_state = "guitar"
	attack_verb_continuous = list("plays metal on", "serenades", "crashes", "smashes")
	attack_verb_simple = list("play metal on", "serenade", "crash", "smash")
	hitsound = 'sound/items/weapons/stringsmash.ogg'
	allowed_instrument_ids = list("guitar","csteelgt","cnylongt", "ccleangt", "cmutedgt")

/obj/item/instrument/eguitar
	name = "电吉他"
	desc = "满足您所有的发癫需求。"
	icon_state = "eguitar"
	inhand_icon_state = "eguitar"
	force = 12
	attack_verb_continuous = list("plays metal on", "shreds", "crashes", "smashes")
	attack_verb_simple = list("play metal on", "shred", "crash", "smash")
	hitsound = 'sound/items/weapons/stringsmash.ogg'
	allowed_instrument_ids = "eguitar"

/obj/item/instrument/glockenspiel
	name = "钟琴"
	desc = "光滑的金属管材，非常适合任何乐队使用。"
	icon_state = "glockenspiel"
	allowed_instrument_ids = list("glockenspiel","crvibr", "sgmmbox", "r3celeste")
	inhand_icon_state = "glockenspiel"

/obj/item/instrument/accordion
	name = "手风琴"
	desc = "punpun不在其中。"
	icon_state = "accordion"
	allowed_instrument_ids = list("crack", "crtango", "accordion")
	inhand_icon_state = "accordion"

/obj/item/instrument/trumpet
	name = "小号"
	desc = "宣告国王驾到！"
	icon_state = "trumpet"
	allowed_instrument_ids = "crtrumpet"
	inhand_icon_state = "trumpet"

/obj/item/instrument/trumpet/spectral
	name = "幽灵小号"
	desc = "事情开始变得诡异了！"
	icon_state = "spectral_trumpet"
	inhand_icon_state = "spectral_trumpet"
	force = 0
	attack_verb_continuous = list("plays", "jazzes", "trumpets", "mourns", "doots", "spooks")
	attack_verb_simple = list("play", "jazz", "trumpet", "mourn", "doot", "spook")
	var/single_use = FALSE

/obj/item/instrument/trumpet/spectral/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/spooky, too_spooky = !single_use, single_use = single_use)

/obj/item/instrument/trumpet/spectral/attack(mob/living/target_mob, mob/living/user, list/modifiers, list/attack_modifiers)
	playsound(src, 'sound/runtime/instruments/trombone/En4.mid', 1000, 1, -1)
	return ..()

/obj/item/instrument/trumpet/spectral/one_doot
	single_use = TRUE

/obj/item/instrument/saxophone
	name = "萨克斯"
	desc = "这种令人感到宽慰的声音肯定会让您的听众潸然泪下。"
	icon_state = "saxophone"
	allowed_instrument_ids = "saxophone"
	inhand_icon_state = "saxophone"

/obj/item/instrument/saxophone/spectral
	name = "幽灵萨克斯"
	desc = "这种诡异的声音肯定会让凡人胆战心惊。"
	icon_state = "saxophone"
	inhand_icon_state = "saxophone"
	force = 0
	attack_verb_continuous = list("plays", "jazzes", "saxxes", "mourns", "doots", "spooks")
	attack_verb_simple = list("play", "jazz", "sax", "mourn", "doot", "spook")
	var/single_use = FALSE

/obj/item/instrument/saxophone/spectral/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/spooky, too_spooky = !single_use, single_use = single_use)

/obj/item/instrument/saxophone/spectral/attack(mob/living/target_mob, mob/living/user, list/modifiers, list/attack_modifiers)
	playsound(src, 'sound/runtime/instruments/trombone/En4.mid', 1000, 1, -1)
	return ..()

/obj/item/instrument/saxophone/spectral/one_doot
	single_use = TRUE

/obj/item/instrument/trombone
	name = "长号"
	desc = "任何一张台球桌怎么可能有资格与之竞争呢？"
	icon_state = "trombone"
	allowed_instrument_ids = list("crtrombone", "crbrass", "trombone")
	inhand_icon_state = "trombone"

/obj/item/instrument/trombone/spectral
	name = "幽灵长号"
	desc = "一副骨架的最爱之物。直接涂抹于凡人身上。"
	icon_state = "trombone"
	inhand_icon_state = "trombone"
	force = 0
	attack_verb_continuous = list("plays", "jazzes", "trombones", "mourns", "doots", "spooks")
	attack_verb_simple = list("play", "jazz", "trombone", "mourn", "doot", "spook")
	var/single_use = FALSE

/obj/item/instrument/trombone/spectral/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/spooky, too_spooky = !single_use, single_use = single_use)

/obj/item/instrument/trombone/spectral/one_doot
	single_use = TRUE

/obj/item/instrument/trombone/spectral/attack(mob/living/target_mob, mob/living/user, list/modifiers, list/attack_modifiers)
	playsound(src, 'sound/runtime/instruments/trombone/Cn4.mid', 1000, 1, -1)
	return ..()

/obj/item/instrument/recorder
	name = "竖笛"
	desc = "就像在学校里展示你的演奏能力一样。"
	force = 5
	icon_state = "recorder"
	allowed_instrument_ids = "recorder"
	inhand_icon_state = "recorder"

/obj/item/instrument/harmonica
	name = "口琴"
	desc = "因为当你遭遇严重的太空思乡病时。"
	icon_state = "harmonica"
	allowed_instrument_ids = list("crharmony", "harmonica")
	inhand_icon_state = "harmonica"
	slot_flags = ITEM_SLOT_MASK
	force = 5
	w_class = WEIGHT_CLASS_SMALL
	actions_types = list(/datum/action/item_action/instrument)
	action_slots = ALL

/obj/item/instrument/harmonica/equipped(mob/user, slot, initial = FALSE)
	. = ..()
	if(!(slot & slot_flags))
		return
	RegisterSignal(user, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/obj/item/instrument/harmonica/dropped(mob/user, silent = FALSE)
	. = ..()
	UnregisterSignal(user, COMSIG_MOB_SAY)

/obj/item/instrument/harmonica/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER
	if(!song.playing)
		return
	if(!ismob(loc))
		CRASH("[src] was still registered to listen in on [source] but was not found to be on their mob.")
	to_chat(loc, span_warning("你停下吹奏口琴来说话..."))
	song.playing = FALSE

/datum/action/item_action/instrument
	name = "使用乐器"
	desc = "使用指定的仪器"

/datum/action/item_action/instrument/do_effect(trigger_flags)
	if(!istype(target, /obj/item/instrument))
		return FALSE
	var/obj/item/instrument/instrument = target
	instrument.interact(usr)
	return TRUE

/obj/item/instrument/bikehorn
	name = "镀金的自行车喇叭"
	desc = "一款装饰精美的自行车喇叭，能够发出多种不同的鸣叫声。"
	icon_state = "bike_horn"
	inhand_icon_state = "bike_horn"
	lefthand_file = 'icons/mob/inhands/equipment/horns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/horns_righthand.dmi'
	allowed_instrument_ids = list("bikehorn", "honk")
	attack_verb_continuous = list("beautifully honks")
	attack_verb_simple = list("beautifully honk")
	w_class = WEIGHT_CLASS_TINY
	force = 0
	throw_speed = 3
	throw_range = 15
	hitsound = 'sound/items/bikehorn.ogg'

/obj/item/instrument/musicalmoth
	name = "音乐飞蛾"
	desc = "尽管这款音乐玩具广受欢迎，但最终还是因使用了对飞蛾痛苦叫声的不道德采样而被禁止销售。"
	icon_state = "mothsician"
	allowed_instrument_ids = "mothscream"
	attack_verb_continuous = list("flutters", "flaps")
	attack_verb_simple = list("flutter", "flap")
	w_class = WEIGHT_CLASS_TINY
	force = 0
	hitsound = 'sound/mobs/humanoids/moth/scream_moth.ogg'
	custom_price = PAYCHECK_COMMAND * 2.37
	custom_premium_price = PAYCHECK_COMMAND * 2.37
