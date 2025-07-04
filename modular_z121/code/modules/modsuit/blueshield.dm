/obj/item/mod/module/blue_shield
    module_type = MODULE_TOGGLE
    name = "蓝盾投射模块"
    desc = "一个个人防护力场，在用户前方投射1x3的护盾，阻挡抛射物但不阻挡近战或投掷物。"
    icon_state = "energy_shield"
    complexity = 0
    idle_power_cost = DEFAULT_CHARGE_DRAIN * 0.5
    use_energy_cost = DEFAULT_CHARGE_DRAIN * 2
    incompatible_modules = list(/obj/item/mod/module/energy_shield)
    required_slots = list(ITEM_SLOT_BACK)
    overlay_state_inactive = "module_blueshield"
    overlay_state_active = "module_blueshield_on"
    cooldown_time = 15 SECONDS

    var/list/shields = null
    var/shield_regen_timer = null
    var/shield_strength = 120
    var/shield_max_strength = 120
    var/last_damage_time = 0

/obj/item/mod/module/blue_shield/on_activation()
    if(cooldown_timer)
        var/time_left = timeleft(cooldown_timer)
        to_chat(mod.wearer, span_warning("护盾模块冷却中，请等待 [DisplayTimeText(time_left, 1)]"))
        return FALSE

    ..()
    if(shields)
        call_deactivate_shields()
    if(!mod?.wearer)
        return

    if(mod.wearer.stat >= UNCONSCIOUS)
        to_chat(mod.wearer, span_warning("护盾结构不稳定！"))
        return FALSE

    shield_strength = shield_max_strength
    last_damage_time = world.time

    if(shield_regen_timer)
        deltimer(shield_regen_timer)
        shield_regen_timer = null

    call_create_shields()

    RegisterSignal(mod.wearer, COMSIG_MOVABLE_MOVED, .proc/update_shields_position)
    RegisterSignal(mod.wearer, COMSIG_ATOM_DIR_CHANGE, .proc/on_wearer_dir_change)
    RegisterSignal(mod.wearer, COMSIG_MOB_STATCHANGE, .proc/on_wearer_stat_change)

    shield_regen_timer = addtimer(CALLBACK(src, .proc/shield_regen_tick), 5 SECONDS, TIMER_LOOP | TIMER_STOPPABLE)

    to_chat(mod.wearer, span_notice("护盾已激活！护盾数量: [length(shields)]"))

/obj/item/mod/module/blue_shield/on_deactivation(display_message = TRUE, deleting = FALSE)
    . = ..()

    call_deactivate_shields()

    UnregisterSignal(mod.wearer, list(
        COMSIG_MOVABLE_MOVED,
        COMSIG_ATOM_DIR_CHANGE,
        COMSIG_MOB_STATCHANGE
    ))

    if(shield_regen_timer)
        deltimer(shield_regen_timer)
        shield_regen_timer = null

    if(!deleting && cooldown_time > 0)
        if(cooldown_timer)
            deltimer(cooldown_timer)
        cooldown_timer = addtimer(CALLBACK(src, .proc/end_cooldown), cooldown_time, TIMER_STOPPABLE)
        if(display_message)
            to_chat(mod.wearer, span_warning("护盾已关闭！进入 [DisplayTimeText(cooldown_time, 1)] 冷却"))

    if(display_message && !cooldown_timer)
        to_chat(mod.wearer, span_warning("护盾已关闭！"))

/obj/item/mod/module/blue_shield/proc/end_cooldown()
    cooldown_timer = null
    if(mod?.wearer)
        to_chat(mod.wearer, span_notice("护盾模块冷却结束，可以重新激活"))

/obj/item/mod/module/blue_shield/proc/get_module_data(datum/mod_ui/ui)
    . = ""
    if(cooldown_timer)
        var/time_left = timeleft(cooldown_timer)
        . += "[DisplayTimeText(time_left, 1)] 冷却时间"

/obj/item/mod/module/blue_shield/proc/on_wearer_stat_change(mob/living/carbon/human/source, new_stat, old_stat)
    if(new_stat >= UNCONSCIOUS && active)
        to_chat(source, span_danger("护盾结构失稳！"))
        on_deactivation()

/obj/item/mod/module/blue_shield/proc/on_wearer_dir_change(atom/source, old_dir, new_dir)
    update_shields_position()

/obj/item/mod/module/blue_shield/proc/shield_regen_tick()
    if(!mod?.wearer || !shields)
        return

    if(world.time < last_damage_time + 3 SECONDS)
        return

    if(shield_strength < shield_max_strength)
        shield_strength = min(shield_strength + 20, shield_max_strength)
        to_chat(mod.wearer, span_notice("护盾能量恢复，当前强度：[shield_strength]/[shield_max_strength]"))

/obj/item/mod/module/blue_shield/proc/shield_damage(damage = 20)
    if(!mod?.wearer || !shields)
        return

    last_damage_time = world.time

    shield_strength -= damage
    to_chat(mod.wearer, span_warning("护盾受到伤害，当前强度：[shield_strength]/[shield_max_strength]"))

    if(shield_strength <= 0)
        on_deactivation()
        to_chat(mod.wearer, span_danger("护盾能量耗尽，已关闭！"))

/obj/item/mod/module/blue_shield/proc/call_create_shields()
    call_deactivate_shields()
    if(!mod?.wearer)
        return

    shields = list()
    var/dir = mod.wearer.dir
    var/turf/origin = get_turf(mod.wearer)

    for(var/i = -1; i <= 1; i++)
        var/turf/target = null
        switch(dir)
            if(NORTH, SOUTH)
                target = get_step(origin, dir)
                if(target)
                    target = locate(target.x + i, target.y, target.z)
            if(EAST, WEST)
                target = get_step(origin, dir)
                if(target)
                    target = locate(target.x, target.y + i, target.z)

        if(target)
            var/obj/structure/blueshield/B = new(target, mod.wearer, i, src)
            shields += B
            B.setDir(dir)

/obj/item/mod/module/blue_shield/proc/call_deactivate_shields()
    if(shields)
        for(var/obj/structure/blueshield/B in shields)
            qdel(B)
        shields = null

/obj/item/mod/module/blue_shield/proc/update_shields_position()
    if(!shields || !mod?.wearer)
        return

    var/dir = mod.wearer.dir
    var/turf/origin = get_turf(mod.wearer)
    for(var/obj/structure/blueshield/B in shields)
        var/turf/target = null
        switch(dir)
            if(NORTH)
                target = locate(origin.x + B.offset, origin.y + 1, origin.z)
            if(SOUTH)
                target = locate(origin.x + B.offset, origin.y - 1, origin.z)
            if(EAST)
                target = locate(origin.x + 1, origin.y + B.offset, origin.z)
            if(WEST)
                target = locate(origin.x - 1, origin.y + B.offset, origin.z)

        if(target && B.loc != target)
            B.forceMove(target)
            B.setDir(dir)

/obj/structure/blueshield
    name = "能量护盾"
    desc = "一道能量屏障，能阻挡远程弹丸，但允许所有生物通过。"
    icon = 'icons/effects/effects.dmi'
    icon_state = "shield-old"
    anchored = TRUE
    density = TRUE  // 修复：设置为TRUE以阻挡抛射物
    opacity = FALSE
    pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE | PASSMOB
    resistance_flags = INDESTRUCTIBLE
    var/offset
    var/obj/item/mod/module/blue_shield/module_ref

/obj/structure/blueshield/Initialize(mapload, mob/wearer, offset_index, obj/item/mod/module/blue_shield/module)
    . = ..()
    offset = offset_index
    module_ref = module
    if(wearer)
        setDir(wearer.dir)

    if(module_ref)
        module_ref.shields += src

// 关键修复：确保抛射物被阻挡
/obj/structure/blueshield/bullet_act(obj/projectile/P)
    if(module_ref)
        module_ref.shield_damage(P.damage)
        visible_message(span_warning("[src] 闪烁并吸收了抛射物！"))
        return BULLET_ACT_BLOCK
    return ..()

// 关键修复：允许生物通过
/obj/structure/blueshield/CanPass(atom/movable/mover, turf/target)
    if(ismob(mover))
        return TRUE
    return ..()

/obj/structure/blueshield/attack_hand(mob/user, list/modifiers)
    if(module_ref && module_ref.mod?.wearer)
        to_chat(user, span_warning("你的攻击穿过了 [src]！"))
    return FALSE

/obj/structure/blueshield/attackby(obj/item/W, mob/user, params)
    if(W.throwing)
        return FALSE

    if(module_ref && module_ref.mod?.wearer)
        to_chat(user, span_warning("你的攻击穿过了 [src]！"))
    return FALSE
