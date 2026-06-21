/obj/item/reagent_containers/hypospray/medipen
	/// If TRUE, the medipen will initialize without reagents
	var/init_empty = FALSE
	/// If TRUE, indicates that the medipen hasn't been injected by a mob yet
	var/unused = TRUE

// Allows medipens to initialize without reagents if init_empty is TRUE
/obj/item/reagent_containers/hypospray/medipen/Initialize(mapload)
	if(init_empty != TRUE)
		return ..()

	// Temporarily sets list_reagents to null to avoid filling the medipen
	var/initial_reagents = list_reagents
	list_reagents = null
	. = ..()
	list_reagents = initial_reagents

	if(label_examine)
		var/reagent_types = assoc_to_keys(list_reagents)
		// Set label text via list_reagents, due to actual reagents being empty
		label_text = span_notice("侧面贴着一张标签，上面写着：'警告：此医疗笔含有[pretty_string_from_reagent_list(reagent_types, names_only = TRUE, join_text = ", ", final_and = TRUE, capitalize_names = TRUE)]，如果对任何所列化学品过敏，请勿使用。'")

// Sends a more generic chat message when an unused medipen is empty
/obj/item/reagent_containers/hypospray/medipen/inject(mob/living/affected_mob, mob/user)
	if(!reagents?.total_volume || (init_empty && used_up && unused))
		to_chat(user, span_warning("You push [src]'s button, but nothing happens. It's empty!"))
		return FALSE

	// Attempt the injection
	. = ..()

	// If the injection succeeded, then the medipen is not unused anymore
	if(unused && .)
		unused = FALSE

/obj/item/reagent_containers/hypospray/medipen/empty
	init_empty = TRUE
	used_up = TRUE

/obj/item/reagent_containers/hypospray/medipen/atropine/empty
	init_empty = TRUE
	used_up = TRUE

/obj/item/reagent_containers/hypospray/medipen/salbutamol/empty
	init_empty = TRUE
	used_up = TRUE

/obj/item/reagent_containers/hypospray/medipen/oxandrolone/empty
	init_empty = TRUE
	used_up = TRUE

/obj/item/reagent_containers/hypospray/medipen/salacid/empty
	init_empty = TRUE
	used_up = TRUE

/obj/item/reagent_containers/hypospray/medipen/penacid/empty
	init_empty = TRUE
	used_up = TRUE
