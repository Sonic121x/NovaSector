/obj/item/smelling_salts
	name = "嗅盐"
	desc = "一小堆盐状物质，气味极其难闻。传闻其气味如此刺鼻，甚至连死者都会复活以逃离它。"
	icon_state = "smelling_salts"
	icon = 'modular_nova/modules/primitive_catgirls/icons/salts.dmi'
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	item_flags = NOBLUDGEON

/obj/item/smelling_salts/attack(mob/living/mob_attacked, mob/user)
	. = ..()
	if(!iscarbon(mob_attacked))
		to_chat(user, span_warning("转念一想，也许[src]对[mob_attacked]不起作用。"))
		return

	if(mob_attacked == user)
		to_chat(user, span_warning("你无法让自己把[src]靠近你的脸。"))
		return

	if(mob_attacked.stat != DEAD)
		to_chat(user, span_warning("转念一想，也许你不应该在[mob_attacked]并非<b>死亡</b>状态时使用这个。"))
		return

	try_revive(mob_attacked, user)

/// If the right conditions are present (basically could this person be defibrilated), revives the target
/obj/item/smelling_salts/proc/try_revive(mob/living/carbon/carbon_target, mob/user)
	carbon_target.notify_revival("You are being brought back to life!")
	carbon_target.grab_ghost()

	user.balloon_alert_to_viewers("trying to revive [carbon_target]")

	if(!do_after(user, 3 SECONDS, carbon_target))
		user.balloon_alert(user, "停止复苏[carbon_target]")
		return

	if(carbon_target.stat != DEAD)
		to_chat(user, span_warning("等等，[carbon_target]实际上并没有<b>死亡</b>！"))
		return

	var/defib_result = carbon_target.can_defib()
	var/fail_reason

	switch (defib_result)
		if (DEFIB_FAIL_SUICIDE, DEFIB_FAIL_DNR, DEFIB_FAIL_BLACKLISTED, DEFIB_FAIL_NO_INTELLIGENCE)
			fail_reason = "[carbon_target] doesn't respond at all... You don't think they're coming back."
		if (DEFIB_FAIL_NO_HEART, DEFIB_FAIL_FAILING_HEART, DEFIB_FAIL_FAILING_BRAIN)
			fail_reason = "[carbon_target] seems to respond just a little, but something you can't see must be wrong about them..."
		if (DEFIB_FAIL_TISSUE_DAMAGE, DEFIB_FAIL_HUSK)
			fail_reason = "[carbon_target]'s body seems way too damaged for this to work..."
		if (DEFIB_FAIL_NO_BRAIN)
			fail_reason = "[carbon_target]'s head looks like it's missing something important."

	if(carbon_target.health <= HEALTH_THRESHOLD_FULLCRIT)
		fail_reason = "[carbon_target]'s body seems just a little too damaged for this to work..."

	if(fail_reason)
		to_chat(user, span_boldwarning("[fail_reason]"))
		return

	carbon_target.adjust_oxy_loss(amount = 60, updating_health = TRUE)
	if(carbon_target.gender == MALE)
		playsound(src, 'sound/mobs/humanoids/human/sniff/male_sniff.ogg', 50, FALSE)
	else
		playsound(src, 'sound/mobs/humanoids/human/sniff/female_sniff.ogg', 50, FALSE)
	carbon_target.set_heartattack(FALSE)

	if(defib_result == DEFIB_POSSIBLE)
		carbon_target.grab_ghost()

	carbon_target.revive()
	to_chat(carbon_target, span_userdanger("[CONFIG_GET(string/blackoutpolicy)]"))
	log_combat(user, carbon_target, "revived", src)
