/obj/item/sequence_scanner
	name = "基因序列扫描器"
	icon = 'icons/obj/devices/scanner.dmi'
	icon_state = "gene"
	inhand_icon_state = "healthanalyzer"
	worn_icon_state = "healthanalyzer"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	desc = "一种手持式扫描器，用于即时分析某人的基因序列。在DNA控制台上使用可更新内部数据库。"
	obj_flags = CONDUCTS_ELECTRICITY
	item_flags = NOBLUDGEON
	slot_flags = ITEM_SLOT_BELT
	throwforce = 3
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 3
	throw_range = 7
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*2)
	sound_vary = TRUE
	pickup_sound = SFX_GENERIC_DEVICE_PICKUP
	drop_sound = SFX_GENERIC_DEVICE_DROP

	var/list/discovered = list() //hit a dna console to update the scanners database
	var/list/buffer
	var/ready = TRUE
	var/cooldown = (20 SECONDS)
	/// genetic makeup data that's scanned
	var/list/genetic_makeup_buffer = list()

/obj/item/sequence_scanner/examine(mob/user)
	. = ..()
	. += span_notice("使用主攻击扫描突变，副攻击扫描基因构成")
	if(LAZYLEN(genetic_makeup_buffer) > 0)
		. += span_notice("它的缓冲区内存有\"[genetic_makeup_buffer["name"]]\"的基因构成")

/obj/item/sequence_scanner/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(istype(interacting_with, /obj/machinery/computer/dna_console))
		var/obj/machinery/computer/dna_console/console = interacting_with
		if(console.stored_research)
			to_chat(user, span_notice("[name]已连接到中央研究数据库。"))
			discovered = console.stored_research.discovered_mutations
		else
			to_chat(user,span_warning("没有可更新的数据库。"))
		return ITEM_INTERACT_SUCCESS

	if(!isliving(interacting_with))
		return NONE

	add_fingerprint(user)

	//no scanning if its a husk or DNA-less Species
	if (!HAS_TRAIT(interacting_with, TRAIT_GENELESS) && !HAS_TRAIT(interacting_with, TRAIT_BADDNA))
		user.visible_message(span_notice("[user]分析了[interacting_with]的基因序列。"))
		balloon_alert(user, "序列已分析")
		playsound(user, 'sound/items/healthanalyzer.ogg', 50) // close enough
		gene_scan(interacting_with, user)
		return ITEM_INTERACT_SUCCESS

	user.visible_message(span_notice("[user] 未能分析 [interacting_with] 的基因序列。"), span_warning("[interacting_with] 没有可读取的基因序列！"))
	return ITEM_INTERACT_BLOCKING

/obj/item/sequence_scanner/interact_with_atom_secondary(atom/interacting_with, mob/living/user, list/modifiers)
	if(istype(interacting_with, /obj/machinery/computer/dna_console))
		var/obj/machinery/computer/dna_console/console = interacting_with
		var/buffer_index = tgui_input_number(user, "Slot:", "导出哪个槽位：", 1, LAZYLEN(console.genetic_makeup_buffer), 1)
		console.genetic_makeup_buffer[buffer_index] = genetic_makeup_buffer
		return ITEM_INTERACT_SUCCESS

	if(!isliving(interacting_with))
		return NONE

	add_fingerprint(user)

	//no scanning if its a husk, DNA-less Species or DNA that isn't able to be copied by a changeling/disease
	if (!HAS_TRAIT(interacting_with, TRAIT_GENELESS) && !HAS_TRAIT(interacting_with, TRAIT_BADDNA) && !HAS_TRAIT(interacting_with, TRAIT_NO_DNA_COPY))
		user.visible_message(span_warning("[user] 正在扫描 [interacting_with] 的基因构成。"))
		if(!do_after(user, 3 SECONDS, interacting_with))
			balloon_alert(user, "扫描失败！")
			user.visible_message(span_warning("[user] 未能扫描 [interacting_with] 的基因构成。"))
			return ITEM_INTERACT_BLOCKING
		makeup_scan(interacting_with, user)
		balloon_alert(user, "基因构成已扫描")
		return ITEM_INTERACT_SUCCESS

	user.visible_message(span_notice("[user] 未能分析 [interacting_with] 的基因构成。"), span_warning("[interacting_with] 没有可读取的基因构成！"))
	return ITEM_INTERACT_BLOCKING

/obj/item/sequence_scanner/attack_self(mob/user)
	display_sequence(user)

/obj/item/sequence_scanner/attack_self_tk(mob/user)
	return

///proc for scanning someone's mutations
/obj/item/sequence_scanner/proc/gene_scan(mob/living/carbon/target, mob/living/user)
	if(!iscarbon(target) || !target.has_dna())
		return

	//add target mutations to list as well as extra mutations.
	//dupe list as scanner could modify target data
	buffer = LAZYLISTDUPLICATE(target.dna.mutation_index)
	var/list/active_mutations = list()
	for(var/datum/mutation/mutation in target.dna.mutations)
		LAZYSET(buffer, mutation.type, GET_SEQUENCE(mutation.type))
		active_mutations.Add(mutation.type)

	to_chat(user, span_notice("目标 [target.name] 的DNA序列已保存至缓冲区。"))
	for(var/mutation in buffer)
		//highlight activated mutations
		if(LAZYFIND(active_mutations, mutation))
			to_chat(user, span_boldnotice("[get_display_name(mutation)]"))
		else
			to_chat(user, span_notice("[get_display_name(mutation)]"))
	to_chat(user, span_notice("<span class='info ml-1'>基因稳定性：[target.dna.stability]%。</span><br>")) // NOVA EDIT ADDITION - Adds stability indication.

///proc for scanning someone's genetic makeup
/obj/item/sequence_scanner/proc/makeup_scan(mob/living/carbon/target, mob/living/user)
	if(!iscarbon(target) || !target.has_dna())
		return

	genetic_makeup_buffer = list(
	"label"="Analyzer Slot:[target.real_name]",
	"UI"=target.dna.unique_identity,
	"UE"=target.dna.unique_enzymes,
	"UF"=target.dna.unique_features,
	"name"=target.real_name,
	"blood_type"=target.get_bloodtype())

/obj/item/sequence_scanner/proc/display_sequence(mob/living/user)
	if(!LAZYLEN(buffer) || !ready)
		return
	var/list/options = list()
	for(var/mutation in buffer)
		options += get_display_name(mutation)

	var/answer = tgui_input_list(user, "分析潜力", "序列分析仪", sort_list(options))
	if(isnull(answer))
		return
	if(!ready || !user.can_perform_action(src, NEED_LITERACY|NEED_LIGHT|FORBID_TELEKINESIS_REACH))
		return

	var/sequence
	for(var/mutation in buffer) //this physically hurts but i dont know what anything else short of an assoc list
		if(get_display_name(mutation) == answer)
			sequence = buffer[mutation]
			break

	if(sequence)
		var/display
		for(var/i in 0 to length_char(sequence) / DNA_MUTATION_BLOCKS-1)
			if(i)
				display += "-"
			display += copytext_char(sequence, 1 + i*DNA_MUTATION_BLOCKS, DNA_MUTATION_BLOCKS*(1+i) + 1)

		to_chat(user, "[span_boldnotice("[display]")]<br>")

	ready = FALSE
	icon_state = "[icon_state]_recharging"
	addtimer(CALLBACK(src, PROC_REF(recharge)), cooldown, TIMER_UNIQUE)

/obj/item/sequence_scanner/proc/recharge()
	icon_state = initial(icon_state)
	ready = TRUE

/obj/item/sequence_scanner/proc/get_display_name(mutation)
	var/datum/mutation/mutation_instance = GET_INITIALIZED_MUTATION(mutation)
	if(!mutation_instance)
		return "ERROR"
	if(mutation in discovered)
		return  "[mutation_instance.name] ([mutation_instance.alias])"
	else
		return mutation_instance.alias
