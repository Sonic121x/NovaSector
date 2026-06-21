/obj/item/organ/stomach
	/// Whether the organ is an oversized version
	var/is_oversized

/obj/item/organ/stomach/oversized
	name = "巨大肠胃"
	desc = "常见于巨型生物体内，这个庞大的引擎进化得极为高效，旨在为巨大的食客提供巨量营养。"
	icon = 'modular_nova/modules/organs/icons/stomach.dmi'
	icon_state = "stomach_big"
	maxHealth = 1.5 * STANDARD_ORGAN_THRESHOLD
	metabolism_efficiency = 0.07
	is_oversized = TRUE

/obj/item/organ/stomach/synth/oversized
	name = "巨型合成燃料单元"
	desc = "常见于巨型合成体体内，这个庞大的燃料单元被设计得极为高效，旨在为庞大的机器提供巨量能量。"
	icon = 'modular_nova/modules/organs/icons/stomach.dmi'
	icon_state = "stomach_big_synth" //ugly placeholder sorry im not an artist hehe
	maxHealth = 1.5 * STANDARD_ORGAN_THRESHOLD
	metabolism_efficiency = 0.07
	is_oversized = TRUE

/obj/item/organ/stomach/slime/oversized
	name = "巨型高尔基体"
	desc = "常见于巨型史莱姆体内，这个庞大的细胞器进化得极为高效，旨在为巨大的粘液团提供巨量营养。"
	maxHealth = 1.5 * STANDARD_ORGAN_THRESHOLD
	metabolism_efficiency = 0.07
	is_oversized = TRUE

// Not a stomach, but suitable for where we keep oversized schtuff.
/obj/item/organ/brain/slime/oversized
	name = "超大核心"
	desc = "The central core of a slimeperson, technically their 'extract.' Where the cytoplasm, membrane, and organelles come from; perhaps this is also a mitochondria? This one is enormous."
	brain_size = 2

/obj/item/organ/stomach/ethereal/proc/ethereal_shock_absorb(mob/living/stomach_owner = owner, shock_damage, shock_source, siemens_coeff = 1, flags = NONE)
	do_sparks(number = 5, cardinal_only = TRUE, source = shock_source)
	playsound(src, SFX_SPARKS, 75, TRUE, -1)
	adjust_charge(25)
	if(!(flags & SHOCK_SUPPRESS_MESSAGE))
		stomach_owner.visible_message(
			span_danger("[stomach_owner] was shocked by \the [shock_source], absorbing it into [stomach_owner.p_their()] body!"), \
			span_userdanger("你感到一股强大的电流流遍全身，但轻松地承受住了！"), \
			span_hear("你听到一声沉重的电击爆裂声。") \
		)
	if (!(flags & SHOCK_NO_HUMAN_ANIM))
		if(ishuman(stomach_owner))
			var/mob/living/carbon/human/human_target = stomach_owner
			human_target.electrocution_animation(1 SECONDS)
	return COMPONENT_LIVING_BLOCK_SHOCK

//lithovore stomach - modified golem - this whole section calls to the vars set under stomach/golem, they work in game
/obj/item/organ/stomach/lithovore
	name = "石质适应胃"
	icon_state = "stomach-p"
	desc = "一种陌生的消化器官，擅长分解物质。"
	color = COLOR_GOLEM_GRAY
	organ_flags = ORGAN_MINERAL
	organ_traits = list(TRAIT_ROCK_EATER)

//i eat MORE ROCKS. WORSE.
/obj/item/organ/stomach/lithovore/oversized
	name = "巨型石质适应胃"
	icon = 'modular_nova/modules/organs/icons/stomach.dmi'
	icon_state = "stomach_big_p"
	desc = "一个庞大而陌生的消化器官，擅长分解物质。"
	color = COLOR_GOLEM_GRAY
	organ_flags = ORGAN_MINERAL
	organ_traits = list(TRAIT_ROCK_EATER)
	metabolism_efficiency = 0.07
	is_oversized = TRUE
