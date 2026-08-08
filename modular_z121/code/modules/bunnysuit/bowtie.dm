//Override thing from Monkey. Lets us tie bowties.
/obj/item/clothing/neck/bunny
	name = "bowtie collar"
	desc = "A fancy tie that includes a collar. Looking snazzy!"
	icon = 'modular_z121/icons/obj/clothing/bunny/neck/bunnyneck.dmi'
	worn_icon = 'modular_z121/icons/mob/clothing/bunny/neck/bunnyneck.dmi'
	icon_state = "bowtie_collar_tied"
	var/tie_type = "tie_greyscale"
	greyscale_colors = "#ffffff#39393f"
	greyscale_config = /datum/greyscale_config/bowtie_collar
	greyscale_config_worn = /datum/greyscale_config/bowtie_collar_worn
	flags_1 = null
	alternate_worn_layer = UNDER_SUIT_LAYER
	/// All ties start untied unless otherwise specified
	var/is_tied = FALSE
	/// How long it takes to tie the tie
	var/tie_timer = 4 SECONDS
	/// Is this tie a clip-on, meaning it does not have an untied state?
	var/clip_on = FALSE

/obj/item/clothing/neck/bunny/Initialize(mapload)
	. = ..()
	if(!clip_on)
		update_appearance(UPDATE_ICON)
	register_context()

/obj/item/clothing/neck/bunny/examine(mob/user)
	. = ..()
	. += span_notice("The tie can be worn above or below your suit. Alt-Right-click to toggle.")
	if(clip_on)
		. += span_notice("Looking closely, you can see that it's actually a cleverly disguised clip-on.")
	else if(!is_tied)
		. += span_notice("The tie can be tied with Alt-Click.")
	else
		. += span_notice("The tie can be untied with Alt-Click.")

/obj/item/clothing/neck/bunny/click_alt(mob/user)
	if(clip_on)
		return NONE
	to_chat(user, span_notice("You concentrate as you begin [is_tied ? "untying" : "tying"] [src]..."))
	var/tie_timer_actual = tie_timer
	// Mirrors give you a boost to your tying speed. I realize this stacks and I think that's hilarious.
	for(var/obj/structure/mirror/reflection in view(2, user))
		tie_timer_actual *= 0.8
	// Heads of staff are experts at tying their ties.
	if(HAS_TRAIT(user, TRAIT_FAST_TYING))
		tie_timer_actual *= 0.5
	// Tie/Untie our tie
	if(!do_after(user, tie_timer_actual))
		to_chat(user, span_notice("Your fingers fumble away from [src] as your concentration breaks."))
		return CLICK_ACTION_BLOCKING
	// Clumsy & Dumb people have trouble tying their ties.
	if((HAS_TRAIT(user, TRAIT_CLUMSY) || HAS_TRAIT(user, TRAIT_DUMB)) && prob(50))
		to_chat(user, span_notice("You just can't seem to get a proper grip on [src]!"))
		return CLICK_ACTION_BLOCKING
	// Success!
	is_tied = !is_tied
	user.visible_message(
		span_notice("[user] adjusts [user.p_their()] tie[HAS_TRAIT(user, TRAIT_BALD) ? "" : " and runs a hand across [user.p_their()] head"]."),
		span_notice("You successfully [is_tied ? "tied" : "untied"] [src]!"),
	)
	update_appearance(UPDATE_ICON)
	user.update_clothing(ITEM_SLOT_NECK)
	return CLICK_ACTION_SUCCESS

/obj/item/clothing/neck/bunny/click_alt_secondary(mob/user)
	alternate_worn_layer = (alternate_worn_layer == initial(alternate_worn_layer) ? NONE : initial(alternate_worn_layer))
	user.update_clothing(ITEM_SLOT_NECK)
	balloon_alert(user, "wearing [alternate_worn_layer == initial(alternate_worn_layer) ? "below" : "above"] suits")

/obj/item/clothing/neck/bunny/update_icon()
	. = ..()
	if(clip_on)
		return
	// Normal strip & equip delay, along with 2 second self equip since you need to squeeze your head through the hole.
	if(is_tied)
		icon_state = "[tie_type]_tied"
		strip_delay = 4 SECONDS
		equip_delay_other = 4 SECONDS
		equip_delay_self = 2 SECONDS
	else // Extremely quick strip delay, it's practically a ribbon draped around your neck
		icon_state = "[tie_type]_untied"
		strip_delay = 1 SECONDS
		equip_delay_other = 1 SECONDS
		equip_delay_self = 0

/obj/item/clothing/neck/bunny/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	context[SCREENTIP_CONTEXT_ALT_RMB] = "Wear [alternate_worn_layer == initial(alternate_worn_layer) ? "above" : "below"] suit"
	if(clip_on)
		return CONTEXTUAL_SCREENTIP_SET
	if(is_tied)
		context[SCREENTIP_CONTEXT_ALT_LMB] = "Untie"
	else
		context[SCREENTIP_CONTEXT_ALT_LMB] = "Tie"
	return CONTEXTUAL_SCREENTIP_SET

/obj/item/clothing/neck/bunny/worn_overlays(mutable_appearance/standing, isinhands)
	. = ..()
	var/mob/living/carbon/human/wearer = loc
	if(!ishuman(wearer) || !wearer.w_uniform)
		return
	var/obj/item/clothing/under/undershirt = wearer.w_uniform
	if(!istype(undershirt) || !LAZYLEN(undershirt.attached_accessories))
		return
	if(alternate_worn_layer)
		. += undershirt.accessory_overlay

//ALL BUNNY STUFF BY DimWhat OF MONKEESTATION

/obj/item/clothing/neck/bunny/bunnytie
	name = "bowtie collar"
	desc = "A fancy tie that includes a collar. Looking snazzy!"
	icon = 'modular_z121/icons/obj/clothing/bunny/neck/bunnyneck.dmi'
	worn_icon = 'modular_z121/icons/mob/clothing/bunny/neck/bunnyneck.dmi'
	icon_state = "bowtie_collar_tied"
	tie_type = "bowtie_collar"
	greyscale_colors = "#ffffff#39393f"
	greyscale_config = /datum/greyscale_config/bowtie_collar
	greyscale_config_worn = /datum/greyscale_config/bowtie_collar_worn
	flags_1 = null
	alternate_worn_layer = UNDER_SUIT_LAYER

/obj/item/clothing/neck/bunny/bunnytie/greyscale
	name = "bowtie collar"
	desc = "A fancy tie that includes a collar. Looking snazzy!"
	icon = 'modular_z121/icons/obj/clothing/bunny/neck/bunnyneck.dmi'
	worn_icon = 'modular_z121/icons/mob/clothing/bunny/neck/bunnyneck.dmi'
	icon_state = "bowtie_collar_tied"
	tie_type = "bowtie_collar"
	greyscale_colors = "#ffffff#39393f"
	greyscale_config = /datum/greyscale_config/bowtie_collar
	greyscale_config_worn = /datum/greyscale_config/bowtie_collar_worn
	flags_1 = IS_PLAYER_COLORABLE_1
	alternate_worn_layer = UNDER_SUIT_LAYER
	is_tied = TRUE

/obj/item/clothing/neck/bunny/bunnytie/syndicate
	name = "blood-red bowtie collar"
	desc = "A fancy tie that includes a red collar. Looking sinister..."
	icon_state = "bowtie_collar_syndi_tied"
	tie_type = "bowtie_collar_syndi"
	armor_type = /datum/armor/large_scarf_syndie
	tie_timer = 2 SECONDS //Tactical tie
	greyscale_config = null
	greyscale_config_worn = null
	greyscale_colors = null
	is_tied = TRUE

/obj/item/clothing/neck/bunny/bunnytie/magician
	name = "magician's bowtie collar"
	desc = "A fancy gold tie that includes a collar. Looking magical!"
	icon_state = "bowtie_collar_wiz_tied"
	tie_type = "bowtie_collar_wiz"
	greyscale_config = null
	greyscale_config_worn = null
	greyscale_colors = null
	custom_price = null
	is_tied = TRUE

/obj/item/clothing/neck/bunny/bunnytie/centcom
	name = "centcom bowtie collar"
	desc = "A fancy gold tie that includes a collar. Looking in charge!"
	icon_state = "bowtie_collar_centcom_tied"
	tie_type = "bowtie_collar_centcom"
	greyscale_config = null
	greyscale_config_worn = null
	greyscale_colors = null
	is_tied = TRUE

/obj/item/clothing/neck/bunny/bunnytie/communist
	name = "really red bowtie collar"
	desc = "A simple red tie that includes a collar. Looking egalitarian!"
	icon_state = "bowtie_collar_communist_tied"
	tie_type = "bowtie_collar_communist"
	greyscale_config = null
	greyscale_config_worn = null
	greyscale_colors = null
	is_tied = TRUE

/obj/item/clothing/neck/bunny/bunnytie/blue
	name = "blue bowtie collar"
	desc = "A simple blue tie that includes a collar. Looking imperialist!"
	icon_state = "bowtie_collar_blue_tied"
	tie_type = "bowtie_collar_blue"
	greyscale_config = null
	greyscale_config_worn = null
	greyscale_colors = null
	is_tied = TRUE

//CAPTAIN

/obj/item/clothing/neck/bunny/bunnytie/captain
	name = "captain's bowtie"
	desc = "A blue tie that includes a collar. Looking commanding!"
	icon_state = "bowtie_collar_captain_tied"
	tie_type = "bowtie_collar_captain"
	greyscale_colors = null
	greyscale_config = null
	greyscale_config_worn = null
	flags_1 = null
	is_tied = TRUE

//CARGO

/obj/item/clothing/neck/bunny/bunnytie/cargo
	name = "cargo bowtie"
	desc = "A brown tie that includes a collar. Looking unionized!"
	icon_state = "bowtie_collar_cargo_tied"
	tie_type = "bowtie_collar_cargo"
	greyscale_colors = null
	greyscale_config = null
	greyscale_config_worn = null
	flags_1 = null
	is_tied = TRUE

/obj/item/clothing/neck/bunny/bunnytie/miner
	name = "shaft miner's bowtie"
	desc = "A purple tie that includes a collar. Looking hardy!"
	icon_state = "bowtie_collar_explorer_tied"
	tie_type = "bowtie_collar_explorer"
	greyscale_colors = null
	greyscale_config = null
	greyscale_config_worn = null
	flags_1 = null
	is_tied = TRUE

/obj/item/clothing/neck/bunny/bunnytie/mailman
	name = "mailman's bowtie"
	desc = "A red tie that includes a collar. Looking unstoppable!"
	icon_state = "bowtie_collar_mail_tied"
	tie_type = "bowtie_collar_mail"
	greyscale_colors = null
	greyscale_config = null
	greyscale_config_worn = null
	flags_1 = null
	is_tied = TRUE

/obj/item/clothing/neck/bunny/bunnytie/bitrunner
	name = "bitrunner's bowtie"
	desc = "Bitrunners were told that wearing a novelty shirt with a printed bow tie wasn't enough for formal events."
	icon_state = "bowtie_collar_bitrunner_tied"
	tie_type = "bowtie_collar_bitrunner"
	greyscale_colors = null
	greyscale_config = null
	greyscale_config_worn = null
	flags_1 = null
	is_tied = TRUE

//ENGI

/obj/item/clothing/neck/bunny/bunnytie/engineer
	name = "engineering bowtie"
	desc = "An orange tie that includes a collar. Looking industrious!"
	icon_state = "bowtie_collar_engi_tied"
	tie_type = "bowtie_collar_engi"
	greyscale_colors = null
	greyscale_config = null
	greyscale_config_worn = null
	flags_1 = null
	is_tied = TRUE

/obj/item/clothing/neck/bunny/bunnytie/atmos_tech
	name = "atmospheric technician's bowtie"
	desc = "A blue tie that includes a collar. Looking inflammable!"
	icon_state = "bowtie_collar_atmos_tied"
	tie_type = "bowtie_collar_atmos"
	greyscale_colors = null
	greyscale_config = null
	greyscale_config_worn = null
	flags_1 = null
	is_tied = TRUE

/obj/item/clothing/neck/bunny/bunnytie/ce
	name = "chief engineer's bowtie"
	desc = "A green tie that includes a collar. Looking managerial!"
	icon_state = "bowtie_collar_ce_tied"
	tie_type = "bowtie_collar_ce"
	greyscale_colors = null
	greyscale_config = null
	greyscale_config_worn = null
	flags_1 = null
	is_tied = TRUE

//MEDICAL

/obj/item/clothing/neck/bunny/bunnytie/doctor
	name = "medical bowtie"
	desc = "A light blue tie that includes a collar. Looking helpful!"
	icon_state = "bowtie_collar_doctor_tied"
	tie_type = "bowtie_collar_doctor"
	greyscale_colors = null
	greyscale_config = null
	greyscale_config_worn = null
	flags_1 = null
	is_tied = TRUE

/obj/item/clothing/neck/bunny/bunnytie/paramedic
	name = "paramedic's bowtie"
	desc = "A white tie that includes a collar. Looking selfless!"
	icon_state = "bowtie_collar_paramedic_tied"
	tie_type = "bowtie_collar_paramedic"
	greyscale_colors = null
	greyscale_config = null
	greyscale_config_worn = null
	flags_1 = null
	is_tied = TRUE

/obj/item/clothing/neck/bunny/bunnytie/chemist
	name = "chemist's bowtie"
	desc = "An orange tie that includes a collar. Looking explosive!"
	icon_state = "bowtie_collar_chem_tied"
	tie_type = "bowtie_collar_chem"
	greyscale_colors = null
	greyscale_config = null
	greyscale_config_worn = null
	flags_1 = null
	is_tied = TRUE

/obj/item/clothing/neck/bunny/bunnytie/pathologist
	name = "pathologist's bowtie"
	desc = "A green tie that includes a collar. Looking infectious!"
	icon_state = "bowtie_collar_virologist_tied"
	tie_type = "bowtie_collar_virologist"
	greyscale_colors = null
	greyscale_config = null
	greyscale_config_worn = null
	flags_1 = null
	is_tied = TRUE

/obj/item/clothing/neck/bunny/bunnytie/coroner
	name = "coroner's bowtie"
	desc = "A black tie that includes a collar. Looking dead...Dead good!"
	icon_state = "bowtie_collar_coroner_tied"
	tie_type = "bowtie_collar_coroner"
	greyscale_colors = null
	greyscale_config = null
	greyscale_config_worn = null
	flags_1 = null
	is_tied = TRUE

/obj/item/clothing/neck/bunny/bunnytie/cmo
	name = "chief medical officer's bowtie"
	desc = "A blue tie that includes a collar. Looking responsible!"
	icon_state = "bowtie_collar_cmo_tied"
	tie_type = "bowtie_collar_cmo"
	greyscale_colors = null
	greyscale_config = null
	greyscale_config_worn = null
	flags_1 = null
	is_tied = TRUE

//SCIENCE

/obj/item/clothing/neck/bunny/bunnytie/scientist
	name = "scientist's bowtie"
	desc = "A purple tie that includes a collar. Looking intelligent!"
	icon_state = "bowtie_collar_science_tied"
	tie_type = "bowtie_collar_science"
	greyscale_colors = null
	greyscale_config = null
	greyscale_config_worn = null
	flags_1 = null
	is_tied = TRUE

/obj/item/clothing/neck/bunny/bunnytie/roboticist
	name = "roboticist's bowtie"
	desc = "A red tie that includes a collar. Looking transhumanist!"
	icon_state = "bowtie_collar_roboticist_tied"
	tie_type = "bowtie_collar_roboticist"
	greyscale_colors = null
	greyscale_config = null
	greyscale_config_worn = null
	flags_1 = null
	is_tied = TRUE

/obj/item/clothing/neck/bunny/bunnytie/geneticist
	name = "geneticist's bowtie"
	desc = "A blue tie that includes a collar. Looking aberrant!"
	icon_state = "bowtie_collar_genetics_tied"
	tie_type = "bowtie_collar_genetics"
	greyscale_colors = null
	greyscale_config = null
	greyscale_config_worn = null
	flags_1 = null
	is_tied = TRUE

/obj/item/clothing/neck/bunny/bunnytie/rd
	name = "research director's bowtie"
	desc = "A purple tie that includes a collar. Looking inventive!"
	icon_state = "bowtie_collar_science_tied"
	tie_type = "bowtie_collar_science"
	greyscale_colors = null
	greyscale_config = null
	greyscale_config_worn = null
	flags_1 = null
	is_tied = TRUE

//SECURITY

/obj/item/clothing/neck/bunny/bunnytie/security
	name = "security bowtie"
	desc = "A red tie that includes a collar. Looking tough!"
	icon_state = "bowtie_collar_sec_tied"
	tie_type = "bowtie_collar_sec"
	greyscale_colors = null
	greyscale_config = null
	greyscale_config_worn = null
	flags_1 = null
	is_tied = TRUE

/obj/item/clothing/neck/bunny/bunnytie/security_assistant
	name = "security assistant's bowtie"
	desc = "A grey tie that includes a collar. Looking \"helpful\"."
	icon_state = "bowtie_collar_sec_assistant_tied"
	tie_type = "bowtie_collar_sec_assistant"
	greyscale_colors = null
	greyscale_config = null
	greyscale_config_worn = null
	flags_1 = null
	is_tied = TRUE

/obj/item/clothing/neck/bunny/bunnytie/brig_phys
	name = "brig physician's bowtie"
	desc = "A red tie that includes a collar. Looking underappreciated!"
	icon_state = "bowtie_collar_brig_phys_tied"
	tie_type = "bowtie_collar_brig_phys"
	greyscale_colors = null
	greyscale_config = null
	greyscale_config_worn = null
	flags_1 = null
	is_tied = TRUE

/obj/item/clothing/neck/bunny/bunnytie/detective
	name = "detective's tie collar"
	desc = "A brown tie that includes a collar. Looking inquisitive!"
	icon_state = "tie_collar_det_tied"
	tie_type = "tie_collar_det"
	greyscale_colors = null
	greyscale_config = null
	greyscale_config_worn = null
	flags_1 = null
	is_tied = TRUE

/obj/item/clothing/neck/bunny/bunnytie/prisoner
	name = "prisoner's bowtie"
	desc = "A black tie that includes a collar. Looking criminal!"
	icon_state = "bowtie_collar_prisoner_tied"
	tie_type = "bowtie_collar_prisoner"
	greyscale_colors = null
	greyscale_config = null
	greyscale_config_worn = null
	flags_1 = null
	is_tied = TRUE

//SERVICE

/obj/item/clothing/neck/bunny/bunnytie/hop
	name = "head of personnel's bowtie"
	desc = "A dull red tie that includes a collar. Looking bogged down."
	icon_state = "bowtie_collar_hop_tied"
	tie_type = "bowtie_collar_hop"
	greyscale_colors = null
	greyscale_config = null
	greyscale_config_worn = null
	flags_1 = null
	is_tied = TRUE

/obj/item/clothing/neck/bunny/bunnytie/janitor
	name = "janitor's bowtie"
	desc = "A purple tie that includes a collar. Looking tidy!"
	icon_state = "bowtie_collar_janitor_tied"
	tie_type = "bowtie_collar_janitor"
	greyscale_colors = null
	greyscale_config = null
	greyscale_config_worn = null
	flags_1 = null
	is_tied = TRUE

/obj/item/clothing/neck/bunny/bunnytie/bartender
	name = "bartender's bowtie"
	desc = "A black tie that includes a collar. Looking fancy!"
	greyscale_colors = "#ffffff#39393f"
	greyscale_config = /datum/greyscale_config/bowtie_collar
	greyscale_config_worn = /datum/greyscale_config/bowtie_collar_worn
	flags_1 = null
	custom_price = PAYCHECK_CREW
	is_tied = TRUE

/obj/item/clothing/neck/bunny/bunnytie/cook
	name = "cook's bowtie"
	desc = "A red tie that includes a collar. Looking culinary!"
	icon_state = "bowtie_collar_chef_tied"
	tie_type = "bowtie_collar_chef"
	greyscale_colors = null
	greyscale_config = null
	greyscale_config_worn = null
	flags_1 = null
	is_tied = TRUE

/obj/item/clothing/neck/bunny/bunnytie/botanist
	name = "botanist's bowtie"
	desc = "A blue tie that includes a collar. Looking green-thumbed!"
	icon_state = "bowtie_collar_botany_tied"
	tie_type = "bowtie_collar_botany"
	greyscale_colors = null
	greyscale_config = null
	greyscale_config_worn = null
	flags_1 = null
	is_tied = TRUE

/obj/item/clothing/neck/bunny/clown
	name = "clown's bowtie"
	desc = "An outrageously large blue bowtie. Looking funny!"
	icon = 'modular_z121/icons/obj/clothing/bunny/neck/bunnyneck.dmi'
	worn_icon = 'modular_z121/icons/mob/clothing/bunny/neck/bunnyneck.dmi'
	icon_state = "bowtie_clown_tied"
	tie_type = "bowtie_clown"
	greyscale_colors = null
	greyscale_config = null
	greyscale_config_worn = null
	flags_1 = null
	tie_timer = 8 SECONDS //It's a BIG bowtie
	is_tied = TRUE

/obj/item/clothing/neck/bunny_pendant
	name = "bunny pendant"
	desc = "A golden pendant depicting a holy rabbit."
	icon_state = "chaplain_pendant"
	icon = 'modular_z121/icons/obj/clothing/bunny/neck/bunnyneck.dmi'
	worn_icon = 'modular_z121/icons/mob/clothing/bunny/neck/bunnyneck.dmi'

/obj/item/clothing/neck/bunny/bunnytie/lawyer_black
	name = "lawyer's black tie collar"
	desc = "A black tie that includes a collar. Looking legal!"
	icon_state = "tie_collar_lawyer_black_tied"
	tie_type = "tie_collar_lawyer_black"
	greyscale_colors = null
	greyscale_config = null
	greyscale_config_worn = null
	flags_1 = null
	is_tied = TRUE

/obj/item/clothing/neck/bunny/bunnytie/lawyer_blue
	name = "lawyer's blue tie collar"
	desc = "A blue tie that includes a collar. Looking defensive!"
	icon_state = "tie_collar_lawyer_blue_tied"
	tie_type = "tie_collar_lawyer_blue"
	greyscale_colors = null
	greyscale_config = null
	greyscale_config_worn = null
	flags_1 = null
	is_tied = TRUE

/obj/item/clothing/neck/bunny/bunnytie/lawyer_red
	name = "lawyer's red tie collar"
	desc = "A red tie that includes a collar. Looking prosecutive!"
	icon_state = "tie_collar_lawyer_red_tied"
	tie_type = "tie_collar_lawyer_red"
	greyscale_colors = null
	greyscale_config = null
	greyscale_config_worn = null
	flags_1 = null
	is_tied = TRUE

/obj/item/clothing/neck/bunny/bunnytie/lawyer_good
	name = "good lawyer's tie collar"
	desc = "A black tie that includes a collar. Looking technically legal!"
	icon_state = "tie_collar_lawyer_good_tied"
	tie_type = "tie_collar_lawyer_good"
	greyscale_colors = null
	greyscale_config = null
	greyscale_config_worn = null
	flags_1 = null
	is_tied = TRUE

//BUNNY STUFF END, SPRITES BY DimWhat OF MONKE STATION