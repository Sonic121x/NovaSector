// don't produce a comment if the dice has less than this many sides
// so you don't have d1's and d4's constantly producing comments
#define MIN_SIDES_ALERT 5

///holding bag for dice
/obj/item/storage/dice
	name = "bag of dice"
	desc = "Contains all the luck you'll ever need."
	icon = 'icons/obj/toys/dice.dmi'
	icon_state = "dicebag"
	w_class = WEIGHT_CLASS_SMALL
	storage_type = /datum/storage/dice

/obj/item/storage/dice/PopulateContents()
	new /obj/item/dice/d4(src)
	new /obj/item/dice/d6(src)
	new /obj/item/dice/d8(src)
	new /obj/item/dice/d10(src)
	new /obj/item/dice/d12(src)
	new /obj/item/dice/d20(src)
	var/picked = pick(list(
		/obj/item/dice/d1,
		/obj/item/dice/d2,
		/obj/item/dice/fudge,
		/obj/item/dice/d6/space,
		/obj/item/dice/d00,
		/obj/item/dice/eightbd20,
		/obj/item/dice/fourdd6,
		/obj/item/dice/d100,
	))
	new picked(src)

/obj/item/storage/dice/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] is gambling with death! It looks like [user.p_theyre()] trying to commit suicide!"))
	return OXYLOSS

/obj/item/storage/dice/hazard/PopulateContents()
	new /obj/item/dice/d6(src)
	new /obj/item/dice/d6(src)
	new /obj/item/dice/d6(src)
	for(var/i in 1 to 2)
		if(prob(7))
			new /obj/item/dice/d6/ebony(src)
		else
			new /obj/item/dice/d6(src)

///this is a prototype for dice, for a real d6 use "/obj/item/dice/d6"
/obj/item/dice
	name = "die"
	desc = "一颗六面骰子。基础实用。"
	icon = 'icons/obj/toys/dice.dmi'
	icon_state = "d6"
	w_class = WEIGHT_CLASS_TINY
	var/sides = 6
	var/result = null
	var/list/special_faces = list() //entries should match up to sides var if used
	var/microwave_riggable = TRUE

	var/rigged = DICE_NOT_RIGGED
	var/rigged_value

/obj/item/dice/Initialize(mapload)
	. = ..()
	if(!result)
		result = roll(sides)
	update_appearance()

/obj/item/dice/attack_self(mob/user)
	diceroll(user, in_hand = TRUE)

/obj/item/dice/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	var/mob/thrown_by = throwingdatum?.get_thrower()
	if(istype(thrown_by))
		diceroll(thrown_by)
	return ..()

/obj/item/dice/proc/diceroll(mob/user, in_hand=FALSE)
	result = roll(sides)
	if(rigged != DICE_NOT_RIGGED && result != rigged_value)
		if(rigged == DICE_BASICALLY_RIGGED && prob(clamp(1/(sides - 1) * 100, 25, 80)))
			result = rigged_value
		else if(rigged == DICE_TOTALLY_RIGGED)
			result = rigged_value

	. = result
	playsound(src, 'sound/items/dice_roll.ogg', 50, TRUE)

	var/fake_result = roll(sides)//Daredevil isn't as good as he used to be
	var/comment = ""
	if(sides > MIN_SIDES_ALERT && result == 1)  // less comment spam
		comment = "Ouch, bad luck."
	if(sides == 20 && result == 20)
		comment = "NAT 20!"
	update_appearance()
	result = manipulate_result(result)
	if(special_faces.len == sides)
		comment = ""  // its not a number
		result = special_faces[result]
		if(!ISINTEGER(result))
			comment = special_faces[result]  // should be a str now

	if(in_hand) //Dice was rolled in someone's hand
		user.visible_message(
			span_notice("[user] 掷出了 [src]。它停在了 [result] 上。[comment]"),
			span_notice("你掷出了 [src]。它停在了 [result] 上。[comment]"),
			span_hear("你听到 [src] 滚动的声音，听起来像是 [fake_result]。"),
		)
	else
		visible_message(span_notice("[src] 滚动着停了下来，停在了 [result] 上。[comment]"))

	return .


/obj/item/dice/update_overlays()
	. = ..()
	. += "[icon_state]-[result]"

/obj/item/dice/microwave_act(obj/machinery/microwave/microwave_source, mob/microwaver, randomize_pixel_offset)
	if(microwave_riggable)
		rigged = DICE_BASICALLY_RIGGED
		rigged_value = result

	return ..() | COMPONENT_MICROWAVE_SUCCESS

/// A proc to modify the displayed result. (Does not affect what the icon_state is passed.)
/obj/item/dice/proc/manipulate_result(original)
	return original

/obj/item/dice/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] 正在与死亡赌博！看起来 [user.p_theyre()] 试图自杀！"))
	return OXYLOSS

/obj/item/dice/d1
	name = "d1"
	desc = "一颗只有一面的骰子。结果是确定的！"
	icon_state = "d1"
	sides = 1

/obj/item/dice/d2
	name = "d2"
	desc = "一颗有两面的骰子。硬币太没格调了！"
	icon_state = "d2"
	sides = 2

/obj/item/dice/d4
	name = "d4"
	desc = "一颗有四面的骰子。书呆子的铁蒺藜。"
	icon_state = "d4"
	sides = 4

/obj/item/dice/d4/Initialize(mapload)
	. = ..()
	// 1d4 damage
	AddComponent(/datum/component/caltrop, min_damage = 1, max_damage = 4)

/obj/item/dice/d6
	name = "d6"

/obj/item/dice/d6/ebony
	name = "乌木骰子"
	desc = "一个由致密黑木制成的六面骰子。握在手中感觉冰冷而沉重。"
	icon_state = "de6"
	microwave_riggable = FALSE // You can't melt wood in the microwave

/obj/item/dice/d6/space
	name = "空间方块"
	desc = "一个六面骰子。6 乘 255 乘 255 瓦片构成全部存在，将你受教育的愚蠢思想平方：2 不存在。"
	icon_state = "spaced6"

/obj/item/dice/d6/space/Initialize(mapload)
	. = ..()
	if(prob(10))
		name = "太空方块"

/obj/item/paper/guides/knucklebone
	name = "指骨骰子规则"
	default_raw_text = "How to play knucklebones<br>\
	<ul>\
	<li>Make two 3x3 grids right next to each other using anything you can find to mark the ground. I like using the bartenders hologram projector.</li>\
	<li>Take turns rolling the dice and moving the dice into one of the three rows on your 3x3 grid.</li>\
	<li>Your goal is to get the most points by putting die of the same number in the same row.</li>\
	<li>If you have two of the same die in the same row, you will add them together and then times the sum by two. Then add that to the rest of the die.</li>\
	<li>If you have three of the same die in the same row, you will do the same thing but times it by three.</li>\
	<li>But if your opponent places a die across from one of your rows, you must remove all die that are the same number.</li>\
	<li>For example, if you have two 5's and a 2 in a row and your opponent places a 5 in the same row you must remove the two 5's from that row.</li>\
	<li>Note that you do not multiply the die if they are in the same collum. Only if they are in the same row.</li>\
	<li>If you find it hard to tell whether it multiplies up and down or left and right, base it off the position of your opponents 3x3.</li>\
	<li>If their rows line up with your rows, those rows are the rows that will multiply your die</li>\
	<li>The game ends when one person fills up their 3x3. The other person does not get to roll the rest of their die.</li>\
	<li>The winner is decided by who gets the most points</li>\
	<li>Have fun!</li>\
	</ul>"
/obj/item/dice/fudge
	name = "fudge die"
	desc = "A die with six sides but only three results. Is this a plus or a minus? Your mind is drawing a blank..."
	sides = 3 //shhh
	icon_state = "fudge"
	special_faces = list("minus","blank" = "You aren't sure how to feel.","plus")

/obj/item/dice/d8
	name = "d8"
	desc = "A die with eight sides. It feels... lucky."
	icon_state = "d8"
	sides = 8

/obj/item/dice/d10
	name = "d10"
	desc = "A die with ten sides. Useful for percentages."
	icon_state = "d10"
	sides = 10

/obj/item/dice/d00
	name = "d00"
	desc = "A die with ten sides. Works better for d100 rolls than a golf ball."
	icon_state = "d00"
	sides = 10

/obj/item/dice/d00/manipulate_result(original)
	return (original - 1)*10  // 10, 20, 30, etc

/obj/item/dice/d12
	name = "d12"
	desc = "A die with twelve sides. There's an air of neglect about it."
	icon_state = "d12"
	sides = 12

/obj/item/dice/d20
	name = "d20"
	desc = "A die with twenty sides. The preferred die to throw at the GM."
	icon_state = "d20"
	sides = 20

/obj/item/dice/d100
	name = "d100"
	desc = "A die with one hundred sides! Probably not fairly weighted..."
	icon_state = "d100"
	w_class = WEIGHT_CLASS_SMALL
	sides = 100

/obj/item/dice/d100/Initialize(mapload)
	AddElement(/datum/element/update_icon_blocker)
	return ..()

/obj/item/dice/eightbd20
	name = "strange d20"
	desc = "A weird die with raised text printed on the faces. Everything's white on white so reading it is a struggle. What poor design!"
	icon_state = "8bd20"
	sides = 20
	special_faces = list("It is certain","It is decidedly so","Without a doubt","Yes, definitely","You may rely on it","As I see it, yes","Most likely","Outlook good","Yes","Signs point to yes","Reply hazy try again","Ask again later","Better not tell you now","Cannot predict now","Concentrate and ask again","Don't count on it","My reply is no","My sources say no","Outlook not so good","Very doubtful")

/obj/item/dice/eightbd20/Initialize(mapload)
	AddElement(/datum/element/update_icon_blocker)
	return ..()

/obj/item/dice/fourdd6
	name = "4d d6"
	desc = "A die that exists in four dimensional space. Properly interpreting them can only be done with the help of a mathematician, a physicist, and a priest."
	icon_state = "4dd6"
	sides = 48
	special_faces = list("Cube-Side: 1-1","Cube-Side: 1-2","Cube-Side: 1-3","Cube-Side: 1-4","Cube-Side: 1-5","Cube-Side: 1-6","Cube-Side: 2-1","Cube-Side: 2-2","Cube-Side: 2-3","Cube-Side: 2-4","Cube-Side: 2-5","Cube-Side: 2-6","Cube-Side: 3-1","Cube-Side: 3-2","Cube-Side: 3-3","Cube-Side: 3-4","Cube-Side: 3-5","Cube-Side: 3-6","Cube-Side: 4-1","Cube-Side: 4-2","Cube-Side: 4-3","Cube-Side: 4-4","Cube-Side: 4-5","Cube-Side: 4-6","Cube-Side: 5-1","Cube-Side: 5-2","Cube-Side: 5-3","Cube-Side: 5-4","Cube-Side: 5-5","Cube-Side: 5-6","Cube-Side: 6-1","Cube-Side: 6-2","Cube-Side: 6-3","Cube-Side: 6-4","Cube-Side: 6-5","Cube-Side: 6-6","Cube-Side: 7-1","Cube-Side: 7-2","Cube-Side: 7-3","Cube-Side: 7-4","Cube-Side: 7-5","Cube-Side: 7-6","Cube-Side: 8-1","Cube-Side: 8-2","Cube-Side: 8-3","Cube-Side: 8-4","Cube-Side: 8-5","Cube-Side: 8-6")

/obj/item/dice/fourdd6/Initialize(mapload)
	AddElement(/datum/element/update_icon_blocker)
	return ..()

// Die of fate stuff
/obj/item/dice/d20/fate
	name = "\improper 命运骰"
	desc = "A die with twenty sides. You can feel unearthly energies radiating from it. Using this might be VERY risky."
	icon_state = "d20"
	sides = 20
	microwave_riggable = FALSE
	var/reusable = TRUE
	var/used = FALSE
	/// So you can't roll the die 20 times in a second and stack a bunch of effects that might conflict
	COOLDOWN_DECLARE(roll_cd)

/obj/item/dice/d20/fate/one_use
	reusable = FALSE

/obj/item/dice/d20/fate/cursed
	name = "被诅咒的命运骰"
	desc = "一枚二十面骰。你觉得投掷这枚骰子真的是个非常糟糕的主意。"
	color = "#00BB00"

	rigged = DICE_TOTALLY_RIGGED
	rigged_value = 1

/obj/item/dice/d20/fate/cursed/one_use
	reusable = FALSE

/obj/item/dice/d20/fate/stealth
	name = "d20"
	desc = "一颗二十面的骰子。是向游戏主持人投掷的首选骰子。"

/obj/item/dice/d20/fate/stealth/one_use
	reusable = FALSE

/obj/item/dice/d20/fate/stealth/cursed
	rigged = DICE_TOTALLY_RIGGED
	rigged_value = 1

/obj/item/dice/d20/fate/stealth/cursed/one_use
	reusable = FALSE

/obj/item/dice/d20/fate/diceroll(mob/user, in_hand=FALSE)
	if(!COOLDOWN_FINISHED(src, roll_cd))
		to_chat(user, span_warning("等等，[src]还没跟上你上次的投掷结果！"))
		return

	. = ..()
	if(used)
		return

	if(!ishuman(user) || !user.mind || IS_WIZARD(user))
		to_chat(user, span_warning("你感觉这骰子的魔力仅限于普通人类！"))
		return

	if(!reusable)
		used = TRUE

	var/turf/selected_turf = get_turf(src)
	selected_turf.visible_message(span_userdanger("[src]短暂地闪烁了一下。"))

	addtimer(CALLBACK(src, PROC_REF(effect), user, .), 1 SECONDS)
	COOLDOWN_START(src, roll_cd, 2.5 SECONDS)

/obj/item/dice/d20/fate/equipped(mob/user, slot)
	. = ..()
	if(!ishuman(user) || !user.mind || IS_WIZARD(user))
		to_chat(user, span_warning("你感觉这骰子的魔力仅限于普通人类！你最好别碰它。"))
		user.dropItemToGround(src)


/obj/item/dice/d20/fate/proc/effect(mob/living/carbon/human/user,roll)
	var/turf/selected_turf = get_turf(src)
	switch(roll)
		if(1)
			//Dust
			selected_turf.visible_message(span_userdanger("[user]化成灰了！"))
			user.investigate_log("has been dusted by a die of fate.", INVESTIGATE_DEATHS)
			user.dust()
		if(2)
			//Death
			selected_turf.visible_message(span_userdanger("[user]突然死掉了！"))
			user.investigate_log("has been killed by a die of fate.", INVESTIGATE_DEATHS)
			user.death()
		if(3)
			//Swarm of creatures
			selected_turf.visible_message(span_userdanger("一群生物包围了[user]！"))
			for(var/direction in GLOB.alldirs)
				var/turf/stepped_turf = get_step(get_turf(user), direction)
				do_sparks(3, FALSE, stepped_turf)
				new /mob/living/basic/creature(stepped_turf)
		if(4)
			//Destroy Equipment
			selected_turf.visible_message(span_userdanger("[user]所有拿着的和穿着的东西都消失了!"))
			var/list/belongings = user.get_all_gear(NONE) //don't delete prosthetics or abstract items.
			QDEL_LIST(belongings)
		if(5)
			//Monkeying
			selected_turf.visible_message(span_userdanger("[user]转变成了一只猴子!"))
			user.monkeyize()
		if(6)
			//Cut speed
			selected_turf.visible_message(span_userdanger("[user]开始移动得更慢了！"))
			user.add_movespeed_modifier(/datum/movespeed_modifier/die_of_fate)
		if(7)
			//Throw
			selected_turf.visible_message(span_userdanger("无形的力量将[user]抛了出去！"))
			user.Stun(60)
			user.adjust_brute_loss(50)
			var/throw_dir = pick(GLOB.cardinals)
			var/atom/throw_target = get_edge_target_turf(user, throw_dir)
			user.throw_at(throw_target, 200, 4)
		if(8)
			//Fuel tank Explosion
			selected_turf.visible_message(span_userdanger("一场爆炸在[user]周围凭空出现！"))
			explosion(get_turf(user), devastation_range = -1, light_impact_range = 2, flame_range = 2, explosion_cause = src)
		if(9)
			//Cold
			var/datum/disease/cold = new /datum/disease/cold()
			selected_turf.visible_message(span_userdanger("[user]看起来有点不舒服！"))
			user.ForceContractDisease(cold, FALSE, TRUE)
		if(10)
			//Nothing
			selected_turf.visible_message(span_userdanger("似乎什么也没发生."))
		if(11)
			//Cookie
			selected_turf.visible_message(span_userdanger("在空中突然出现了一个曲奇！"))
			var/obj/item/food/cookie/ooh_a_cookie = new(drop_location())
			do_smoke(0, src, drop_location())
			ooh_a_cookie.name = "命运饼干"
		if(12)
			//Healing
			selected_turf.visible_message(span_userdanger("[user] 看起来非常健康！"))
			user.revive(ADMIN_HEAL_ALL)
		if(13)
			//Mad Dosh
			selected_turf.visible_message(span_userdanger("大量钞票从[src]中喷射而出！"))
			var/turf/Start = get_turf(src)
			for(var/direction in GLOB.alldirs)
				var/turf/dirturf = get_step(Start,direction)
				if(prob(50))
					new /obj/item/stack/spacecash/c1000(dirturf)
					continue
				var/obj/item/storage/bag/money/bag_money = new(dirturf)
				for(var/i in 1 to rand(5,50))
					new /obj/item/coin/gold(bag_money)
		if(14)
			//Free Gun
			selected_turf.visible_message(span_userdanger("一把令人印象深刻的枪出现了！"))
			do_smoke(0, src, drop_location())
			new /obj/item/gun/ballistic/revolver/mateba(drop_location())
		if(15)
			//Random One-use spellbook
			selected_turf.visible_message(span_userdanger("一本看起来充满魔法的书掉在了地上！"))
			do_smoke(0, src, drop_location())
			new /obj/item/book/granter/action/spell/random(drop_location())
		if(16)
			//Servant & Servant Summon
			selected_turf.visible_message(span_userdanger("[user] 因新获得的魔法力量而泛起涟漪！"))
			var/datum/action/cooldown/spell/summon_mob/dice/summon_servant = new(user.mind || user)
			summon_servant.Grant(user)
		if(17)
			//Tator Kit
			selected_turf.visible_message(span_userdanger("出现了一个可疑的盒子！"))
			new /obj/item/storage/box/syndicate/bundle_a(drop_location())
			do_smoke(0, src, drop_location())
		if(18)
			//Captain ID
			selected_turf.visible_message(span_userdanger("一张金色的ID卡出现了！"))
			new /obj/item/card/id/advanced/gold/captains_spare(drop_location())
			do_smoke(0, src, drop_location())
		if(19)
			//Instrinct Resistance
			selected_turf.visible_message(span_userdanger("[user]看起来非常强健!"))
			user.physiology.brute_mod *= 0.5
			user.physiology.burn_mod *= 0.5

		if(20)
			//Free wizard!
			selected_turf.visible_message(span_userdanger("魔力从[src]流出，涌入[user]！"))
			user.mind.make_wizard()

#undef MIN_SIDES_ALERT
