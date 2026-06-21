
GLOBAL_LIST_INIT(cursed_animal_masks, list(
		/obj/item/clothing/mask/animal/pig/cursed,
		/obj/item/clothing/mask/animal/frog/cursed,
		/obj/item/clothing/mask/animal/cowmask/cursed,
		/obj/item/clothing/mask/animal/horsehead/cursed,
		/obj/item/clothing/mask/animal/small/rat/cursed,
		/obj/item/clothing/mask/animal/small/fox/cursed,
		/obj/item/clothing/mask/animal/small/bee/cursed,
		/obj/item/clothing/mask/animal/small/bear/cursed,
		/obj/item/clothing/mask/animal/small/bat/cursed,
		/obj/item/clothing/mask/animal/small/raven/cursed,
		/obj/item/clothing/mask/animal/small/jackal/cursed
	))

/obj/item/clothing/mask/animal
	abstract_type = /obj/item/clothing/mask
	w_class = WEIGHT_CLASS_SMALL
	clothing_flags = VOICEBOX_TOGGLABLE
	var/modifies_speech = TRUE
	flags_cover = MASKCOVERSMOUTH

	var/animal_type ///what kind of animal the masks represents. used for automatic name and description generation.
	var/list/animal_sounds ///phrases to be said when the player attempts to talk when speech modification / voicebox is enabled.
	var/list/animal_sounds_alt ///lower probability phrases to be said when talking.
	var/animal_sounds_alt_probability ///probability for alternative sounds to play.

	var/cursed ///if it's a cursed mask variant.
	var/curse_spawn_sound ///sound to play when the cursed mask variant is spawned.

/obj/item/clothing/mask/animal/Initialize(mapload)
	. = ..()
	if(cursed)
		make_cursed()

/obj/item/clothing/mask/animal/equipped(mob/M, slot)
	. = ..()
	if ((slot & ITEM_SLOT_MASK) && modifies_speech)
		RegisterSignal(M, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	else
		UnregisterSignal(M, COMSIG_MOB_SAY)

/obj/item/clothing/mask/animal/dropped(mob/M)
	. = ..()
	UnregisterSignal(M, COMSIG_MOB_SAY)

/obj/item/clothing/mask/animal/vv_edit_var(vname, vval)
	if(vname == NAMEOF(src, cursed))
		if(vval)
			if(!cursed)
				make_cursed()
		else if(cursed)
			clear_curse()
	if(vname == NAMEOF(src, modifies_speech) && ismob(loc))
		var/mob/M = loc
		if(M.get_item_by_slot(ITEM_SLOT_MASK) == src)
			if(vval)
				if(!modifies_speech)
					RegisterSignal(M, COMSIG_MOB_SAY, PROC_REF(handle_speech))
			else if(modifies_speech)
				UnregisterSignal(M, COMSIG_MOB_SAY)
	return ..()

/obj/item/clothing/mask/animal/examine(mob/user)
	. = ..()
	if(clothing_flags & VOICEBOX_TOGGLABLE)
		. += span_notice("它的语音盒目前处于[clothing_flags & VOICEBOX_DISABLED ? "disabled" : "enabled"]状态。<b>Alt-点击</b>来切换开关。")

/obj/item/clothing/mask/animal/click_alt(mob/user)
	if(!(clothing_flags & VOICEBOX_TOGGLABLE))
		return NONE
	clothing_flags ^= VOICEBOX_DISABLED
	to_chat(user, span_notice("你[clothing_flags & VOICEBOX_DISABLED ? "disabled" : "enabled"]了[src]的语音盒。"))
	return CLICK_ACTION_SUCCESS

/obj/item/clothing/mask/animal/proc/make_cursed() //apply cursed effects.
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_MASK_TRAIT)
	clothing_flags = NONE //force animal sounds to always on.
	if(flags_inv == initial(flags_inv))
		flags_inv = HIDEFACIALHAIR
	name = "[animal_type]脸"
	desc = "这看起来像是[animal_type]样的面具，但是如果仔细看面具已于这个人的脸无缝衔接了！"
	if(curse_spawn_sound)
		playsound(src, curse_spawn_sound, 50, TRUE)
	var/update_speech_mod = !modifies_speech && LAZYLEN(animal_sounds)
	if(update_speech_mod)
		modifies_speech = TRUE
	if(ismob(loc))
		var/mob/M = loc
		if(M.get_item_by_slot(ITEM_SLOT_MASK) == src)
			if(update_speech_mod)
				RegisterSignal(M, COMSIG_MOB_SAY, PROC_REF(handle_speech))
			to_chat(M, span_userdanger("[src] 被诅咒了！"))
			M.update_worn_mask()
			M.refresh_obscured()

/obj/item/clothing/mask/animal/proc/clear_curse()
	REMOVE_TRAIT(src, TRAIT_NODROP, CURSED_MASK_TRAIT)
	clothing_flags = initial(clothing_flags)
	flags_inv = initial(flags_inv)
	name = initial(name)
	desc = initial(desc)
	var/update_speech_mod = modifies_speech && !initial(modifies_speech)
	if(update_speech_mod)
		modifies_speech = FALSE
	if(ismob(loc))
		var/mob/M = loc
		if(M.get_item_by_slot(ITEM_SLOT_MASK) == src)
			to_chat(M, span_notice("[src] 的诅咒已被解除！"))
			if(update_speech_mod)
				UnregisterSignal(M, COMSIG_MOB_SAY)
			M.update_worn_mask()

/obj/item/clothing/mask/animal/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER

	if(clothing_flags & VOICEBOX_DISABLED)
		return
	if(!modifies_speech || !LAZYLEN(animal_sounds))
		return
	speech_args[SPEECH_MESSAGE] = pick((prob(animal_sounds_alt_probability) && LAZYLEN(animal_sounds_alt)) ? animal_sounds_alt : animal_sounds)

/obj/item/clothing/mask/animal/equipped(mob/user, slot)
	if(!iscarbon(user))
		return ..()
	if((slot & ITEM_SLOT_MASK) && HAS_TRAIT_FROM(src, TRAIT_NODROP, CURSED_MASK_TRAIT))
		to_chat(user, span_userdanger("[src] 被诅咒了！"))
	return ..()


/obj/item/clothing/mask/animal/pig
	name = "猪面具"
	desc = "一幅带有内置变声器的橡胶猪面具。"
	animal_type = "pig"
	icon_state = "pig"
	inhand_icon_state = null
	animal_sounds = list("Oink!","Squeeeeeeee!","Oink Oink!")
	curse_spawn_sound = 'sound/effects/magic/pighead_curse.ogg'
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

/obj/item/clothing/mask/animal/pig/cursed
	cursed = TRUE

///frog mask - reeee!!
/obj/item/clothing/mask/animal/frog
	name = "青蛙面具"
	desc = "一个雕刻成青蛙形状的古老面具。<br>理智如同重力，只需要轻轻一推。"
	icon_state = "frog"
	inhand_icon_state = null
	animal_sounds = list("Ree!!", "Reee!!","REEE!!","REEEEE!!")
	animal_sounds_alt_probability = 5
	animal_sounds_alt = list("HUUUUU!!","SMOOOOOKIN'!!","Hello my baby, hello my honey, hello my rag-time gal.", "Feels bad, man.", "GIT DIS GUY OFF ME!!" ,"SOMEBODY STOP ME!!", "NORMIES, GET OUT!!")
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT

/obj/item/clothing/mask/animal/frog/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, cursed ? 4 : -4)

/obj/item/clothing/mask/animal/frog/make_cursed()
	. = ..()
	RemoveElement(/datum/element/adjust_fishing_difficulty, -4)
	AddElement(/datum/element/adjust_fishing_difficulty, 4)

/obj/item/clothing/mask/animal/frog/clear_curse()
	. = ..()
	RemoveElement(/datum/element/adjust_fishing_difficulty, 4)
	AddElement(/datum/element/adjust_fishing_difficulty, -4)

/obj/item/clothing/mask/animal/frog/cursed
	cursed = TRUE

/obj/item/clothing/mask/animal/cowmask
	name = "奶牛面具"
	icon_state = "cowmask"
	inhand_icon_state = null
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	curse_spawn_sound = 'sound/effects/magic/cowhead_curse.ogg'
	animal_sounds = list("Moooooooo!","Moo!","Moooo!")

/obj/item/clothing/mask/animal/cowmask/cursed
	cursed = TRUE

/obj/item/clothing/mask/animal/horsehead
	name = "马面具"
	desc = "一幅由软质乙烯基塑料和乳胶制作而成的面具，所展现出的是一个马头的形象。"
	animal_type = "horse"
	icon_state = "horsehead"
	inhand_icon_state = null
	animal_sounds = list("NEEIIGGGHHHH!", "NEEEIIIIGHH!", "NEIIIGGHH!", "HAAWWWWW!", "HAAAWWW!")
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDEEYES|HIDEEARS|HIDESNOUT
	curse_spawn_sound = 'sound/effects/magic/horsehead_curse.ogg'

/obj/item/clothing/mask/animal/horsehead/cursed
	cursed = TRUE

/obj/item/clothing/mask/animal/small
	name = "小型动物面具"
	desc = "如果你看到这种情况，就去训斥程序员。"
	abstract_type = /obj/item/clothing/mask/animal/small
	flags_inv = HIDEFACE|HIDESNOUT

/obj/item/clothing/mask/animal/small/make_cursed()
	flags_inv = NONE
	return ..()

/obj/item/clothing/mask/animal/small/rat
	name = "老鼠面具"
	desc = "一幅由软质乙烯基塑料和乳胶制作而成的面具，所展现出的是一个鼠头的形象。"
	animal_type = "rat"
	icon_state = "rat"
	inhand_icon_state = null
	animal_sounds = list("Skree!","SKREEE!","Squeak!")

/obj/item/clothing/mask/animal/small/rat/cursed
	cursed = TRUE

/obj/item/clothing/mask/animal/small/fox
	name = "狐狸面具"
	desc = "一幅由软质乙烯基塑料和乳胶制作而成的面具，所展现出的是一个狐狸头的形象。"
	animal_type = "fox"
	icon_state = "fox"
	inhand_icon_state = null
	animal_sounds = list("Ack-Ack!","Ack-Ack-Ack-Ackawoooo!","Geckers!","AWOO!","TCHOFF!")

/obj/item/clothing/mask/animal/small/fox/cursed
	cursed = TRUE

/obj/item/clothing/mask/animal/small/bee
	name = "蜜蜂面具"
	desc = "一幅由软质乙烯基塑料和乳胶制作而成的面具，所展现出的是一个蜜蜂头的形象。"
	animal_type = "bee"
	icon_state = "bee"
	inhand_icon_state = null
	animal_sounds = list("BZZT!", "BUZZZ!", "B-zzzz!", "Bzzzzzzttttt!")

/obj/item/clothing/mask/animal/small/bee/cursed
	cursed = TRUE

/obj/item/clothing/mask/animal/small/bear
	name = "熊面具"
	desc = "一幅由软质乙烯基塑料和乳胶制作而成的面具，所展现出的是一个熊头的形象。"
	animal_type = "bear"
	icon_state = "bear"
	inhand_icon_state = null
	animal_sounds = list("RAWR!","Rawr!","GRR!","Growl!")

/obj/item/clothing/mask/animal/small/bear/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, cursed ? 4 : -4)

/obj/item/clothing/mask/animal/small/bear/make_cursed()
	. = ..()
	RemoveElement(/datum/element/adjust_fishing_difficulty, -4)
	AddElement(/datum/element/adjust_fishing_difficulty, 4)

/obj/item/clothing/mask/animal/small/bear/clear_curse()
	. = ..()
	RemoveElement(/datum/element/adjust_fishing_difficulty, 4)
	AddElement(/datum/element/adjust_fishing_difficulty, -4)

/obj/item/clothing/mask/animal/small/bear/cursed
	cursed = TRUE

/obj/item/clothing/mask/animal/small/bat
	name = "蝙蝠面具"
	desc = "一幅由软质乙烯基塑料和乳胶制作而成的面具，所展现出的是一个蝙蝠头的形象。"
	animal_type = "bat"
	icon_state = "bat"
	inhand_icon_state = null

/obj/item/clothing/mask/animal/small/bat/cursed
	cursed = TRUE


/obj/item/clothing/mask/animal/small/raven
	name = "乌鸦面具"
	desc = "一个由柔软的乙烯基和乳胶制成的面具，代表乌鸦的头。"
	icon_state = "raven"
	inhand_icon_state = null
	animal_type = "raven"
	animal_sounds = list("CAW!", "C-CAWW!", "Squawk!")
	animal_sounds_alt = list("Nevermore...")
	animal_sounds_alt_probability = 1

/obj/item/clothing/mask/animal/small/raven/cursed
	cursed = TRUE

/obj/item/clothing/mask/animal/small/jackal
	name = "豺面具"
	desc = "一幅由软质乙烯基塑料和乳胶制作而成的面具，所展现出的是一个豺头的形象。"
	animal_type = "jackal"
	icon_state = "jackal"
	inhand_icon_state = null
	animal_sounds = list("YAP!", "Woof!", "Bark!", "AUUUUUU!")

/obj/item/clothing/mask/animal/small/jackal/cursed
	cursed = TRUE

/obj/item/clothing/mask/animal/small/tribal
	name = "部落面具"
	desc = "一个用木头雕刻成的面具，手工制作，十分精细。"
	animal_type = "tribal" //honk.
	icon_state = "bumba"
	inhand_icon_state = null
	animal_sounds = list("Bad juju, mon!", "Da Iwa be praised!", "Sum bad mojo, dat!", "You do da voodoo, mon!")
	animal_sounds_alt = list("Eekum-bokum!", "Oomenacka!", "In mah head..... Zombi.... Zombi!")
	animal_sounds_alt_probability = 5

/obj/item/clothing/mask/animal/small/tribal/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, cursed ? 5 : -5)

/obj/item/clothing/mask/animal/small/tribal/make_cursed()
	. = ..()
	RemoveElement(/datum/element/adjust_fishing_difficulty, -5)
	AddElement(/datum/element/adjust_fishing_difficulty, 5)

/obj/item/clothing/mask/animal/small/tribal/clear_curse()
	. = ..()
	RemoveElement(/datum/element/adjust_fishing_difficulty, 5)
	AddElement(/datum/element/adjust_fishing_difficulty, -5)

/obj/item/clothing/mask/animal/small/tribal/cursed //adminspawn only.
	cursed = TRUE
