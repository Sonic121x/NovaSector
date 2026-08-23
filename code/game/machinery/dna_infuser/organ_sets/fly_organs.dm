// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
#define FLY_INFUSED_ORGAN_DESC "You have no idea what the hell this is, or how it manages to keep something alive in any capacity."
#define FLY_INFUSED_ORGAN_ICON pick("brain-x-d", "liver-x", "kidneys-x", "spinner-x", "lungs-x", "random_fly_1", "random_fly_2", "random_fly_3", "random_fly_4", "random_fly_5")

///bonus of the fly: you... are a flyperson now. sorry.
/datum/status_effect/organ_set_bonus/fly
	id = "organ_set_bonus_fly"
	organs_needed = 4 //there are actually 7 fly organs that count, but you only need 4 to go full-flyperson. Be careful!
	bonus_activate_text = null
	bonus_deactivate_text = null

/datum/status_effect/organ_set_bonus/fly/enable_bonus(obj/item/organ/inserted_organ)
	. = ..()
	if(!. || !ishuman(owner))
		return
	var/mob/living/carbon/human/new_fly = owner
	if(isflyperson(new_fly))
		return
	// This is ugly as sin, but we're called before the organ finishes inserting into the bodypart
	// so if we swap species directly the bodypart will be replaced and we'll be gone
	// so we need to delay species change until we're fully inserted
	RegisterSignal(inserted_organ, COMSIG_ORGAN_BODYPART_INSERTED, PROC_REF(flyify))

/datum/status_effect/organ_set_bonus/fly/proc/flyify(obj/item/organ/source, obj/item/bodypart/limb)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/new_fly = owner
	// just in case?
	if(isflyperson(new_fly))
		return
	// needs to be done before the species is set
	UnregisterSignal(source, COMSIG_ORGAN_BODYPART_INSERTED)
	// okay you NEED to be a fly
	to_chat(new_fly, span_danger(LANG("datum.47394568433d5ead", null)))
	new_fly.set_species(/datum/species/fly)

/obj/item/organ/eyes/fly
	name = "fly eyes"
	desc = "These eyes seem to stare back no matter the direction you look at it from."
	eye_icon_state = "flyeyes"
	icon_state = "eyes_fly"
	flash_protect = FLASH_PROTECTION_HYPER_SENSITIVE
	native_fov = NONE //flies can see all around themselves.
	blink_animation = FALSE
	iris_overlay = null

/obj/item/organ/eyes/fly/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/organ_set_bonus, /datum/status_effect/organ_set_bonus/fly)

/obj/item/organ/tongue/fly
	name = "proboscis"
	desc = "A freakish looking meat tube that apparently can take in liquids."
	icon = 'icons/obj/medical/organs/fly_organs.dmi'
	say_mod = "buzzes"
	taste_sensitivity = 25 // you eat vomit, this is a mercy
	liked_foodtypes = GROSS | GORE // nasty ass
	disliked_foodtypes = NONE
	toxic_foodtypes = NONE // these fucks eat vomit, i am sure they can handle drinking bleach or whatever too
	modifies_speech = TRUE
	languages_native = list(/datum/language/buzzwords)
	organ_traits = list(TRAIT_VOMIT_SLURPER)
	var/static/list/speech_replacements = list(
		new /regex("z+", "g") = "zzz",
		new /regex("Z+", "g") = "ZZZ",
		"s" = "z",
		"S" = "Z",
	)
	// NOVA EDIT ADDITION START - I18N - 中文版拟声。上面那张表是**字母级**替换（s→sss / s→z），
	// 中文文本里一个拉丁字母都没有 → 整个效果在中文服上是空转，苍蝇人说话和常人无异。
	// 中文没有可替换的对应音字母，硬换字会毁掉词义，所以改成**标点锚定**：句末补一声，
	// 本来就有的拟声字拉长。全角半角标点都认（中文输入法默认全角）。
	var/static/list/chinese_speech_replacements = list(
		new /regex("嗞+", "g") = "嗞嗞嗞",
		"。" = "嗞。",
		"！" = "嗞！",
		"？" = "嗞？",
		"，" = "嗞，",
		// 半角标点**必须锚定前一个汉字**：合并英文表之后，裸的 "."/"!"/"?" 会在英文句子上开火，
		// 把 "She is so sassy." 变成 "…sassy嗞."。锚定之后它只在中文字后面触发。
		new /regex("(\[一-鿿\])\\.", "g") = "$1嗞.",
		new /regex("(\[一-鿿\])!", "g") = "$1嗞!",
		new /regex("(\[一-鿿\])\\?", "g") = "$1嗞?",
	)
	// NOVA EDIT ADDITION END
	// NOVA EDIT ADDITION START - Russian version - yes copy pasted from above because static lists are great.
	var/static/list/russian_speech_replacements = list(
		new /regex("z+", "g") = "zzz",
		new /regex("Z+", "g") = "ZZZ",
		new /regex("з+", "g") = "ззз",
		new /regex("З+", "g") = "ЗЗЗ",
		"s" = "z",
		"S" = "Z",
		"с" = "з",
		"С" = "З",
	)
	// NOVA EDIT ADDITION END


/obj/item/organ/tongue/fly/Initialize(mapload)
	. = ..()
	// NOVA EDIT CHANGE START - I18N - 中文拟声表**叠加**在英文表之上（不是替换）。
	// 两套规则管的是两种文本形态：`s→sss` 只在拉丁字母上开火、`。→嗞。` 只在中文标点上开火，
	// 合在一张表里互不干扰。整张替换掉的写法会让中文服上的英文发言丢掉效果，
	// 也会让上游的 speech_modifiers 单测直接红（它断言的正是英文输入的变形结果）。
	var/static/list/chinese_merged
	if(lang_locale_is_chinese() && isnull(chinese_merged))
		chinese_merged = lang_merge_speech_replacements(speech_replacements, chinese_speech_replacements)
	AddComponent(/datum/component/speechmod, replacements = chinese_merged || (CONFIG_GET(flag/russian_text_formation) ? russian_speech_replacements : speech_replacements), should_modify_speech = CALLBACK(src, PROC_REF(should_modify_speech))) // NOVA EDIT CHANGE - ORIGINAL: AddComponent(/datum/component/speechmod, replacements = speech_replacements, should_modify_speech = CALLBACK(src, PROC_REF(should_modify_speech)))
	// NOVA EDIT CHANGE END
	AddElement(/datum/element/organ_set_bonus, /datum/status_effect/organ_set_bonus/fly)

/obj/item/organ/tongue/fly/get_possible_languages()
	return ..() + /datum/language/buzzwords

/obj/item/organ/heart/fly
	desc = FLY_INFUSED_ORGAN_DESC

/obj/item/organ/heart/fly/Initialize(mapload)
	. = ..()
	name = odd_organ_name()
	icon_state = FLY_INFUSED_ORGAN_ICON
	AddElement(/datum/element/organ_set_bonus, /datum/status_effect/organ_set_bonus/fly)
	AddElement(/datum/element/update_icon_blocker)

/obj/item/organ/lungs/fly
	desc = FLY_INFUSED_ORGAN_DESC

/obj/item/organ/lungs/fly/Initialize(mapload)
	. = ..()
	name = odd_organ_name()
	icon_state = FLY_INFUSED_ORGAN_ICON
	AddElement(/datum/element/organ_set_bonus, /datum/status_effect/organ_set_bonus/fly)

/obj/item/organ/liver/fly
	desc = FLY_INFUSED_ORGAN_DESC
	alcohol_tolerance = 0.007 //flies eat vomit, so a lower alcohol tolerance is perfect!

/obj/item/organ/liver/fly/Initialize(mapload)
	. = ..()
	name = odd_organ_name()
	icon_state = FLY_INFUSED_ORGAN_ICON
	AddElement(/datum/element/organ_set_bonus, /datum/status_effect/organ_set_bonus/fly)

/obj/item/organ/stomach/fly
	desc = FLY_INFUSED_ORGAN_DESC

/obj/item/organ/stomach/fly/Initialize(mapload)
	. = ..()
	name = odd_organ_name()
	icon_state = FLY_INFUSED_ORGAN_ICON
	AddElement(/datum/element/organ_set_bonus, /datum/status_effect/organ_set_bonus/fly)

/obj/item/organ/stomach/fly/after_eat(edible)
	var/mob/living/carbon/body = owner
	ASSERT(istype(body))
	// we do not lose any nutrition as a fly when vomiting out food
	body.vomit(vomit_flags = (MOB_VOMIT_MESSAGE | MOB_VOMIT_FORCE | MOB_VOMIT_HARM), lost_nutrition = 0, distance = 2, purge_ratio = 0.67)
	playsound(get_turf(owner), 'sound/effects/splat.ogg', 50, TRUE)
	body.visible_message(
		span_danger(LANG("obj.04e91940a6bcc616", list(body))),
		span_userdanger(LANG("obj.6bcf6afee3efd1c0", null)),
	)
	return ..()

/obj/item/organ/appendix/fly
	desc = FLY_INFUSED_ORGAN_DESC

/obj/item/organ/appendix/fly/Initialize(mapload)
	. = ..()
	name = odd_organ_name()
	icon_state = FLY_INFUSED_ORGAN_ICON
	AddElement(/datum/element/organ_set_bonus, /datum/status_effect/organ_set_bonus/fly)

/obj/item/organ/appendix/fly/update_appearance(updates=ALL)
	return ..(updates & ~(UPDATE_NAME|UPDATE_ICON)) //don't set name or icon thank you

//useless organs we throw in just to fuck with surgeons a bit more. they aren't part of a bonus, just the (absolute) state of flies
/obj/item/organ/fly
	desc = FLY_INFUSED_ORGAN_DESC

/obj/item/organ/fly/Initialize(mapload)
	. = ..()
	name = odd_organ_name()
	icon_state = FLY_INFUSED_ORGAN_ICON

/obj/item/organ/fly/groin //appendix is the only groin organ so we gotta have one of these too lol
	zone = BODY_ZONE_PRECISE_GROIN

#undef FLY_INFUSED_ORGAN_DESC
#undef FLY_INFUSED_ORGAN_ICON
