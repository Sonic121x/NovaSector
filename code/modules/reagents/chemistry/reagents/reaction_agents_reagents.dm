/datum/reagent/reaction_agent
	abstract_type = /datum/reagent/reaction_agent
	name = "Reaction Agent-反应试剂"
	description = "你好！我是一个有问题的试剂。请举报我的罪行。谢谢！！"

/datum/reagent/reaction_agent/intercept_reagents_transfer(datum/reagents/target, amount, copy_only)
	if(!target)
		return FALSE
	if(target.flags & NO_REACT)
		return FALSE
	if(target.has_reagent(/datum/reagent/stabilizing_agent))
		return FALSE
	if(!target.total_volume)
		return FALSE
	if(LAZYLEN(target.reagent_list) == 1)
		if(target.has_reagent(type)) //Allow dispensing into self
			return FALSE
	return TRUE

/datum/reagent/reaction_agent/acidic_buffer
	name = "Strong Acidic Buffer-强酸性缓冲液"
	description = "此试剂在添加到另一个烧杯时会消耗自身，并将烧杯的pH值移向酸性。"
	color = "#fbc314"
	ph = 0
	inverse_chem = null
	fallback_icon = 'icons/obj/drinks/drink_effects.dmi'
	fallback_icon_state = "acid_buffer_fallback"
	glass_price = DRINK_PRICE_HIGH

//Consumes self on addition and shifts ph
/datum/reagent/reaction_agent/acidic_buffer/intercept_reagents_transfer(datum/reagents/target, amount, copy_only)
	. = ..()
	if(!.)
		return

	//do the ph change
	var/message
	if(target.ph <= ph)
		message = "The beaker froths as the buffer is added, to no effect."
	else
		message = "The beaker froths as the pH changes!"
		target.adjust_all_reagents_ph((-(amount / target.total_volume) * BUFFER_IONIZING_STRENGTH))
		target.update_total()

	//give feedback & remove from holder because it's not transferred
	target.my_atom.audible_message(span_warning(message))
	playsound(target.my_atom, 'sound/effects/chemistry/bufferadd.ogg', 50, TRUE)
	if(!copy_only)
		volume -= amount
		holder.update_total()

/datum/reagent/reaction_agent/basic_buffer
	name = "Strong Basic Buffer-强碱性缓冲液"
	description = "此试剂在添加到另一个烧杯时会消耗自身，并将烧杯的pH值移向碱性。"
	color = "#3853a4"
	ph = 14
	inverse_chem = null
	fallback_icon = 'icons/obj/drinks/drink_effects.dmi'
	fallback_icon_state = "base_buffer_fallback"
	glass_price = DRINK_PRICE_HIGH

/datum/reagent/reaction_agent/basic_buffer/intercept_reagents_transfer(datum/reagents/target, amount, copy_only)
	. = ..()
	if(!.)
		return

	//do the ph change
	var/message
	if(target.ph >= ph)
		message = "The beaker froths as the buffer is added, to no effect."
	else
		message = "The beaker froths as the pH changes!"
		target.adjust_all_reagents_ph(((amount / target.total_volume) * BUFFER_IONIZING_STRENGTH))
		target.update_total()

	//give feedback & remove from holder because it's not transferred
	target.my_atom.audible_message(span_warning(message))
	playsound(target.my_atom, 'sound/effects/chemistry/bufferadd.ogg', 50, TRUE)
	if(!copy_only)
		volume -= amount
		holder.update_total()

//purity testor/reaction agent prefactors

/datum/reagent/prefactor_a
	name = "Interim Product Alpha-中期产品阿尔法"
	description = "这种试剂是纯度测试剂的前体，会与稳定等离子体反应生成它。"
	color = "#bafa69"

/datum/reagent/prefactor_b
	name = "Interim Product Beta-中期产品贝塔"
	description = "这种试剂是反应加速剂的前体，会与稳定等离子体反应生成它。"
	color = "#8a3aa9"

/datum/reagent/reaction_agent/purity_tester
	name = "Purity Tester-纯度测试剂"
	description = "如果烧杯中含有高杂质试剂，这种试剂会消耗自身并发生剧烈反应。"
	ph = 3
	color = "#ffffff"

/datum/reagent/reaction_agent/purity_tester/intercept_reagents_transfer(datum/reagents/target, amount, copy_only)
	. = ..()
	if(!.)
		return
	var/is_inverse = FALSE
	for(var/_reagent in target.reagent_list)
		var/datum/reagent/reaction_agent/reagent = _reagent
		if(reagent.purity <= reagent.inverse_chem_val)
			is_inverse = TRUE
	if(is_inverse)
		target.my_atom.audible_message(span_warning("烧杯在试剂加入时剧烈冒泡！"))
		playsound(target.my_atom, 'sound/effects/chemistry/bufferadd.ogg', 50, TRUE)
	else
		target.my_atom.audible_message(span_warning("加入的试剂似乎没什么效果。"))
	if(!copy_only)
		volume -= amount
		holder.update_total()

///How much the reaction speed is sped up by - for 5u added to 100u, an additional step of 1 will be done up to a max of 2x
#define SPEED_REAGENT_STRENGTH 20

/datum/reagent/reaction_agent/speed_agent
	name = "Tempomyocin-纯度催化剂"
	description = "这种试剂会消耗自身并加速正在进行的反应，根据其自身纯度修改当前反应的纯度。"
	ph = 10
	color = "#e61f82"

/datum/reagent/reaction_agent/speed_agent/intercept_reagents_transfer(datum/reagents/target, amount, copy_only)
	. = ..()
	if(!.)
		return FALSE
	if(!length(target.reaction_list))//you can add this reagent to a beaker with no ongoing reactions, so this prevents it from being used up.
		return FALSE
	amount /= target.reaction_list.len
	for(var/_reaction in target.reaction_list)
		var/datum/equilibrium/reaction = _reaction
		if(!reaction)
			CRASH("[_reaction] is in the reaction list, but is not an equilibrium")
		var/power = (amount / reaction.target_vol) * SPEED_REAGENT_STRENGTH
		power *= creation_purity
		power = clamp(power, 0, 2)
		reaction.react_timestep(power, creation_purity)
	if(!copy_only)
		volume -= amount
		holder.update_total()

#undef SPEED_REAGENT_STRENGTH

/datum/reagent/reaction_agent/inversing_buffer
	name = "手性反转缓冲液"
	description = "这种试剂会消耗自身并将杂质试剂转化为它们的反向对应物。转化量取决于所添加缓冲液的体积。"
	ph = 7
	color = "#b60046"

/datum/reagent/reaction_agent/inversing_buffer/intercept_reagents_transfer(datum/reagents/target, amount, copy_only)
	. = ..()
	if(!.)
		return

	var/conversion_buffer = amount * 10 //Converts up to 10 units of reagent per 1 unit of inversing buffer.
	var/converted = 0
	var/list/cached_reagents = target.reagent_list.Copy()
	for(var/datum/reagent/reagent as anything in cached_reagents)
		if(!conversion_buffer)
			return
		if(reagent.purity <= reagent.inverse_chem_val)
			//compute volume of reagent to be converted
			converted = min(reagent.volume, conversion_buffer)
			//remove original reagent from target
			reagent.volume -= converted
			target.update_total()
			//add new inverse reagent to target
			target.add_reagent(reagent.inverse_chem, converted, FALSE, added_purity = reagent.get_inverse_purity(reagent.purity))
			//remove from buffer remaining
			conversion_buffer -= converted

	//audible feedback
	if(conversion_buffer < amount * 10)
		target.my_atom.audible_message(span_warning("烧杯开始剧烈沸腾，内容物开始反转！"))
		playsound(target.my_atom, 'sound/effects/chemistry/catalyst.ogg', 50, TRUE)
	else
		target.my_atom.audible_message(span_warning("缓冲液嘶嘶作响，但毫无效果。"))

	//remove inversening reagent based on total buffer removed
	var/volume_to_transfer = amount - (amount * (1 - (conversion_buffer / (amount * 10))))
	if(volume_to_transfer)
		target.add_reagent(type, volume_to_transfer, reagtemp = holder.chem_temp, added_purity = purity, added_ph = ph)
	if(!copy_only)
		volume -= amount
		holder.update_total()

