// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
GLOBAL_LIST_INIT(blacklisted_borg_hats, typecacheof(list( //Hats that don't really work on borgos
	/obj/item/clothing/head/helmet/space,
	/obj/item/clothing/head/utility/welding,
	/obj/item/clothing/head/chameleon/broken \
	)))

/mob/living/silicon/robot/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(is_wire_tool(tool, check_secured = TRUE))
		if(wiresexposed)
			wires.interact(user)
			return ITEM_INTERACT_SUCCESS
		if(user.combat_mode)
			return ITEM_INTERACT_SKIP_TO_ATTACK

		balloon_alert(user, LANG("mob.694e832f7ede26f0", null))
		return ITEM_INTERACT_BLOCKING

	if(istype(tool, /obj/item/stack/cable_coil))
		if(!wiresexposed)
			balloon_alert(user, LANG("mob.694e832f7ede26f0", null))
			return ITEM_INTERACT_BLOCKING
		var/obj/item/stack/cable_coil/coil = tool
		if (get_fire_loss() <= 0)
			balloon_alert(user, LANG("mob.2377919e4277419d", null))
			return ITEM_INTERACT_BLOCKING
		if(src == user)
			balloon_alert(user, LANG("mob.adb3f7e826dc35cd", null))
			if(!do_after(user, 5 SECONDS, target = src))
				return ITEM_INTERACT_BLOCKING
		if (!coil.use(1))
			balloon_alert(user, LANG("mob.981fab36878cf703", null))
			return ITEM_INTERACT_BLOCKING
		adjust_fire_loss(-30)
		playsound(src, 'sound/items/deconstruct.ogg', 50, TRUE)
		balloon_alert(user, LANG("mob.ca562adaaf856554", null))
		user.visible_message(
			span_notice(LANG("mob.c9492a0ac77f2bba", list(user, src))),
			span_notice(LANG("mob.7dfaf6a1148c2b9d", list(src))),
			visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
		)
		user.changeNext_move(CLICK_CD_MELEE)
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/stock_parts/power_store/cell) && opened) // trying to put a cell inside
		if(wiresexposed)
			balloon_alert(user, LANG("mob.68266e0feb2c9177", null))
			return ITEM_INTERACT_BLOCKING
		if(cell)
			balloon_alert(user, LANG("mob.62f73cd529e01ae3", null))
			return ITEM_INTERACT_BLOCKING
		if(!user.transferItemToLoc(tool, src))
			return ITEM_INTERACT_BLOCKING
		cell = tool
		balloon_alert(user, LANG("mob.9dcbef06e4056599", null))
		update_icons()
		diag_hud_set_borgcell()
		return ITEM_INTERACT_SUCCESS

	if((tool.slot_flags & ITEM_SLOT_HEAD) \
		&& hat_offset != INFINITY \
		&& !user.combat_mode \
		&& !is_type_in_typecache(tool, GLOB.blacklisted_borg_hats))
		if(user == src)
			balloon_alert(user, LANG("mob.e9e8510ab10c9f91", null))
			return ITEM_INTERACT_BLOCKING
		if(hat && HAS_TRAIT(hat, TRAIT_NODROP))
			balloon_alert(user, LANG("mob.97e9c2b0d510ce42", null))
			return ITEM_INTERACT_BLOCKING
		balloon_alert(user, LANG("mob.589d880fec45ff1b", null))
		user.visible_message(
			span_notice(LANG("mob.78c9d4c59be251bb", list(user, tool, src))),
			span_notice(LANG("mob.98caad4a34872fb3", list(tool, src))),
			visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
		)
		if(!do_after(user, 3 SECONDS, target = src))
			return ITEM_INTERACT_BLOCKING
		if(hat && HAS_TRAIT(hat, TRAIT_NODROP))
			balloon_alert(user, LANG("mob.97e9c2b0d510ce42", null))
			return ITEM_INTERACT_BLOCKING
		if(!user.temporarilyRemoveItemFromInventory(tool))
			return ITEM_INTERACT_BLOCKING
		balloon_alert(user, LANG("mob.c861276a4d367814", null))
		place_on_head(tool)
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/defibrillator) && !user.combat_mode)
		if(!opened)
			balloon_alert(user, LANG("mob.da8259d51e86848b", null))
			return ITEM_INTERACT_BLOCKING
		if(!istype(model, /obj/item/robot_model/medical))
			balloon_alert(user, LANG("mob.857e69c859621b2f", null))
			return ITEM_INTERACT_BLOCKING
		if(stat == DEAD)
			balloon_alert(user, LANG("mob.5f159f3d51512a3c", null))
			return ITEM_INTERACT_BLOCKING
		var/obj/item/defibrillator/defib = tool
		if(!(defib.slot_flags & ITEM_SLOT_BACK)) //belt defibs need not apply
			balloon_alert(user, LANG("mob.7f1af0164989b57e", null))
			return ITEM_INTERACT_BLOCKING
		if(defib.get_cell())
			balloon_alert(user, LANG("mob.015b58c15bd12772", list(tool)))
			return ITEM_INTERACT_BLOCKING
		if(locate(/obj/item/borg/upgrade/defib) in src)
			balloon_alert(user, LANG("mob.8c5c9fb03a1b7d2c", null))
			return ITEM_INTERACT_BLOCKING
		var/obj/item/borg/upgrade/defib/backpack/defib_upgrade = new(null, defib)
		if(apply_upgrade(defib_upgrade, user))
			balloon_alert(user, LANG("mob.1466534a77445dfa", null))
			return ITEM_INTERACT_SUCCESS
		return ITEM_INTERACT_BLOCKING

	if(istype(tool, /obj/item/storage/part_replacer))
		var/obj/item/storage/part_replacer/replacer = tool
		if(!opened)
			balloon_alert(user, LANG("mob.da8259d51e86848b", null))
			return ITEM_INTERACT_BLOCKING
		if(!istype(model, /obj/item/robot_model/engineering))
			balloon_alert(user, LANG("mob.857e69c859621b2f", null))
			return ITEM_INTERACT_BLOCKING
		if(locate(/obj/item/borg/upgrade/rped) in src)
			balloon_alert(user, LANG("mob.0d09d4a09d631c4f", null))
			return ITEM_INTERACT_BLOCKING
		qdel(tool)
		var/obj/item/borg/upgrade/smallrped/lilrped = new
		if(apply_upgrade(lilrped, user))
			balloon_alert(user, LANG("mob.7bd56e79b809f32a", list(replacer)))
			return ITEM_INTERACT_SUCCESS
		return ITEM_INTERACT_BLOCKING

	if(istype(tool, /obj/item/encryptionkey) && opened)
		if(radio)
			return radio.item_interaction(user, tool)

		balloon_alert(user, LANG("mob.9a5cb2614a14ac8b", null))
		return ITEM_INTERACT_BLOCKING

	if(istype(tool, /obj/item/borg/upgrade))
		if(!opened)
			balloon_alert(user, LANG("mob.da8259d51e86848b", null))
			return ITEM_INTERACT_BLOCKING
		var/obj/item/borg/upgrade/upgrade = tool
		if(!model && upgrade.require_model)
			balloon_alert(user, LANG("mob.73dc71c04a6a758a", null))
			return ITEM_INTERACT_BLOCKING
		if(upgrade.locked)
			balloon_alert(user, LANG("mob.294c663a2653c001", null))
			return ITEM_INTERACT_BLOCKING
		if(apply_upgrade(upgrade, user))
			balloon_alert(user, LANG("mob.aabb4585e5f16304", null))
			return ITEM_INTERACT_SUCCESS
		return ITEM_INTERACT_BLOCKING

	if(istype(tool, /obj/item/toner))
		if(toner >= tonermax)
			balloon_alert(user, LANG("mob.b0ad310ad7559fb9", null))
			return ITEM_INTERACT_BLOCKING
		if(!user.transferItemToLoc(tool, src))
			return ITEM_INTERACT_BLOCKING
		toner = tonermax
		qdel(tool)
		balloon_alert(user, LANG("mob.94c8f86bb28f215b", null))
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/flashlight) && !istype(tool, /obj/item/flashlight/emp)) //subtypes my behated. OOP was a dumb idea
		if(user.combat_mode)
			return NONE
		if(!opened)
			balloon_alert(user, LANG("mob.02085ff13a098b37", null))
			return ITEM_INTERACT_BLOCKING
		if(lamp_functional)
			balloon_alert(user, LANG("mob.9b06f6a2ff937cdf", null))
			return ITEM_INTERACT_BLOCKING
		if(!user.transferItemToLoc(tool, src))
			return ITEM_INTERACT_BLOCKING
		lamp_functional = TRUE
		qdel(tool)
		balloon_alert(user, LANG("mob.37c681fec3c053ea", null))
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/disk/computer))
		if(!modularInterface)
			stack_trace("Cyborg [src] ( [type] ) was somehow missing their integrated tablet. Please make a bug report.")
			create_modularInterface()
		return modularInterface.computer_disk_act(user, tool)

	return NONE

//Checks blockchance of any items in any module slots
/mob/living/silicon/robot/check_block(atom/hit_by, damage, attack_text = "the attack", attack_type = MELEE_ATTACK, armour_penetration = 0, damage_type = BRUTE)
	. = ..()
	if(. == SUCCESSFUL_BLOCK)
		return SUCCESSFUL_BLOCK

	var/block_chance_modifier = round(damage / -3)
	for(var/obj/item/module in held_items)
		var/final_block_chance = module.block_chance - (clamp((armour_penetration - module.armour_penetration) / 2, 0, 100)) + block_chance_modifier
		if(module.hit_reaction(src, hit_by, attack_text, final_block_chance, damage, attack_type, damage_type))
			return SUCCESSFUL_BLOCK

// This has to go at the very end of interaction so we don't block every interaction with ID-like items
/mob/living/silicon/robot/base_item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	. = ..()
	if(. || !tool.GetID())
		return
	if(opened)
		balloon_alert(user, LANG("mob.bc3a3c083aed7145", null))
		return ITEM_INTERACT_BLOCKING
	if(!allowed(user))
		balloon_alert(user, LANG("mob.1bd3ceeb3a56d0d5", null))
		return ITEM_INTERACT_BLOCKING
	toggle_cover(user)
	return ITEM_INTERACT_SUCCESS

#define LOW_DAMAGE_UPPER_BOUND 1/3
#define MODERATE_DAMAGE_UPPER_BOUND 2/3

/mob/living/silicon/robot/proc/update_damage_particles()
	var/brute_percent = bruteloss / maxHealth
	var/burn_percent = fireloss / maxHealth

	var/old_smoke = smoke_particles
	if (brute_percent > MODERATE_DAMAGE_UPPER_BOUND)
		smoke_particles = /particles/smoke/cyborg/heavy_damage
	else if (brute_percent > LOW_DAMAGE_UPPER_BOUND)
		smoke_particles = /particles/smoke/cyborg
	else
		smoke_particles = null

	if (old_smoke != smoke_particles)
		if (old_smoke)
			remove_shared_particles(old_smoke)
		if (smoke_particles)
			add_shared_particles(smoke_particles)

	var/old_sparks = spark_particles
	if (burn_percent > MODERATE_DAMAGE_UPPER_BOUND)
		spark_particles = /particles/embers/spark/severe
	else if (burn_percent > LOW_DAMAGE_UPPER_BOUND)
		spark_particles = /particles/embers/spark
	else
		spark_particles = null

	if (old_sparks != spark_particles)
		if (old_sparks)
			remove_shared_particles(old_sparks)
		if (spark_particles)
			add_shared_particles(spark_particles)


#undef LOW_DAMAGE_UPPER_BOUND
#undef MODERATE_DAMAGE_UPPER_BOUND

/mob/living/silicon/robot/attack_alien(mob/living/carbon/alien/adult/user, list/modifiers)
	if (!LAZYACCESS(modifiers, RIGHT_CLICK))
		return ..()
	if(body_position != STANDING_UP)
		return
	user.do_attack_animation(src, ATTACK_EFFECT_DISARM)
	var/obj/item/I = get_active_held_item()
	if(I)
		uneq_active()
		visible_message(span_danger(LANG("mob.a40152e8256a00c0", list(user, src))), \
			span_userdanger(LANG("mob.238dce0127e815c0", list(user, src))), null, COMBAT_MESSAGE_RANGE)
		log_combat(user, src, "disarmed", "[I ? " removing \the [I]" : ""]")
	else
		Stun(40)
		step(src,get_dir(user,src))
		visible_message(span_danger(LANG("mob.6658e3f6560ec37f", list(user, src))), \
			span_userdanger(LANG("mob.b12a5d15c6b925f2", list(user))), null, COMBAT_MESSAGE_RANGE)
		log_combat(user, src, "pushed")
	playsound(loc, 'sound/items/weapons/pierce.ogg', 50, TRUE, -1)

/mob/living/silicon/robot/attack_hand(mob/living/carbon/human/user, list/modifiers)
	add_fingerprint(user)
	if(!opened)
		return ..()
	if(!wiresexposed && !issilicon(user))
		if(!cell)
			return
		cell.add_fingerprint(user)
		balloon_alert(user, LANG("mob.0dfdca6e675f39e2", null))
		user.put_in_active_hand(cell)
		update_icons()
		diag_hud_set_borgcell()

/mob/living/silicon/robot/attack_hulk(mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return
	spark_system.start()
	step_away(src, user, 15)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(_step_away), src, get_turf(user), 15), 0.3 SECONDS)

/mob/living/silicon/robot/get_shove_flags(mob/living/shover, obj/item/weapon)
	. = ..()
	if(isnull(weapon) || IS_UNCONSCIOUS_OR_CRIT(src))
		. &= ~(SHOVE_CAN_MOVE|SHOVE_CAN_HIT_SOMETHING)

/mob/living/silicon/robot/welder_act(mob/living/user, obj/item/tool)
	if(user.combat_mode && user != src)
		return NONE

	user.changeNext_move(CLICK_CD_MELEE)
	if (!get_brute_loss())
		balloon_alert(user, LANG("mob.401fc32f95430172", null))
		return ITEM_INTERACT_BLOCKING
	if (!tool.tool_start_check(user, amount=1, heat_required = HIGH_TEMPERATURE_REQUIRED)) //The welder has 1u of fuel consumed by its afterattack, so we don't need to worry about taking any away.
		return ITEM_INTERACT_BLOCKING
	if(src == user)
		balloon_alert(user, LANG("mob.adb3f7e826dc35cd", null))
		if(!tool.use_tool(src, user, delay = 5 SECONDS, amount = 1, volume = 50))
			return ITEM_INTERACT_BLOCKING
	else
		if(!tool.use_tool(src, user, delay = 0.5 SECONDS, amount = 1, volume = 50))
			return ITEM_INTERACT_BLOCKING

	adjust_brute_loss(-30)
	add_fingerprint(user)
	balloon_alert(user, LANG("mob.7a6cbe1fc5f5c8fb", null))
	user.visible_message(
		span_notice(LANG("mob.a1eec76e5b7c4a06", list(user, src))),
		span_notice(LANG("mob.4b121f4477c231b0", list(src))),
		visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
	)
	return ITEM_INTERACT_SUCCESS

/mob/living/silicon/robot/crowbar_act(mob/living/user, obj/item/tool)
	if(opened)
		balloon_alert(user, LANG("mob.c9780c72de374f59", null))
		opened = FALSE
		update_icons()
	else
		if(locked)
			balloon_alert(user, LANG("mob.6bf50352dee04d46", null))
		else
			balloon_alert(user, LANG("mob.34a25969f86cb5fc", null))
			opened = TRUE
			update_icons()

	return ITEM_INTERACT_SUCCESS

/mob/living/silicon/robot/screwdriver_act(mob/living/user, obj/item/tool)
	if(!opened)
		return NONE
	if(!cell) // haxing
		wiresexposed = !wiresexposed
		balloon_alert(user, LANG("mob.ac8966cf0cdb5091", list(wiresexposed ? "exposed" : "unexposed")))
	else // radio
		if(shell)
			balloon_alert(user, LANG("mob.7a27c53327186ff8", null)) // Prevent AI radio key theft
		else if(radio)
			radio.screwdriver_act(user, tool) // Push it to the radio to let it handle everything
		else
			to_chat(user, span_warning(LANG("mob.936a5eb3f3963d54", null)))
			balloon_alert(user, LANG("mob.9a5cb2614a14ac8b", null))
	update_icons()
	return ITEM_INTERACT_SUCCESS

/mob/living/silicon/robot/wrench_act(mob/living/user, obj/item/tool)
	if(!(opened && !cell))	// Deconstruction. The flashes break from the fall, to prevent this from being a ghetto reset module.
		return NONE
	if(!lockcharge)
		to_chat(user, span_warning(LANG("mob.d886ed064fdcf809", list(src))))
		spark_system.start()
		return ITEM_INTERACT_BLOCKING
	balloon_alert(user, LANG("mob.44f0e678d88c8044", null))
	if(!tool.use_tool(src, user, 5 SECONDS, volume = 50) && !cell)
		return ITEM_INTERACT_BLOCKING
	loc.balloon_alert(user, LANG("mob.80451b1c014c10d8", null))
	user.visible_message(
		span_notice(LANG("mob.2ced132f3318943c", list(user, src))),
		span_notice(LANG("mob.d0894daafdef3d5e", list(src))),
		visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
	)
	cyborg_deconstruct()
	return ITEM_INTERACT_SUCCESS

/mob/living/silicon/robot/fire_act()
	if(!on_fire) //Silicons don't gain stacks from hotspots, but hotspots can ignite them
		ignite_mob()

/mob/living/silicon/robot/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	switch(severity)
		if(EMP_HEAVY)
			Unconscious(16 SECONDS)
		if(EMP_LIGHT)
			Unconscious(6 SECONDS)

/mob/living/silicon/robot/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(user == src)//To prevent syndieborgs from emagging themselves
		return FALSE
	if(!opened)//Cover is closed
		if(locked)
			balloon_alert(user, LANG("mob.95b487a03ca9696d", null))
			locked = FALSE
			if(shell) //A warning to Traitors who may not know that emagging AI shells does not slave them.
				balloon_alert(user, LANG("mob.c810d1c71e8bed7f", null))
				to_chat(user, span_boldwarning(LANG("mob.ece44261101f5cf1", list(src))))
			return TRUE
		else
			balloon_alert(user, LANG("mob.ce6d77bd09746a4e", null))
			return FALSE
	if(world.time < emag_cooldown)
		return FALSE
	if(wiresexposed)
		balloon_alert(user, LANG("mob.af365309afe2b41b", null))
		return FALSE

	balloon_alert(user, LANG("mob.e0149705b733a2db", null))
	emag_cooldown = world.time + 100

	if(connected_ai && connected_ai.mind && connected_ai.mind.has_antag_datum(/datum/antagonist/malf_ai))
		to_chat(src, span_danger(LANG("mob.caebd82a8bd15b29", null)))
		logevent("ALERT: Foreign software execution prevented.")
		to_chat(connected_ai, span_danger(LANG("mob.440af65d1b8ae58e", list(src))))
		log_silicon("EMAG: [key_name(user)] attempted to emag cyborg [key_name(src)], but they were slaved to traitor AI [connected_ai].")
		return TRUE // emag succeeded, it was just counteracted

	if(shell) //AI shells cannot be emagged, so we try to make it look like a standard reset. Smart players may see through this, however.
		to_chat(user, span_danger(LANG("mob.58418714e3714800", list(src))))
		log_silicon("EMAG: [key_name(user)] attempted to emag an AI shell belonging to [key_name(src) ? key_name(src) : connected_ai]. The shell has been reset as a result.")
		ResetModel()
		return TRUE

	SetEmagged(TRUE)
	Paralyze(10 SECONDS) //Make cyborgs actually unconscious. Without this they can scream for help over the radio mid-emag, which doesn't make much sense
	SetStun(10 SECONDS) //Borgs were getting into trouble because they would attack the emagger before the new laws were shown
	lawupdate = FALSE
	set_connected_ai(null)
	message_admins("[ADMIN_LOOKUPFLW(user)] emagged cyborg [ADMIN_LOOKUPFLW(src)].  Laws overridden.")
	log_silicon("EMAG: [key_name(user)] emagged cyborg [key_name(src)]. Laws overridden.")
	log_law_change(user, "emagged [key_name(src)]")

	model.rebuild_modules()

	INVOKE_ASYNC(src, PROC_REF(borg_emag_end), user)
	return TRUE

/// A async proc called from [emag_act] that gives the borg a lot of flavortext, and applies the syndicate lawset after a delay.
/mob/living/silicon/robot/proc/borg_emag_end(mob/user)
	to_chat(src, span_danger(LANG("mob.3522296c1fa8bd84", null)))
	logevent("ALERT: Foreign software detected.")
	sleep(0.5 SECONDS)
	to_chat(src, span_danger(LANG("mob.844d86a4f33dcc55", null)))
	sleep(2 SECONDS)
	to_chat(src, span_danger(LANG("mob.c360ccf1ab8da1d2", null)))
	logevent("WARN: root privleges granted to PID [num2hex(rand(1,65535), -1)][num2hex(rand(1,65535), -1)].") //random eight digit hex value. Two are used because rand(1,4294967295) throws an error
	sleep(0.5 SECONDS)
	to_chat(src, span_danger(LANG("mob.4a153c30a48fe153", null)))
	sleep(0.5 SECONDS)
	if(user)
		logevent("LOG: New user \[[replacetext(user.real_name," ","")]\], groups \[root\]")
	to_chat(src, span_danger(LANG("mob.a414780a8fe0f3cb", null)))
	sleep(1 SECONDS)
	to_chat(src, span_danger(LANG("mob.7a90b55cb5ac4528", null)))
	sleep(2 SECONDS)
	to_chat(src, span_danger(LANG("mob.0d934bcb6561659a", null)))
	replace_law_set(/datum/ai_laws/syndicate_override)
	if(user)
		to_chat(src, span_danger(LANG("mob.b32b93ce09039d2c", list(user.real_name, user.p_their()))))
		laws.set_zeroth_law("Only [user.real_name] and people [user.p_they()] designate[user.p_s()] as being such are Syndicate Agents.", force = TRUE)
		laws.protected_zeroth = TRUE
	update_icons()

/mob/living/silicon/robot/blob_act(obj/structure/blob/B)
	if(stat != DEAD)
		adjust_brute_loss(30)
	else
		investigate_log("has been gibbed by a blob.", INVESTIGATE_DEATHS)
		gib(DROP_ALL_REMAINS)
	return TRUE

/mob/living/silicon/robot/ex_act(severity, target)
	switch(severity)
		if(EXPLODE_DEVASTATE)
			investigate_log("has been gibbed by an explosion.", INVESTIGATE_DEATHS)
			gib(DROP_ALL_REMAINS)
			return TRUE
		if(EXPLODE_HEAVY)
			if (stat != DEAD)
				adjust_brute_loss(60)
				adjust_fire_loss(60)
		if(EXPLODE_LIGHT)
			if (stat != DEAD)
				adjust_brute_loss(30)

	return TRUE

/mob/living/silicon/robot/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit = FALSE)
	if(check_block(hitting_projectile, hitting_projectile.damage, "\the [hitting_projectile]", PROJECTILE_ATTACK, hitting_projectile.armour_penetration, hitting_projectile.damage_type))
		return ..(hitting_projectile, def_zone, piercing_hit, 100)
	. = ..()
	if(prob(25) || . != BULLET_ACT_HIT)
		return
	if(hitting_projectile.damage_type != BRUTE && hitting_projectile.damage_type != BURN)
		return
	if(!hitting_projectile.is_hostile_projectile() || hitting_projectile.damage <= 0)
		return
	spark_system.start()

/mob/living/silicon/robot/attack_effects(damage_done, hit_zone, armor_block, obj/item/attacking_item, mob/living/attacker)
	if(damage_done > 0 && attacking_item.damtype != STAMINA && stat != DEAD)
		spark_system.start()
		. = TRUE
	return ..() || .

/mob/living/silicon/robot/apply_damage/apply_damage(
	damage = 0,
	damagetype = BRUTE,
	def_zone = null,
	blocked = 0,
	forced = FALSE,
	spread_damage = FALSE,
	wound_bonus = 0,
	exposed_wound_bonus = 0,
	sharpness = NONE,
	attack_direction = null,
	attacking_item,
	wound_clothing = TRUE,
)
	var/mob/living/silicon/robot/borg = src
	var/obj/item/shield_module/shield = locate() in borg
	if(!shield)
		return ..()
	if(borg.cell.charge <= 0.4 * STANDARD_CELL_CHARGE)
		balloon_alert(borg, LANG("mob.204cf586a1a03b27", null))
		if(shield.active)
			shield.active = FALSE
			playsound(src, 'sound/vehicles/mecha/mech_shield_drop.ogg', 50, FALSE)
			borg.cut_overlay(shield.shield_overlay)
			return
	if(shield && shield.active)
		if(!lavaland_equipment_pressure_check(get_turf(borg)))
			balloon_alert(borg, LANG("mob.71239cd02a66e8ce", null))
			return ..()
		playsound(src, 'sound/vehicles/mecha/mech_shield_deflect.ogg', 100, TRUE)
		balloon_alert(borg, LANG("mob.6e60369181a62d03", null))
		borg.cell.use(damage * (STANDARD_CELL_CHARGE / 15), force = TRUE)
		damage *= 0.5
	return ..()
