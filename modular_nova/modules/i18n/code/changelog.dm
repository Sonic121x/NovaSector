// The in-game changelog's "Localization" tab: this localization fork's own changes (html/changelogs/localization).
// Kept apart from upstream's html/changelogs/archive so an upstream merge never conflicts with it.
// Entries are compiled with tools/i18n/compile-localization-changelog.py.

#define LOCALIZATION_CHANGELOG_ARCHIVE "html/changelogs/localization/archive/"

/datum/changelog
	/// Localization changelog assets already registered, keyed by month ("YYYY-MM")
	var/static/list/localization_changelog_items = list()

/// Months with a compiled localization changelog, newest first
/datum/changelog/proc/localization_changelog_dates()
	var/list/dates = list()
	for(var/archive_file in sort_list(flist(LOCALIZATION_CHANGELOG_ARCHIVE)))
		if(copytext(archive_file, -4) != ".yml")
			continue
		dates.Insert(1, copytext(archive_file, 1, -4))
	return dates

/datum/changelog/ui_static_data()
	. = ..()
	.["localization_dates"] = localization_changelog_dates()

/datum/changelog/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(. || action != "get_localization_month")
		return
	var/datum/asset/changelog_item/localization/changelog_item = get_localization_changelog_item(params["date"])
	if(changelog_item)
		return ui.send_asset(changelog_item)

/// Returns the asset for a localization changelog month, registering it on first use, or null for anything we don't list.
/datum/changelog/proc/get_localization_changelog_item(date)
	// The date comes from the client and ends up in a file path, so only accept a month we list ourselves.
	if(!istext(date) || !(date in localization_changelog_dates()))
		return null
	var/datum/asset/changelog_item/localization/changelog_item = localization_changelog_items[date]
	if(!changelog_item)
		changelog_item = new /datum/asset/changelog_item/localization(date)
		localization_changelog_items[date] = changelog_item
	return changelog_item

/// Same as the upstream changelog month asset, but read from the localization archive and namespaced
/// so it cannot collide with upstream's asset for the same month.
/datum/asset/changelog_item/localization

/datum/asset/changelog_item/localization/New(date)
	// Deliberately not calling parent: it would register upstream's archive file for this month instead.
	item_filename = SANITIZE_FILENAME("localization-[date].yml")
	SSassets.transport.register_asset(item_filename, file(LOCALIZATION_CHANGELOG_ARCHIVE + SANITIZE_FILENAME("[date].yml")))

#undef LOCALIZATION_CHANGELOG_ARCHIVE
