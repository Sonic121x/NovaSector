/// Sends information needed for uplinks
/datum/asset/json/uplink
	name = "uplink"
	early = TRUE

/datum/asset/json/uplink/generate()
	var/list/data = list()
	var/list/categories = list()
	var/list/items = list()
	for(var/datum/uplink_category/category as anything in subtypesof(/datum/uplink_category))
		categories += category
	sortTim(categories, GLOBAL_PROC_REF(cmp_uplink_category_desc))

	var/list/new_categories = list()
	for(var/datum/uplink_category/category as anything in categories)
		new_categories += initial(category.name)
	categories = new_categories

	for(var/datum/uplink_item/item_path as anything in subtypesof(/datum/uplink_item))
		var/datum/uplink_item/item = new item_path()
		var/atom/actual_item = item.item
		if(item.item) {
			items += list(list(
				"id" = item_path,
				"name" = item.name,
				"icon" = actual_item.icon,
				"icon_state" = actual_item.icon_state,
				"cost" = item.cost,
				"desc" = item.desc,
				"category" = item.category ? initial(item.category.name) : null,
				"purchasable_from" = item.purchasable_from,
				"restricted" = item.restricted,
				"limited_stock" = item.limited_stock,
				"stock_key" = item.stock_key,
				"restricted_roles" = item.restricted_roles,
				"restricted_species" = item.restricted_species,
				"population_minimum" = item.population_minimum,
				"cost_override_string" = item.cost_override_string,
				"lock_other_purchases" = item.lock_other_purchases
			))
		}
		SStraitor.uplink_items += item
		SStraitor.uplink_items_by_type[item_path] = item

	// NOVA EDIT ADDITION START - I18N: the uplink item catalog is a static JSON asset (generated once at
	// startup), so it bypasses get_payload/lang_reverse_tree — every name/desc/category stayed English.
	// Reverse the player-visible display fields here. buy() keys off item.type/ref (not these), and the TS
	// client filters by category on BOTH the item.category and the categories list (no server round-trip),
	// so translating both sides consistently keeps filtering intact. lang_reverse_text = exact full-string
	// (no multi-word gate) like the preferences-asset pass; locale==en returns input unchanged (no-op).
	if(GLOB.i18n_server_locale != DEFAULT_UI_LOCALE)
		for(var/list/entry as anything in items)
			if(istext(entry["name"]))
				entry["name"] = lang_reverse_text(entry["name"])
			if(istext(entry["desc"]))
				entry["desc"] = lang_reverse_text(entry["desc"])
			if(istext(entry["category"]))
				entry["category"] = lang_reverse_text(entry["category"])
			if(istext(entry["cost_override_string"]))
				entry["cost_override_string"] = lang_reverse_text(entry["cost_override_string"])
		var/list/localized_categories = list()
		for(var/cat in categories)
			localized_categories += istext(cat) ? lang_reverse_text(cat) : cat
		categories = localized_categories
	// NOVA EDIT ADDITION END
	data["items"] = items
	data["categories"] = categories
	return data
