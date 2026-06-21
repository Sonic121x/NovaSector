#define DEFAULT_MAX_CURSE_COUNT 5

/// Status effect that gives the target miscellanous debuffs while throwing a status alert and causing them to smoke from the damage they're incurring.
/// Purposebuilt for cursed slot machines.
/datum/status_effect/slot_machine_curse
	id = "cursed"
	alert_type = /atom/movable/screen/alert/status_effect/cursed
	remove_on_fullheal = TRUE
	heal_flag_necessary = HEAL_ADMIN
	/// The max number of curses a target can incur with this status effect.
	var/max_curse_count = DEFAULT_MAX_CURSE_COUNT
	/// The amount of times we have been "applied" to the target.
	var/curse_count = 0
	/// Raw probability we have to deal damage this tick.
	var/damage_chance = 10
	/// Are we currently in the process of sending a monologue?
	var/monologuing = FALSE
	/// The hand we are branded to.
	var/obj/item/bodypart/branded_hand = null
	/// The cached path of the particles we're using to smoke
	var/smoke_path = null

/datum/status_effect/slot_machine_curse/on_apply()
	RegisterSignal(owner, COMSIG_MOB_STATCHANGE, PROC_REF(on_stat_changed))
	RegisterSignal(owner, COMSIG_LIVING_DEATH, PROC_REF(on_death))
	RegisterSignal(owner, COMSIG_CURSED_SLOT_MACHINE_USE, PROC_REF(check_curses))
	RegisterSignal(owner, COMSIG_CURSED_SLOT_MACHINE_LOST, PROC_REF(update_curse_count))
	RegisterSignal(SSdcs, COMSIG_GLOB_CURSED_SLOT_MACHINE_WON, PROC_REF(clear_curses))
	return ..()

/datum/status_effect/slot_machine_curse/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_CURSED_SLOT_MACHINE_WON)
	branded_hand = null
	if (smoke_path)
		owner.remove_shared_particles(smoke_path)
	return ..()

/// Checks the number of curses we have and returns information back to the slot machine. `max_curse_amount` is set by the slot machine itself.
/datum/status_effect/slot_machine_curse/proc/check_curses(mob/user, max_curse_amount)
	SIGNAL_HANDLER
	if(curse_count >= max_curse_amount)
		return SLOT_MACHINE_USE_CANCEL

	if(monologuing)
		to_chat(owner, span_warning("你的手臂在抗拒你拉动拉杆的尝试！")) // listening to kitschy monologues to postpone your powergaming is the true curse here.
		return SLOT_MACHINE_USE_POSTPONE

/// Handles the debuffs of this status effect and incrementing the number of curses we have.
/datum/status_effect/slot_machine_curse/proc/update_curse_count()
	SIGNAL_HANDLER
	curse_count++

	linked_alert?.update_appearance() // we may have not initialized it yet

	addtimer(CALLBACK(src, PROC_REF(handle_after_effects), 1 SECONDS)) // give it a second to let the failure sink in before we exact our toll

/// Makes a nice lorey message about the curse level we're at. I think it's nice
/datum/status_effect/slot_machine_curse/proc/handle_after_effects()
	if(QDELETED(src))
		return

	monologuing = TRUE
	var/list/messages = list()
	switch(curse_count)
		if(1) // basically your first is a "freebie" that will still require urgent medical attention and will leave you smoking forever but could be worse tbh
			if(ishuman(owner))
				var/mob/living/carbon/human/human_owner = owner
				playsound(human_owner, SFX_SEAR, 50, TRUE)
				var/obj/item/bodypart/affecting = human_owner.get_active_hand()
				branded_hand = affecting
				affecting.force_wound_upwards(/datum/wound/burn/flesh/severe/cursed_brand, wound_source = "curse of the slot machine")

			messages += span_boldwarning("你的手灼痛起来，你迅速松开了拉杆！随着手部神经坏死，你感到一阵恶心...")
			messages += span_boldwarning("你的手现在似乎在冒烟，但情况还不算太糟...")
			messages += span_boldwarning("这该死的蠢机器。")

		if(2)
			messages += span_boldwarning("这次机器没有灼伤你，一定是烙印识别了某种来源的某种奥术作用...")
			messages += span_boldwarning("水泡和脓疮开始在你的皮肤上浮现。每一个都从自己的囊袋中嘶嘶冒出滚烫的蒸汽...")
			messages += span_boldwarning("你明白了，这台机器用它那简单的诱惑折磨着你。它随时可以杀死你，但它却病态地满足于强迫你继续下去。")
			messages += span_boldwarning("如果你能离开这里，或许还能靠医疗用品活下去。现在停下来还来得及吗？")
			messages += span_boldwarning("当你闭上眼睛思考这个难题时，烙印剧痛起来。想到如果你失去意识可能会发生什么，你不寒而栗。")

		if(3)
			owner.emote("cough")
			messages += span_boldwarning("你的喉咙开始感觉像在慢慢被沙尘堵塞。你把喉咙后部的东西咳到了袖子上。")
			messages += span_boldwarning("那是沙子。深红色的沙子。你一生中从未感到如此口渴，但你却不相信自己的手能把水杯送到唇边。")
			messages += span_boldwarning("你隐约觉得，如果别人赢了，或许也能解除你的诅咒。拯救你的生命是个高尚的理由。")
			messages += span_boldwarning("当然，你可能不能透露这台机器的本质，以防他们吓得跑掉，留你等死。")
			messages += span_boldwarning("为了治愈你自己享乐欲望的具现化，而将某人推入这种命运，这真的值得吗？你必须尽快做出决定。")

		if(4)
			messages += span_boldwarning("一阵偏头痛在你头顶肿胀，你的思绪变得模糊。你的手绝望地一寸寸靠近老虎机，准备进行最后一次拉动……")
			messages += span_boldwarning("这是意志对物质的终极考验。你可以猛地抽回自己的肌肉以避免可怕的命运，但你的生命此刻已经如此廉价。")
			messages += span_boldwarning("这不正是他们想要的吗？见证你败给自己？强迫感驱使你向前，一种沉沦的恐惧感充满了你的胃。")
			messages += span_boldwarning("矛盾的是，绝望之处，亦有狂喜。狂喜于你体内仍有足够的力量进行最后一次拉动。")
			messages += span_boldwarning("你的双腿在逃跑的念头下渴望猛地跳开，但你自己的手臂却安于观看转轮旋转的想法。")
			messages += span_userdanger("The toll has already been exacted. There is no longer death on 'your' terms. Is your dignity worth more than your life?")

		if(5 to INFINITY)
			if(max_curse_count != DEFAULT_MAX_CURSE_COUNT) // this probably will only happen through admin schenanigans letting people stack up infinite curses or something
				to_chat(owner, span_boldwarning("你<i>还</i>认为自己掌控着一切吗？"))
				return

			to_chat(owner, span_userdanger("为什么我就不能再试一次？！"))
			owner.investigate_log("has been gibbed by the cursed status effect after accumulating [curse_count] curses.", INVESTIGATE_DEATHS)
			owner.gib(DROP_ALL_REMAINS)
			qdel(src)
			return

	for(var/message in messages)
		to_chat(owner, message)
		sleep(1.5 SECONDS) // yes yes a bit fast but it can be a lot of text and i want the whole thing to send before the cooldown on the slot machine might expire
	monologuing = FALSE

/// Cleans ourselves up and removes our curses. Meant to be done in a "positive" way, when the curse is broken. Directly use qdel otherwise.
/datum/status_effect/slot_machine_curse/proc/clear_curses()
	SIGNAL_HANDLER

	if(!isnull(branded_hand))
		var/datum/wound/brand = branded_hand.get_wound_type(/datum/wound/burn/flesh/severe/cursed_brand)
		brand?.remove_wound()

	owner.visible_message(
		span_notice("烟雾缓缓从[owner.name]身上散去……"),
		span_notice("你的皮肤终于平复下来，喉咙也不再感觉那么干燥……烙印的消失证实诅咒已被解除。"),
	)
	qdel(src)

/// If our owner's stat changes, rapidly surge the damage chance.
/datum/status_effect/slot_machine_curse/proc/on_stat_changed()
	SIGNAL_HANDLER
	if(owner.stat == CONSCIOUS || owner.stat == DEAD) // reset on these two states
		damage_chance = initial(damage_chance)
		return

	to_chat(owner, span_userdanger("当你的身体崩溃时，你感到老虎机的诅咒在你体内奔涌！"))
	damage_chance += 75 //ruh roh raggy

/// If our owner dies without getting gibbed (as in of other causes), stop smoking because we've "expended all the life energy".
/datum/status_effect/slot_machine_curse/proc/on_death(mob/living/source, gibbed)
	SIGNAL_HANDLER

	if(!gibbed && smoke_path)
		owner.remove_shared_particles(smoke_path)

/datum/status_effect/slot_machine_curse/update_particles()
	var/particle_path = /particles/smoke/steam/mild
	switch(curse_count)
		if(2 to 3)
			particle_path = /particles/smoke/steam
		if(4 to INFINITY)
			particle_path = /particles/smoke/steam/bad

	if(smoke_path == particle_path)
		return

	if (smoke_path)
		owner.remove_shared_particles(smoke_path)
	owner.add_shared_particles(particle_path)
	smoke_path = particle_path

/datum/status_effect/slot_machine_curse/tick(seconds_between_ticks)
	if(curse_count <= 1)
		return // you get one "freebie" (single damage) to nudge you into thinking this is a bad idea before the house begins to win.

	// the house won.
	var/ticked_coefficient = (rand(15, 40) / 100)
	var/effective_percentile_chance = ((curse_count == 2 ? 1 : curse_count) * damage_chance * ticked_coefficient)

	if(SPT_PROB(effective_percentile_chance, seconds_between_ticks))
		owner.apply_damages(
			brute = (curse_count * ticked_coefficient),
			burn = (curse_count * ticked_coefficient),
			oxy = (curse_count * ticked_coefficient),
		)

/atom/movable/screen/alert/status_effect/cursed
	name = "被诅咒了！"
	desc = "手上的烙印提醒着你的贪婪，不过除此之外你似乎还好。"
	use_user_hud_icon = USER_HUD_STYLE_INHERIT
	overlay_state = "cursed_by_slots"

/atom/movable/screen/alert/status_effect/cursed/update_desc()
	. = ..()
	var/datum/status_effect/slot_machine_curse/linked_effect = attached_effect
	var/curses = linked_effect?.curse_count
	switch(curses)
		if(2)
			desc = "你的贪婪正在追上你……"
		if(3)
			desc = "你现在感觉真的很不好……但为什么要现在停下呢？"
		if(4 to INFINITY)
			desc = "真正的赢家会在触及终极奖励前收手。"

#undef DEFAULT_MAX_CURSE_COUNT
