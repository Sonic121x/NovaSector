// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/sequence_scanner
	name = "genetic sequence scanner"
	icon = 'icons/obj/devices/scanner.dmi'
	icon_state = "gene"
	inhand_icon_state = "healthanalyzer"
	worn_icon_state = "healthanalyzer"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	desc = "A hand-held scanner for analyzing someones gene sequence on the fly. Use on a DNA console to update the internal database."
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
	custom_materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT, /datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT)

	var/list/discovered = list() //hit a dna console to update the scanners database
	var/list/buffer
	var/ready = TRUE
	var/cooldown = (20 SECONDS)
	/// genetic makeup data that's scanned
	var/list/genetic_makeup_buffer = list()

/obj/item/sequence_scanner/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.1d555183d0cb7f63", null))
	if(LAZYLEN(genetic_makeup_buffer) > 0)
		. += span_notice(LANG("obj.c2e66c2ed516cab6", list(genetic_makeup_buffer["name"])))

/obj/item/sequence_scanner/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(istype(interacting_with, /obj/machinery/computer/dna_console))
		var/obj/machinery/computer/dna_console/console = interacting_with
		if(console.stored_research)
			to_chat(user, span_notice(LANG("obj.ed9ebf67a45e63f1", list(name))))
			discovered = console.stored_research.discovered_mutations
		else
			to_chat(user,span_warning(LANG("obj.f8027cc197389e19", null)))
		return ITEM_INTERACT_SUCCESS

	if(!isliving(interacting_with))
		return NONE

	add_fingerprint(user)

	//no scanning if its a husk or DNA-less Species
	if (!HAS_TRAIT(interacting_with, TRAIT_GENELESS) && !HAS_TRAIT(interacting_with, TRAIT_BADDNA))
		user.visible_message(span_notice(LANG("obj.6529f0ceddee2dab", list(user, interacting_with))))
		balloon_alert(user, LANG("obj.6cece6aa59bfe08a", null))
		playsound(user, 'sound/items/healthanalyzer.ogg', 50) // close enough
		gene_scan(interacting_with, user)
		return ITEM_INTERACT_SUCCESS

	user.visible_message(span_notice(LANG("obj.484b876609cd746c", list(user, interacting_with))), span_warning(LANG("obj.1b5e07068c009f33", list(interacting_with))))
	return ITEM_INTERACT_BLOCKING

/obj/item/sequence_scanner/interact_with_atom_secondary(atom/interacting_with, mob/living/user, list/modifiers)
	if(istype(interacting_with, /obj/machinery/computer/dna_console))
		var/obj/machinery/computer/dna_console/console = interacting_with
		var/buffer_index = tgui_input_number(user, LANG("obj.2df829eea7f8ec83", null), LANG("obj.a60f61619bbee648", null), 1, LAZYLEN(console.genetic_makeup_buffer), 1)
		console.genetic_makeup_buffer[buffer_index] = genetic_makeup_buffer
		return ITEM_INTERACT_SUCCESS

	if(!isliving(interacting_with))
		return NONE

	add_fingerprint(user)

	//no scanning if its a husk, DNA-less Species or DNA that isn't able to be copied by a changeling/disease
	if (!HAS_TRAIT(interacting_with, TRAIT_GENELESS) && !HAS_TRAIT(interacting_with, TRAIT_BADDNA) && !HAS_TRAIT(interacting_with, TRAIT_NO_DNA_COPY))
		user.visible_message(span_warning(LANG("obj.9e20c061a3550b9b", list(user, interacting_with))))
		if(!do_after(user, 3 SECONDS, interacting_with))
			balloon_alert(user, LANG("obj.afa319fc83ec4b2f", null))
			user.visible_message(span_warning(LANG("obj.7e55a88ca7a08a37", list(user, interacting_with))))
			return ITEM_INTERACT_BLOCKING
		makeup_scan(interacting_with, user)
		balloon_alert(user, LANG("obj.2c8f5042c2f67dc8", null))
		return ITEM_INTERACT_SUCCESS

	user.visible_message(span_notice(LANG("obj.a321b282ec9a6e46", list(user, interacting_with))), span_warning(LANG("obj.9be3dc873d193cd3", list(interacting_with))))
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

	to_chat(user, span_notice(LANG("obj.b89de6264c137aa2", list(target.name))))
	for(var/mutation in buffer)
		//highlight activated mutations
		if(LAZYFIND(active_mutations, mutation))
			to_chat(user, span_boldnotice("[get_display_name(mutation)]"))
		else
			to_chat(user, span_notice("[get_display_name(mutation)]"))
	to_chat(user, span_notice(LANG("obj.1e9bd33cb05f48b2", list(target.dna.stability)))) // NOVA EDIT ADDITION - Adds stability indication.

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

	var/answer = tgui_input_list(user, LANG("obj.245ba4919e394823", null), LANG("obj.5722bb55ee92e7d3", null), sort_list(options))
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
		// NOVA EDIT CHANGE - i18n: 整串是运行期拼的、永远不是目录键，落地只剩字面 AC，而 AC 有多词
		// 门槛 —— 于是「舌钉 (Mutation 32)」是中文、「Spastic (Mutation 67)」是英文，同一份列表里
		// 按名字词数分成两半。突变名本身早在目录里，在显示处逐个反查即可（alias 是
		// GLOB.alias_mutations 的查表键，保持英文）。
		// ORIGINAL: return  "[mutation_instance.name] ([mutation_instance.alias])"
		return  "[lang_localize_display_name(mutation_instance.name)] ([mutation_instance.alias])"
	else
		return mutation_instance.alias
