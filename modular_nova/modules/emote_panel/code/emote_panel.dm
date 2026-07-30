/mob/proc/manipulate_emotes()
	if(!mind)
		return
	var/list/available_emotes = list()
	var/list/all_emotes = list()

	// code\modules\mob\emote.dm
	var/static/list/mob_emotes = list(
		/mob/proc/emote_flip,
		/mob/proc/emote_spin,
		/mob/proc/emote_rolld20,
	)
	all_emotes += mob_emotes

	// code\modules\mob\living\emote.dm
	var/static/list/living_emotes = list(
		/mob/living/proc/emote_blush,
		/mob/living/proc/emote_bow,
		/mob/living/proc/emote_burp,
		/mob/living/proc/emote_choke,
		/mob/living/proc/emote_cross,
		/mob/living/proc/emote_chuckle,
		/mob/living/proc/emote_collapse,
		/mob/living/proc/emote_cough,
		/mob/living/proc/emote_dance,
		/mob/living/proc/emote_drool,
		/mob/living/proc/emote_faint,
		/mob/living/proc/emote_flap,
		/mob/living/proc/emote_aflap,
		/mob/living/proc/emote_frown,
		/mob/living/proc/emote_gag,
		/mob/living/proc/emote_giggle,
		/mob/living/proc/emote_glare,
		/mob/living/proc/emote_grin,
		/mob/living/proc/emote_groan,
		/mob/living/proc/emote_grimace,
		/mob/living/proc/emote_jump,
		/mob/living/proc/emote_kiss,
		/mob/living/proc/emote_laugh,
		/mob/living/proc/emote_look,
		/mob/living/proc/emote_nod,
		/mob/living/proc/emote_nodnod,
		/mob/living/proc/emote_point,
		/mob/living/proc/emote_pout,
		/mob/living/proc/emote_scream,
		/mob/living/proc/emote_scowl,
		/mob/living/proc/emote_shake,
		/mob/living/proc/emote_shiver,
		/mob/living/proc/emote_sigh,
		/mob/living/proc/emote_sit,
		/mob/living/proc/emote_smile,
		/mob/living/proc/emote_sneeze,
		/mob/living/proc/emote_smug,
		/mob/living/proc/emote_sniff,
		/mob/living/proc/emote_stare,
		/mob/living/proc/emote_strech,
		/mob/living/proc/emote_sulk,
		/mob/living/proc/emote_sway,
		/mob/living/proc/emote_tilt,
		/mob/living/proc/emote_tremble,
		/mob/living/proc/emote_twitch,
		/mob/living/proc/emote_twitch_s,
		/mob/living/proc/emote_wave,
		/mob/living/proc/emote_whimper,
		/mob/living/proc/emote_wsmile,
		/mob/living/proc/emote_yawn,
		/mob/living/proc/emote_gurgle,
		/mob/living/proc/emote_inhale,
		/mob/living/proc/emote_exhale,
		/mob/living/proc/emote_swear
	)
	all_emotes += living_emotes

	// code\modules\mob\living\carbon\emote.dm
	var/static/list/carbon_emotes = list(
		/mob/living/carbon/proc/emote_airguitar,
		/mob/living/carbon/proc/emote_blink,
		/mob/living/carbon/proc/emote_blink_r,
		/mob/living/carbon/proc/emote_crack,
		/mob/living/carbon/proc/emote_circle,
		/mob/living/carbon/proc/emote_moan,
		/mob/living/carbon/proc/emote_slap,
		/mob/living/carbon/proc/emote_wink
	)
	all_emotes += carbon_emotes

	// code\modules\mob\living\carbon\human\emote.dm
	var/static/list/human_emotes = list(
		/mob/living/carbon/human/proc/emote_cry,
		/mob/living/carbon/human/proc/emote_eyebrow,
		/mob/living/carbon/human/proc/emote_grumble,
		/mob/living/carbon/human/proc/emote_mumble,
		/mob/living/carbon/human/proc/emote_pale,
		/mob/living/carbon/human/proc/emote_raise,
		/mob/living/carbon/human/proc/emote_salute,
		/mob/living/carbon/human/proc/emote_shrug,
		/mob/living/carbon/human/proc/emote_wag,
		/mob/living/carbon/human/proc/emote_wing
	)
	all_emotes += human_emotes

	// modular_nova\modules\emotes\code\emote.dm
	var/static/list/nova_living_emotes = list(
		/mob/living/proc/emote_peep,
		/mob/living/proc/emote_peep2,
		/mob/living/proc/emote_snap,
		/mob/living/proc/emote_snap2,
		/mob/living/proc/emote_snap3,
		/mob/living/proc/emote_awoo,
		/mob/living/proc/emote_nya,
		/mob/living/proc/emote_weh,
		/mob/living/proc/emote_mothsqueak,
		/mob/living/proc/emote_mousesqueak,
		/mob/living/proc/emote_merp,
		/mob/living/proc/emote_bark,
		/mob/living/proc/emote_squish,
		/mob/living/proc/emote_bubble,
		/mob/living/proc/emote_pop,
		/mob/living/proc/emote_meow,
		/mob/living/proc/emote_hiss1,
		/mob/living/proc/emote_chitter,
		/mob/living/proc/emote_snore,
		/mob/living/proc/emote_clap,
		/mob/living/proc/emote_clap1,
		/mob/living/proc/emote_headtilt,
		/mob/living/proc/emote_blink2,
		/mob/living/proc/emote_rblink,
		/mob/living/proc/emote_squint,
		/mob/living/proc/emote_smirk,
		/mob/living/proc/emote_eyeroll,
		/mob/living/proc/emote_huff,
		/mob/living/proc/emote_etwitch,
		/mob/living/proc/emote_clear,
		/mob/living/proc/emote_bawk,
		/mob/living/proc/emote_caw,
		/mob/living/proc/emote_caw2,
		/mob/living/proc/emote_whistle,
		/mob/living/proc/emote_blep,
		/mob/living/proc/emote_bork,
		/mob/living/proc/emote_hoot,
		/mob/living/proc/emote_growl,
		/mob/living/proc/emote_woof,
		/mob/living/proc/emote_baa,
		/mob/living/proc/emote_baa2,
		/mob/living/proc/emote_wurble,
		/mob/living/proc/emote_rattle,
		/mob/living/proc/emote_cackle,
		/mob/living/proc/emote_warble,
		/mob/living/proc/emote_trills,
		/mob/living/proc/emote_rpurr,
		/mob/living/proc/emote_purr,
		/mob/living/proc/emote_moo,
		/mob/living/proc/emote_honk1,
		/mob/living/proc/emote_mggaow,
		/mob/living/proc/emote_mrrp,
		/mob/living/proc/emote_prbt,
		/mob/living/proc/emote_yip,
		/mob/living/proc/emote_fwhine,
		/mob/living/proc/emote_awuff,
		/mob/living/proc/emote_arf,
		/mob/living/proc/emote_coyhowl,
		/mob/living/proc/emote_wolfhowl,
		/mob/living/proc/emote_dwhine,
		/mob/living/proc/emote_dgrowl,
		/mob/living/proc/emote_aggrobark,
		/mob/living/proc/emote_dcomplain,
		/mob/living/proc/emote_meowdeep,
		/mob/living/proc/emote_teshchirp,
		/mob/living/proc/emote_teshsqueak,
		/mob/living/proc/emote_teshtrill,
		/mob/living/proc/emote_gecker,
	)
	all_emotes += nova_living_emotes

	// code\modules\mob\living\brain\emote.dm
	var/static/list/brain_emotes = list(
		/mob/living/brain/proc/emote_alarm,
		/mob/living/brain/proc/emote_alert,
		/mob/living/brain/proc/emote_flash,
		/mob/living/brain/proc/emote_notice,
		/mob/living/brain/proc/emote_whistle_brain
	)
	all_emotes += brain_emotes

	// code\modules\mob\living\carbon\alien\emote.dm
	var/static/list/alien_emotes = list(
		/mob/living/carbon/alien/proc/emote_gnarl,
		/mob/living/carbon/alien/proc/emote_hiss,
		/mob/living/carbon/alien/proc/emote_roar
	)
	all_emotes += alien_emotes

	// modular_nova\modules\emotes\code\synth_emotes.dm
	var/static/list/synth_emotes = list(
		/mob/living/proc/emote_dwoop,
		/mob/living/proc/emote_yes,
		/mob/living/proc/emote_no,
		/mob/living/proc/emote_boop,
		/mob/living/proc/emote_buzz,
		/mob/living/proc/emote_beep,
		/mob/living/proc/emote_beep2,
		/mob/living/proc/emote_buzz2,
		/mob/living/proc/emote_chime,
		/mob/living/proc/emote_honk,
		/mob/living/proc/emote_ping,
		/mob/living/proc/emote_sad,
		/mob/living/proc/emote_warn,
		/mob/living/proc/emote_slowclap
	)
	all_emotes += synth_emotes
	var/static/list/allowed_species_synth = list(
		/datum/species/synthetic
	)

	// modular_nova\modules\emotes\code\additionalemotes\overlay_emote.dm
	var/static/list/nova_living_emotes_overlay = list(
		/mob/living/proc/emote_sweatdrop,
		/mob/living/proc/emote_exclaim,
		/mob/living/proc/emote_question,
		/mob/living/proc/emote_realize,
		/mob/living/proc/emote_annoyed,
		/mob/living/proc/emote_glasses
	)
	all_emotes += nova_living_emotes_overlay

	// modular_nova\modules\emotes\code\additionalemotes\turf_emote.dm
	all_emotes += /mob/living/proc/emote_mark_turf

	// Clearing all emotes before applying new ones
	verbs -= all_emotes

	// Checking if preferences allow emote panel
	if(!src.client?.prefs?.read_preference(/datum/preference/toggle/emote_panel))
		return

	// Checking emote availability
	if(isbrain(src))
		// Only brains in MMI have emotes
		var/mob/living/brain/current_brain = src
		if(current_brain.container && istype(current_brain.container, /obj/item/mmi))
			available_emotes += brain_emotes
	else
		if(ismob(src))
			available_emotes += mob_emotes
		if(isliving(src))
			available_emotes += living_emotes
			available_emotes += nova_living_emotes
			available_emotes += nova_living_emotes_overlay
			available_emotes += /mob/living/proc/emote_mark_turf
			// Checking if should apply Synth emotes
			if(HAS_TRAIT(src, TRAIT_SILICON_EMOTES_ALLOWED))
				available_emotes += synth_emotes
		if(iscarbon(src))
			available_emotes += carbon_emotes
		if(ishuman(src))
			available_emotes += human_emotes
			var/mob/living/carbon/human/current_mob = src
			// Checking if can wag tail
			var/obj/item/organ/tail/tail = current_mob.get_organ_slot(ORGAN_SLOT_EXTERNAL_TAIL)
			if(!(tail?.wag_flags & WAG_ABLE))
				available_emotes -= /mob/living/carbon/human/proc/emote_wag
			// Checking if has wings
			if(!current_mob.get_organ_slot(ORGAN_SLOT_EXTERNAL_WINGS))
				available_emotes -= /mob/living/carbon/human/proc/emote_wing
		if(isalien(src))
			available_emotes += alien_emotes

	// Applying emote panel if preferences allow
	for(var/emote in available_emotes)
		verbs |= emote

/mob/mind_initialize()
	. = ..()
	manipulate_emotes()

// code\modules\mob\emote.dm
GAME_VERB_PROC(/mob, emote_flip, "| 翻转 |", "Emotes")
	src.emote("flip", intentional = TRUE)

GAME_VERB_PROC(/mob, emote_spin, "| 旋转 |", "Emotes")
	src.emote("spin", intentional = TRUE)

GAME_VERB_PROC(/mob, emote_rolld20, "| 掷 D20 |", "Emotes")
	src.emote("rolld20", intentional = TRUE)
// code\modules\mob\living\emote.dm

GAME_VERB_PROC(/mob/living, emote_blush, "~ 脸红", "Emotes")
	src.emote("blush", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_bow, "~ 鞠躬", "Emotes")
	src.emote("bow", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_burp, "> 打嗝", "Emotes")
	src.emote("burp", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_choke, "~ 噎住", "Emotes")
	src.emote("choke", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_cross, "~ 抱臂", "Emotes")
	src.emote("cross", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_chuckle, "~ 轻笑", "Emotes")
	src.emote("chuckle", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_collapse, "~ 瘫倒", "Emotes")
	src.emote("collapse", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_cough, "> 咳嗽", "Emotes")
	src.emote("cough", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_dance, "~ 跳舞", "Emotes")
	src.emote("dance", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_drool, "~ 流口水", "Emotes")
	src.emote("drool", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_faint, "~ 昏厥", "Emotes")
	src.emote("faint", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_flap, "~ 振翅", "Emotes")
	src.emote("flap", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_aflap, "~ 愤怒振翅", "Emotes")
	src.emote("aflap", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_frown, "~ 皱眉", "Emotes")
	src.emote("frown", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_gag, "~ 干呕", "Emotes")
	src.emote("gag", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_giggle, "~ 咯咯笑", "Emotes")
	src.emote("giggle", intentional = TRUE)


GAME_VERB_PROC(/mob/living, emote_glare, "~ 瞪视", "Emotes")
	src.emote("glare", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_grin, "~ 咧嘴笑", "Emotes")
	src.emote("grin", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_groan, "~ 闷哼", "Emotes")
	src.emote("groan", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_grimace, "~ 扮鬼脸", "Emotes")
	src.emote("grimace", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_jump, "~ 跳跃", "Emotes")
	src.emote("jump", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_kiss, "| 亲吻 |", "Emotes")
	src.emote("kiss", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_laugh, "> 大笑", "Emotes")
	src.emote("laugh", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_look, "~ 张望", "Emotes")
	src.emote("look", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_nod, "~ 点头", "Emotes")
	src.emote("nod", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_nodnod, "~ 连连点头", "Emotes")
	src.emote("nod2", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_point, "~ 指向", "Emotes")
	src.emote("point", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_pout, "~ 撅嘴", "Emotes")
	src.emote("pout", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_scream, "> 尖叫", "Emotes")
	src.emote("scream", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_scowl, "~ 怒视", "Emotes")
	src.emote("scowl", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_shake, "~ 摇头", "Emotes")
	src.emote("shake", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_shiver, "~ 发抖", "Emotes")
	src.emote("shiver", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_sigh, "> 叹气", "Emotes")
	src.emote("sigh", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_sit, "~ 坐下", "Emotes")
	src.emote("sit", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_smile, "~ 微笑", "Emotes")
	src.emote("smile", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_sneeze, "> 打喷嚏", "Emotes")
	src.emote("sneeze", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_smug, "~ 得意笑", "Emotes")
	src.emote("smug", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_sniff, "> 吸鼻子", "Emotes")
	src.emote("sniff", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_stare, "~ 凝视", "Emotes")
	src.emote("stare", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_strech, "~ 伸懒腰", "Emotes")
	src.emote("stretch", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_sulk, "~ 闷闷不乐", "Emotes")
	src.emote("sulk", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_sway, "~ 晕乎摇晃", "Emotes")
	src.emote("sway", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_tilt, "~ 歪头", "Emotes")
	src.emote("tilt", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_tremble, "~ 颤抖", "Emotes")
	src.emote("tremble", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_twitch, "~ 剧烈抽搐", "Emotes")
	src.emote("twitch", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_twitch_s, "~ 轻微抽搐", "Emotes")
	src.emote("twitch_s", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_wave, "~ 挥手", "Emotes")
	src.emote("wave", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_whimper, "~ 呜咽", "Emotes")
	src.emote("whimper", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_wsmile, "~ 勉强微笑", "Emotes")
	src.emote("wsmile", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_yawn, "~ 打哈欠", "Emotes")
	src.emote("yawn", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_gurgle, "~ 难受地咕噜", "Emotes")
	src.emote("gurgle", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_inhale, "~ 吸气", "Emotes")
	src.emote("inhale", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_exhale, "~ 呼气", "Emotes")
	src.emote("exhale", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_swear, "~ 骂脏话", "Emotes")
	src.emote("swear", intentional = TRUE)

// code\modules\mob\living\carbon\emote.dm

GAME_VERB_PROC(/mob/living/carbon, emote_airguitar, "~ 空气吉他", "Emotes")
	src.emote("airguitar", intentional = TRUE)

GAME_VERB_PROC(/mob/living/carbon, emote_blink, "~ 眨眼", "Emotes")
	src.emote("blink", intentional = TRUE)

GAME_VERB_PROC(/mob/living/carbon, emote_blink_r, "~ 快速眨眼", "Emotes")
	src.emote("blink_r", intentional = TRUE)

GAME_VERB_PROC(/mob/living/carbon, emote_crack, "> 掰响指节", "Emotes")
	src.emote("crack", intentional = TRUE)

GAME_VERB_PROC(/mob/living/carbon, emote_circle, "| 画圈 |", "Emotes")
	src.emote("circle", intentional = TRUE)

GAME_VERB_PROC(/mob/living/carbon, emote_moan, "~ 呻吟", "Emotes")
	src.emote("moan", intentional = TRUE)

GAME_VERB_PROC(/mob/living/carbon, emote_slap, "| 掌掴 |", "Emotes")
	src.emote("slap", intentional = TRUE)

GAME_VERB_PROC(/mob/living/carbon, emote_wink, "~ 眨眼示意", "Emotes")
	src.emote("wink", intentional = TRUE)

// code\modules\mob\living\carbon\human\emote.dm

GAME_VERB_PROC(/mob/living/carbon/human, emote_cry, "~ 哭泣", "Emotes")
	src.emote("cry", intentional = TRUE)

GAME_VERB_PROC(/mob/living/carbon/human, emote_eyebrow, "~ 挑眉", "Emotes")
	src.emote("eyebrow", intentional = TRUE)

GAME_VERB_PROC(/mob/living/carbon/human, emote_grumble, "~ 嘟囔", "Emotes")
	src.emote("grumble", intentional = TRUE)

GAME_VERB_PROC(/mob/living/carbon/human, emote_mumble, "~ 咕哝", "Emotes")
	src.emote("mumble", intentional = TRUE)

GAME_VERB_PROC(/mob/living/carbon/human, emote_pale, "~ 脸色发白", "Emotes")
	src.emote("pale", intentional = TRUE)

GAME_VERB_PROC(/mob/living/carbon/human, emote_raise, "~ 举手", "Emotes")
	src.emote("raise", intentional = TRUE)

GAME_VERB_PROC(/mob/living/carbon/human, emote_salute, "~ 敬礼", "Emotes")
	src.emote("salute", intentional = TRUE)

GAME_VERB_PROC(/mob/living/carbon/human, emote_shrug, "~ 耸肩", "Emotes")
	src.emote("shrug", intentional = TRUE)

GAME_VERB_PROC(/mob/living/carbon/human, emote_wag, "| 摇尾 |", "Emotes")
	src.emote("wag", intentional = TRUE)

GAME_VERB_PROC(/mob/living/carbon/human, emote_wing, "| 摆翅 |", "Emotes")
	src.emote("wing", intentional = TRUE)

// modular_nova\modules\emotes\code\emote.dm

GAME_VERB_PROC(/mob/living, emote_peep, "> 啾", "Emotes+")
	src.emote("peep", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_peep2, "> 啾啾两声", "Emotes+")
	src.emote("peep2", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_snap, "> 打响指", "Emotes+")
	src.emote("snap", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_snap2, "> 两声响指", "Emotes+")
	src.emote("snap2", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_snap3, "> 三声响指", "Emotes+")
	src.emote("snap3", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_awoo, "> 嗷呜", "Emotes+")
	src.emote("awoo", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_yip, "> 尖吠", "Emotes+")
	src.emote("yip", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_gecker, "> 咯咯叫", "Emotes+")
	src.emote("gecker", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_fwhine, "> 狐狸哀鸣", "Emotes+")
	src.emote("fwhine", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_nya, "> 喵呜", "Emotes+")
	src.emote("nya", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_weh, "> 唔诶", "Emotes+")
	src.emote("weh", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_mothsqueak, "> 蛾类吱鸣", "Emotes+")
	src.emote("msqueak", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_mousesqueak, "> 鼠吱", "Emotes+")
	src.emote("squeak", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_merp, "> 咩噗", "Emotes+")
	src.emote("merp", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_bark, "> 吠叫", "Emotes+")
	src.emote("bark", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_squish, "> 挤压声", "Emotes+")
	src.emote("squish", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_bubble, "> 冒泡", "Emotes+")
	src.emote("bubble", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_pop, "> 啵", "Emotes+")
	src.emote("pop", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_meow, "> 喵", "Emotes+")
	src.emote("meow", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_hiss1, "> 嘶嘶", "Emotes+")
	src.emote("hiss", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_chitter, "> 愉快啾鸣", "Emotes+")
	src.emote("chitter", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_snore, "> 打鼾", "Emotes+")
	src.emote("snore", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_clap, "> 鼓掌", "Emotes+")
	src.emote("clap", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_clap1, "> 拍一下手", "Emotes+")
	src.emote("clap1", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_headtilt, "~ 侧头", "Emotes+")
	src.emote("tilt", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_blink2, "~ 眨眼两次", "Emotes+")
	src.emote("blink2", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_rblink, "~ 快速眨眼", "Emotes+")
	src.emote("rblink", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_squint, "~ 眯眼", "Emotes+")
	src.emote("squint", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_smirk, "~ 假笑", "Emotes+")
	src.emote("smirk", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_eyeroll, "~ 翻白眼", "Emotes+")
	src.emote("eyeroll", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_huff, "~ 哼气", "Emotes+")
	src.emote("huffs", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_etwitch, "~ 抖耳", "Emotes+")
	src.emote("etwitch", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_clear, "~ 清嗓", "Emotes+")
	src.emote("clear", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_bawk, "> 咯咯鸡叫", "Emotes+")
	src.emote("bawk", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_caw, "> 呱叫", "Emotes+")
	src.emote("caw", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_caw2, "> 呱呱两声", "Emotes+")
	src.emote("caw2", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_whistle, "~ 吹口哨", "Emotes+")
	src.emote("whistle", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_blep, "~ 吐舌", "Emotes+")
	src.emote("blep", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_bork, "> 一声汪", "Emotes+")
	src.emote("bork", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_hoot, "> 枭鸣", "Emotes+")
	src.emote("hoot", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_growl, "> 低吼", "Emotes+")
	src.emote("growl", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_woof, "> 欢快汪叫", "Emotes+")
	src.emote("woof", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_baa, "> 咩", "Emotes+")
	src.emote("baa", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_baa2, "> 咩咩", "Emotes+")
	src.emote("baa2", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_wurble, "> 咕噜", "Emotes+")
	src.emote("wurble", intentional = TRUE)
GAME_VERB_PROC(/mob/living, emote_rattle, "> 咔哒响", "Emotes+")
	src.emote("rattle", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_cackle, "> 癫狂大笑", "Emotes+")
	src.emote("cackle", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_warble, "> 婉转鸣叫", "Emotes+")
	src.emote("warble", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_trills, "> 颤鸣", "Emotes+")
	src.emote("trills", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_rpurr, "> 猛禽呼噜", "Emotes+")
	src.emote("rpurr", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_purr, "> 呼噜", "Emotes+")
	src.emote("purr", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_moo, "> 欢快哞叫", "Emotes+")
	src.emote("moo", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_honk1, "> 大声鹅叫", "Emotes+")
	src.emote("honk1", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_mggaow, "> 大声喵", "Emotes+")
	src.emote("mggaow", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_mrrp, "> 咪噜", "Emotes+")
	src.emote("mrrp", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_prbt, "> 噗噜", "Emotes+")
	src.emote("prbt", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_awuff, "> 轻声汪", "Emotes+")
	src.emote("awuff", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_arf, "> 汪汪", "Emotes+")
	src.emote("arf", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_coyhowl, "> 郊狼嚎叫", "Emotes+")
	src.emote("coyhowl", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_wolfhowl, "> 狼嚎", "Emotes+")
	src.emote("wolfhowl", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_dwhine, "> 犬类哀鸣", "Emotes+")
	src.emote("dwhine", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_dgrowl, "> 犬类低吼", "Emotes+")
	src.emote("dgrowl", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_aggrobark, "> 凶狠吠叫", "Emotes+")
	src.emote("aggrobark", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_dcomplain, "> 犬类抱怨", "Emotes+")
	src.emote("dcomplain", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_meowdeep, "> 低沉喵", "Emotes+")
	src.emote("meowdeep", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_teshchirp, "> Tesh 啾鸣", "Emotes+")
	src.emote("teshchirp", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_teshsqueak, "> Tesh 吱鸣", "Emotes+")
	src.emote("teshsqueak", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_teshtrill, "> Tesh 颤鸣", "Emotes+")
	src.emote("teshtrill", intentional = TRUE)

// code\modules\mob\living\brain\emote.dm

GAME_VERB_PROC(/mob/living/brain, emote_alarm, "< 警报 >", "Emotes")
	src.emote("alarm", intentional = TRUE)

GAME_VERB_PROC(/mob/living/brain, emote_alert, "< 告急 >", "Emotes")
	src.emote("alert", intentional = TRUE)

GAME_VERB_PROC(/mob/living/brain, emote_flash, "< 闪灯 >", "Emotes")
	src.emote("flash", intentional = TRUE)

GAME_VERB_PROC(/mob/living/brain, emote_notice, "< 提示音 >", "Emotes")
	src.emote("notice", intentional = TRUE)

GAME_VERB_PROC(/mob/living/brain, emote_whistle_brain, "< 哨音 >", "Emotes")
	src.emote("whistle", intentional = TRUE)

// code\modules\mob\living\carbon\alien\emote.dm

GAME_VERB_PROC(/mob/living/carbon/alien, emote_gnarl, "< 龇牙 >", "Emotes")
	src.emote("gnarl", intentional = TRUE)

GAME_VERB_PROC(/mob/living/carbon/alien, emote_hiss, "< 嘶鸣 >", "Emotes")
	src.emote("hiss", intentional = TRUE)

GAME_VERB_PROC(/mob/living/carbon/alien, emote_roar, "< 咆哮 >", "Emotes")
	src.emote("roar", intentional = TRUE)

//modular_nova\modules\emotes\code\synth_emotes.dm

GAME_VERB_PROC(/mob/living, emote_dwoop, "< 欢快啾鸣 >", "Emotes")
	src.emote("dwoop", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_yes, "< 肯定音 >", "Emotes")
	src.emote("yes", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_no, "< 否定音 >", "Emotes")
	src.emote("no", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_boop, "< 嘟 >", "Emotes")
	src.emote("boop", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_buzz, "< 嗡鸣 >", "Emotes")
	src.emote("buzz", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_beep, "< 哔 >", "Emotes")
	src.emote("beep", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_beep2, "< 尖锐哔声 >", "Emotes")
	src.emote("beep2", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_buzz2, "< 两声嗡鸣 >", "Emotes")
	src.emote("buzz2", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_chime, "< 铃声 >", "Emotes")
	src.emote("chime", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_honk, "< 欢快鸣笛 >", "Emotes")
	src.emote("honk", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_ping, "< 叮 >", "Emotes")
	src.emote("ping", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_sad, "< 悲伤长号 >", "Emotes")
	src.emote("sad", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_warn, "< 警告鸣响 >", "Emotes")
	src.emote("warn", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_slowclap, "< 慢速鼓掌 >", "Emotes")
	src.emote("slowclap", intentional = TRUE)

// modular_nova\modules\emotes\code\additionalemotes\overlay_emote.dm
GAME_VERB_PROC(/mob/living, emote_sweatdrop, "| 汗滴 |", "Emotes+")
	src.emote("sweatdrop", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_exclaim, "| 感叹号 |", "Emotes+")
	src.emote("exclaim", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_question, "| 问号 |", "Emotes+")
	src.emote("question", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_realize, "| 恍然大悟 |", "Emotes+")
	src.emote("realize", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_annoyed, "| 恼怒 |", "Emotes+")
	src.emote("annoyed", intentional = TRUE)

GAME_VERB_PROC(/mob/living, emote_glasses, "| 推眼镜 |", "Emotes+")
	src.emote("glasses", intentional = TRUE)

//modular_nova\modules\emotes\code\additionalemotes\turf_emote.dm
GAME_VERB_PROC(/mob/living, emote_mark_turf, "| 标记地块 |", "Emotes+")
	src.emote("turf", intentional = TRUE)
