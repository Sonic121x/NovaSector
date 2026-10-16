/// The chance for a manifest or crate to be created with errors
#define MANIFEST_ERROR_CHANCE 5

// MANIFEST BITFLAGS
/// Determines if the station name will be incorrect on the manifest
#define MANIFEST_ERROR_NAME (1 << 0)
/// Determines if contents will be deleted from the manifest but still be present in the crate
#define MANIFEST_ERROR_CONTENTS (1 << 1)
/// Determines if contents will be deleted from the crate but still be present in the manifest
#define MANIFEST_ERROR_ITEM (1 << 2)

/obj/item/paper/fluff/jobs/cargo/manifest
	can_become_message_in_bottle = FALSE //A lot of these are spawned each round, they'd only dilute the pool and make it boring.
	var/order_cost = 0
	var/order_id = 0
	var/errors = 0

/obj/item/paper/requisition
	can_become_message_in_bottle = FALSE //A lot of these are spawned each round, they'd only dilute the pool and make it boring.

/obj/item/paper/fluff/jobs/cargo/manifest/Initialize(mapload, id, cost, manifest_can_fail = TRUE)
	. = ..()
	order_id = id
	order_cost = cost
	if(!manifest_can_fail)
		return

	if(prob(MANIFEST_ERROR_CHANCE) && (world.time-SSticker.round_start_time > STATION_RENAME_TIME_LIMIT)) //Too confusing if station name gets changed
		errors |= MANIFEST_ERROR_NAME
		investigate_log("Supply order #[order_id] generated a manifest with an incorrect station name.", INVESTIGATE_CARGO)
	if(prob(MANIFEST_ERROR_CHANCE))
		errors |= MANIFEST_ERROR_CONTENTS
		investigate_log("Supply order #[order_id] generated a manifest missing listed contents.", INVESTIGATE_CARGO)
	else if(prob(MANIFEST_ERROR_CHANCE)) //Content and item errors could remove the same items, so only one at a time
		errors |= MANIFEST_ERROR_ITEM
		investigate_log("Supply order #[order_id] generated with incorrect contents shipped.", INVESTIGATE_CARGO)

/obj/item/paper/fluff/jobs/cargo/manifest/proc/is_approved()
	return LAZYLEN(stamp_cache) && !is_denied()

/obj/item/paper/fluff/jobs/cargo/manifest/proc/is_denied()
	return LAZYLEN(stamp_cache) && ("stamp-deny" in stamp_cache)

/datum/supply_order
	var/id
	var/cost_type
	var/orderer
	var/orderer_rank
	var/orderer_ckey
	var/reason
	var/discounted_pct
	///If set to FALSE, we won't charge when the cargo shuttle arrives with this.
	var/charge_on_purchase = TRUE
	///area this order wants to reach, if not null then it will come with the deliver_first component set to this area
	var/department_destination
	var/datum/supply_pack/pack
	var/datum/bank_account/paying_account
	var/obj/item/coupon/applied_coupon
	///Boolean on whether the manifest can fail or not.
	var/manifest_can_fail = TRUE
	///Boolean on whether the manifest can be cancelled through cargo consoles.
	var/can_be_cancelled = TRUE

/datum/supply_order/New(
	datum/supply_pack/pack,
	orderer,
	orderer_rank,
	orderer_ckey,
	reason,
	paying_account,
	department_destination,
	coupon,
	charge_on_purchase = TRUE,
	manifest_can_fail = TRUE,
	cost_type = MONEY_SYMBOL,
	can_be_cancelled = TRUE,
)
	id = SSshuttle.order_number++
	src.cost_type = cost_type
	src.pack = pack
	src.orderer = orderer
	src.orderer_rank = orderer_rank
	src.orderer_ckey = orderer_ckey
	src.reason = reason
	src.paying_account = paying_account
	src.department_destination = department_destination
	src.applied_coupon = coupon
	src.charge_on_purchase = charge_on_purchase
	src.manifest_can_fail = manifest_can_fail
	src.can_be_cancelled = can_be_cancelled

/datum/supply_order/Destroy(force)
	QDEL_NULL(applied_coupon)
	return ..()

//returns the total cost of this order. Its not the total price paid by cargo but the total value of this order
/datum/supply_order/proc/get_final_cost()
	var/cost = pack.get_cost()
	if(applied_coupon) //apply discount price
		cost *= (1 - applied_coupon.discount_pct_off)
	if(paying_account?.add_to_accounts && !(pack.order_flags & ORDER_GOODY)) //privately purchased and not a goody means 1.1x the cost
		cost *= 1.1
	return round(cost)

/datum/supply_order/proc/generateRequisition(turf/T)
	var/obj/item/paper/requisition/requisition_paper = new(T)

	var/pack_name = lang_reverse_text(pack.name) // ZH EDIT ADDITION - i18n - pack 是 /datum/supply_pack（非 atom，name 不过落地反查）→ 单据显英文、与已译箱名对不上；显式反查（en locale no-op）
	requisition_paper.name = "requisition form - #[id] ([pack_name])" // ZH EDIT CHANGE - i18n - ORIGINAL: ... ([pack.name])
	var/requisition_text = "<h2>[station_name()] [lang_reverse_text("Supply Requisition")]</h2>" // ZH EDIT - I18N - 单据标签反查（en locale no-op）
	requisition_text += "<hr/>"
	requisition_text += "[lang_reverse_text("Order")] #[id]<br/>" // ZH EDIT - I18N
	requisition_text += "[lang_reverse_text("Time of Order")]: [UNDERLINED_HTML_TEXT("[server_timestamp(ic_time = TRUE)]", "Shift Time: [round_timestamp()]")]<br/>" // ZH EDIT - I18N
	requisition_text += "[lang_reverse_text("Item")]: [pack_name]<br/>" // ZH EDIT CHANGE - i18n（标签反查 + pack_name 反查）- ORIGINAL: "Item: [pack.name]"
	requisition_text += "[lang_reverse_text("Access Restrictions")]: [SSid_access.get_access_desc(pack.access)]<br/>" // ZH EDIT - I18N
	requisition_text += "[lang_reverse_text("Requested by")]: [orderer]<br/>" // ZH EDIT - I18N
	if(paying_account)
		requisition_text += "[lang_reverse_text("Paid by")]: [paying_account.account_holder]<br/>" // ZH EDIT - I18N
	requisition_text += "[lang_reverse_text("Rank")]: [orderer_rank]<br/>" // ZH EDIT - I18N
	requisition_text += "[lang_reverse_text("Comment")]: [reason]<br/>" // ZH EDIT - I18N

	requisition_paper.add_raw_text(requisition_text, advanced_html = TRUE)
	requisition_paper.update_appearance()
	return requisition_paper

/datum/supply_order/proc/generateManifest(obj/container, owner, packname, cost) //generates-the-manifests.
	var/obj/item/paper/fluff/jobs/cargo/manifest/manifest_paper = new(null, id, cost, manifest_can_fail)

	var/station_name = (manifest_paper.errors & MANIFEST_ERROR_NAME) ? new_station_name() : station_name()

	// ZH EDIT ADDITION START - i18n - pack/packname 反查成已译箱名，让单据与实际箱子名对得上（否则单据英文、找不到对应箱子）
	var/pack_name = lang_reverse_text(pack.name)
	if(packname)
		packname = lang_reverse_text(packname)
	// ZH EDIT ADDITION END
	manifest_paper.name = "shipping manifest - [packname?"#[id] ([pack_name])":"(Grouped Item Crate)"]" // ZH EDIT CHANGE - i18n - ORIGINAL: ([pack.name])

	var/manifest_text = "<h2>[command_name()] [lang_reverse_text("Shipping Manifest")]</h2>" // ZH EDIT - I18N - 单据标签反查（en locale no-op）
	manifest_text += "<hr/>"
	if(owner && !(owner == "Cargo"))
		manifest_text += "[lang_reverse_text("Direct purchase from")] [owner]<br/>" // ZH EDIT - I18N
		manifest_paper.name += " - Purchased by [owner]"
	manifest_text += "[lang_reverse_text(packname ? "Order" : "Orders")]: [id]<br/>" // ZH EDIT CHANGE - i18n - ORIGINAL: "Order[packname?"":"s"]: [id]"
	manifest_text += "[lang_reverse_text("Destination")]: [station_name]<br/>" // ZH EDIT - I18N
	if(packname)
		manifest_text += "[lang_reverse_text("Item")]: [packname]<br/>" // ZH EDIT - I18N
	manifest_text += "[lang_reverse_text("Contents")]: <br/>" // ZH EDIT - I18N
	manifest_text += "<ul>"
	var/container_contents = list() // Associative list with the format (item_name = nº of occurrences, ...)
	for(var/atom/movable/stuff as anything in container.contents - manifest_paper)
		if(isstack(stuff))
			var/obj/item/stack/thing = stuff
			container_contents[lang_reverse_text(thing.singular_name)] += thing.amount // ZH EDIT CHANGE - i18n - stack 单数名反查（非 atom.name，落地钩子抓不到）- ORIGINAL: container_contents[thing.singular_name]
			continue
		container_contents[stuff.name]++
	if((manifest_paper.errors & MANIFEST_ERROR_CONTENTS) && container_contents)
		if(HAS_TRAIT(container, TRAIT_NO_MANIFEST_CONTENTS_ERROR))
			manifest_paper.errors &= ~MANIFEST_ERROR_CONTENTS
		else
			for(var/iteration in 1 to rand(1, round(container.contents.len * 0.5))) // Remove anywhere from one to half of the items
				var/missing_item = pick(container_contents)
				container_contents[missing_item]--
				if(!container_contents[missing_item]) // To avoid 0s and negative values on the manifest
					container_contents -= missing_item

	for(var/item in container_contents)
		manifest_text += "<li> [container_contents[item]] [item][(container_contents[item] == 1 || GLOB.i18n_server_locale != DEFAULT_UI_LOCALE) ? "" : plural_s(item)]</li>" // ZH EDIT CHANGE - i18n: 全服 locale≠en 时不加英文复数 s（内容名已反查成中文，中文无复数）- ORIGINAL: [container_contents[item] == 1 ? "" : plural_s(item)]
	manifest_text += "</ul>"
	manifest_text += "<h4>[lang_reverse_text("Stamp below to confirm receipt of goods:")]</h4>" // ZH EDIT - I18N

	manifest_paper.add_raw_text(manifest_text)

	if(manifest_paper.errors & MANIFEST_ERROR_ITEM)
		if(HAS_TRAIT(container, TRAIT_NO_MISSING_ITEM_ERROR))
			manifest_paper.errors &= ~MANIFEST_ERROR_ITEM
		else
			var/lost = max(round(container.contents.len / 10), 1)
			while(--lost >= 0)
				qdel(pick(container.contents))

	manifest_paper.update_appearance()
	manifest_paper.forceMove(container)

	if(istype(container, /obj/structure/closet/crate))
		var/obj/structure/closet/crate/crate = container
		crate.manifest = WEAKREF(manifest_paper)
		crate.update_appearance()

	return manifest_paper

/datum/supply_order/proc/generate(atom/A)
	var/account_holder
	if(paying_account)
		account_holder = paying_account.account_holder
	else
		account_holder = "Cargo"
	var/obj/structure/closet/crate/crate = pack.generate(A, paying_account, initial(pack.storage_override))
	if(pack.order_flags & ORDER_CONTRABAND)
		for(var/atom/movable/item_within as anything in crate.get_all_contents())
			ADD_TRAIT(item_within, TRAIT_CONTRABAND, INNATE_TRAIT)
	if(department_destination)
		crate.AddElement(/datum/element/deliver_first, department_destination, pack.cost)
	generateManifest(crate, account_holder, pack, pack.cost)
	return crate

/datum/supply_order/proc/generateCombo(miscbox, misc_own, misc_contents, misc_cost)
	for (var/I in misc_contents)
		new I(miscbox)
	generateManifest(miscbox, misc_own, "", misc_cost)
	return

/datum/supply_order/proc/append_order(list/new_contents, cost_increase)
	for(var/i in new_contents)
		if(pack.contains[i])
			pack.contains[i] += new_contents[i]
		else
			pack.contains += i
			pack.contains[i] = new_contents[i]
	pack.cost += cost_increase

/// Custom type of order who's supply pack can be safely deleted
/datum/supply_order/disposable/Destroy(force)
	QDEL_NULL(pack)
	return ..()

/// Custom material order to append cargo crate value to the final order cost
/datum/supply_order/disposable/materials/get_final_cost()
	return (..() + CARGO_CRATE_VALUE)

/// Custom material order to append cargo crate value to the final manifest cost
/datum/supply_order/disposable/materials/generateManifest(obj/container, owner, packname, cost)
	cost += CARGO_CRATE_VALUE
	return ..()

#undef MANIFEST_ERROR_CHANCE
#undef MANIFEST_ERROR_NAME
#undef MANIFEST_ERROR_CONTENTS
#undef MANIFEST_ERROR_ITEM
