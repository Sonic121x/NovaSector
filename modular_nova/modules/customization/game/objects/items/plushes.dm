// Because plushes have a second desc var that needs to be updated
/obj/item/toy/plush/on_loadout_custom_described()
	normal_desc = desc

// // MODULAR PLUSHES
/obj/item/toy/plush/nova
	icon = 'modular_nova/master_files/icons/obj/plushes.dmi'
	inhand_icon_state = null

/obj/item/toy/plush/nova/borbplushie
	name = "圆滚滚鸟毛绒玩具"
	desc = "一个可爱的毛绒玩具，看起来像一只圆滚滚、毛茸茸的鸟。不要和他的朋友——小鸟毛绒玩具搞混了。"
	icon_state = "plushie_borb"
	attack_verb_continuous = list("pecks", "peeps")
	attack_verb_simple = list("peck", "peep")
	squeak_override = list('modular_nova/modules/emotes/sound/voice/peep_once.ogg' = 1)

/obj/item/toy/plush/nova/deer
	name = "鹿毛绒玩具"
	desc = "一个可爱的毛绒玩具，看起来像一只鹿。"
	icon_state = "plushie_deer"
	attack_verb_continuous = list("headbutts", "boops", "bapps", "bumps")
	attack_verb_simple = list("headbutt", "boop", "bap", "bump")
	squeak_override = list('modular_nova/modules/customization/game/objects/items/sound/deerplush.ogg' = 1)

/obj/item/toy/plush/nova/sechound
	name = "安保猎犬毛绒玩具"
	desc = "一个可爱的安保猎犬毛绒玩具，这是由纳米传讯赞助的可靠安保机器人！"
	icon_state = "plushie_securityk9"
	attack_verb_continuous = list("beeps", "boops", "pings")
	attack_verb_simple = list("beep", "boop", "ping")
	squeak_override = list('sound/machines/beep/beep.ogg' = 1)

/obj/item/toy/plush/nova/medihound
	name = "医疗猎犬毛绒玩具"
	desc = "一个可爱的医疗猎犬毛绒玩具。"
	icon_state = "plushie_medihound"
	attack_verb_continuous = list("beeps", "boops", "pings")
	attack_verb_simple = list("beep", "boop", "ping")
	squeak_override = list('sound/machines/beep/beep.ogg' = 1)

/obj/item/toy/plush/nova/engihound
	name = "工程猎犬毛绒玩具"
	desc = "一个可爱的工程猎犬毛绒玩具。"
	icon_state = "plushie_engihound"
	attack_verb_continuous = list("beeps", "boops", "pings")
	attack_verb_simple = list("beep", "boop", "ping")
	squeak_override = list('sound/machines/beep/beep.ogg' = 1)

/obj/item/toy/plush/nova/scrubpuppy
	name = "清洁小狗毛绒玩具"
	desc = "一个可爱的清洁小狗毛绒玩具，这是辛勤工作、保持空间站清洁的小狗！"
	icon_state = "plushie_scrubpuppy"
	attack_verb_continuous = list("beeps", "boops", "pings")
	attack_verb_simple = list("beep", "boop", "ping")
	squeak_override = list('sound/machines/beep/beep.ogg' = 1)

/obj/item/toy/plush/nova/meddrake
	name = "医疗龙兽毛绒玩具"
	desc = "一个可爱的医疗龙兽毛绒玩具。"
	icon_state = "plushie_meddrake"
	attack_verb_continuous = list("beeps", "boops", "pings")
	attack_verb_simple = list("beep", "boop", "ping")
	squeak_override = list('sound/machines/beep/beep.ogg' = 1)

/obj/item/toy/plush/nova/secdrake
	name = "安保龙兽毛绒玩具"
	desc = "一个可爱的安保龙玩偶。"
	icon_state = "plushie_secdrake"
	attack_verb_continuous = list("beeps", "boops", "pings")
	attack_verb_simple = list("beep", "boop", "ping")
	squeak_override = list('sound/machines/beep/beep.ogg' = 1)

/obj/item/toy/plush/nova/fox
	name = "狐狸玩偶"
	desc = "一个可爱的狐狸玩偶。"
	icon_state = "plushie_fox"
	attack_verb_continuous = list("geckers", "boops", "nuzzles")
	attack_verb_simple = list("gecker", "boop", "nuzzle")
	squeak_override = list('modular_nova/modules/customization/game/objects/items/sound/deerplush.ogg' = 1)

/obj/item/toy/plush/nova/ian
	name = "柯基犬玩偶"
	desc = "一个可爱的柯基犬玩偶！你难道不想抱抱它、捏捏它，然后叫它“伊恩”吗？"
	icon_state = "ianplushie"
	attack_verb_continuous = list("barks", "woofs", "wags his tail at")
	attack_verb_simple = list("lick", "nuzzle", "bite")
	squeak_override = list('modular_nova/modules/emotes/sound/voice/bark2.ogg' = 1)
	young = TRUE //No.

/obj/item/toy/plush/nova/ian/small
	name = "小型柯基犬玩偶"
	desc = "一个可爱的柯基犬玩偶！你难道不想抱抱它、捏捏它，然后叫它“伊恩”吗？"
	icon_state = "corgi"

/obj/item/toy/plush/nova/ian/lisa
	name = "少女风柯基犬玩偶"
	desc = "一个可爱的柯基犬玩偶！你难道不想抱抱它、捏捏它，然后叫它“丽莎”吗？"
	icon_state = "girlycorgi"
	attack_verb_continuous = list("barks", "woofs", "wags her tail at")
	gender = FEMALE

/obj/item/toy/plush/nova/cat
	name = "猫咪玩偶"
	desc = "一个有着黑色小圆眼睛的小猫咪玩偶。"
	icon_state = "blackcat"
	attack_verb_continuous = list("cuddles", "meows", "hisses")
	attack_verb_simple = list("cuddle", "meow", "hiss")
	squeak_override = list('modular_nova/modules/customization/game/objects/items/sound/merowr.ogg' = 1)

/obj/item/toy/plush/nova/cat/tux
	name = "燕尾服猫咪玩偶"
	icon_state = "tuxedocat"

/obj/item/toy/plush/nova/cat/white
	name = "白色猫咪玩偶"
	icon_state = "whitecat"

/obj/item/toy/plush/lizard_plushie
	squeak_override = list('modular_nova/modules/emotes/sound/voice/weh.ogg' = 1)

/obj/item/toy/plush/nova/funniyellowrock
	name = "软乎乎的黄色石头"
	desc = "一个看起来很眼熟的黄色石头玩偶。摸它应该不会让你化为灰烬。大概吧。"
	icon_state = "plush_sm"
	squeak_override = list('sound/machines/sm/accent/delam/1.ogg' = 1)

/obj/item/toy/plush/nova/fkinbnuuy
	name = "可恶的兔兔"
	desc = "一个有着黑色小圆眼睛的小兔子玩偶。名牌上的名字好像拼错了？"
	icon_state = "plush_bnuuy"
	attack_verb_continuous = list("cuddles", "squeaks")
	attack_verb_simple = list("cuddle", "squeak")
	squeak_override = list('modular_nova/modules/customization/game/objects/items/sound/deerplush.ogg' = 1)

/obj/item/toy/plush/nova/securifox
	name = "安保狐思乐冰"
	desc = "一个印有NT安保标志的狐狸玩偶。等等。如果它不止一条尾巴，那它不就是妖狐了吗？而且它为什么看起来这么得意？"
	icon_state = "plush_dee"
	attack_verb_continuous = list("geckers", "boops", "nuzzles")
	attack_verb_simple = list("gecker", "boop", "nuzzle")
	squeak_override = list('sound/vehicles/mecha/justice_shield_broken.ogg' = 1)

/obj/item/toy/plush/nova/towa
	name = "小小监视者"
	desc = "当情况危急时，知道它在身边总能唤起一种特别的慰藉。"
	icon_state = "plush_towa"
	attack_verb_continuous = list("cuddles", "meows", "hisses")
	attack_verb_simple = list("cuddle", "meow", "hiss")
	squeak_override = list('modular_nova/modules/kahraman_equipment/sound/thumper_thump/punch_press_2.wav' = 1)

/obj/item/toy/plush/nova/fushi
	name = "毛茸茸的龙"
	desc = "一个相当可爱的软绵绵的龙玩偶，看起来毛茸茸的。"
	icon_state = "plush_fushi_hat"
	attack_verb_continuous = list("cuddles", "nuzzles", "pats")
	attack_verb_simple = list("cuddle", "nuzzle", "pat")
	squeak_override = list(
		'modular_nova/modules/emotes/sound/voice/wurble.ogg' = 10, //10% chance to wurble
		'modular_nova/modules/emotes/sound/voice/weh.ogg' = 90,
	)
	gender = MALE
	/// If TRUE, we are wearing our hat
	var/plushhat = TRUE

	///Sounds the plush makes when hitting something
	var/static/list/responses = list(
		"WEH.",
		"This isnt my office...",
		"Has anyone seen Ian?",
		"Weeeeehhhhhh!",
		"Don't take my hat!",
		"No I cant give you all access.",
		"How are you doing today?",
		"Careful with my tail!",
		"Command is being silly today.",
		"I used to be tiny you know.",
		"I'm not a Fushi, I'm a Plushi!",
		"Cuddle approved. Promotion pending.",
		"Paperwork is temporary. Fluff is eternal.",
		"I'm the HoP, Head of Pats",
		"I’m very busy being approachable.",
		"This is a safe workplace. Mostly.",
		"Tiny dragon, big responsibilities.",
		"You can pet me one more time",
	)
	///Emotes the plush makes when being petted
	var/static/list/responses_action = list(
		"wags his tail happily.",
		"nuzzles affectionately.",
		"purrs contentedly.",
		"does a little happy dance.",
	)

	COOLDOWN_DECLARE(fushi_cooldown)

/obj/item/toy/plush/nova/fushi/attack()
	. = ..()
	if(!COOLDOWN_FINISHED(src, fushi_cooldown))
		return
	say(pick(responses))
	COOLDOWN_START(src, fushi_cooldown, 3 SECONDS)

// controls the emotes and sound when interacted with
/obj/item/toy/plush/nova/fushi/attack_self(mob/user)
	visible_message("[src] [span_notice(pick(responses_action))]")
	if(!COOLDOWN_FINISHED(src, fushi_cooldown))
		return
	playsound(src, pick(squeak_override), 30)
	COOLDOWN_START(src, fushi_cooldown, 2 SECONDS)

// controls the hat toggle
/obj/item/toy/plush/nova/fushi/attack_self_secondary(mob/user)
	plushhat = !plushhat
	if(plushhat)
		say("My hat is back!")
	else
		say("Hey! That's my hat!")
	update_appearance(UPDATE_ICON_STATE)

/obj/item/toy/plush/nova/fushi/update_icon_state()
	if(plushhat)
		icon_state = initial(icon_state)
	else
		icon_state = "plush_fushi"
	return ..()

/obj/item/toy/plush/nova/expie
	name = "实验品玩偶"
	desc = "某种犬科动物的玩偶，它渴望在地雷上被引爆。"
	icon_state = "plushie_expie"
	attack_verb_continuous = list("whines at", "claws")
	attack_verb_simple = list("whine at", "claw")
