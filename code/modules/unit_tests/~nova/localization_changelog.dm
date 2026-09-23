/// The changelog's localization tab lists the compiled months, and only ever serves a month it listed.
/datum/unit_test/localization_changelog

/datum/unit_test/localization_changelog/Run()
	var/datum/changelog/changelog = allocate(/datum/changelog)

	var/list/dates = changelog.localization_changelog_dates()
	TEST_ASSERT(length(dates), "No compiled months found in html/changelogs/localization/archive/")
	for(var/date in dates)
		TEST_ASSERT(findtext(date, regex(@"^\d{4}-\d{2}$")), "Unexpected localization changelog month name: [date]")
	var/list/sorted = sort_list(dates.Copy())
	TEST_ASSERT_EQUAL(dates[1], sorted[length(sorted)], "Localization changelog months should be listed newest first")

	var/list/static_data = changelog.ui_static_data()
	TEST_ASSERT_NOTNULL(static_data["dates"], "Upstream changelog dates went missing from the static data")
	TEST_ASSERT_EQUAL(length(static_data["localization_dates"]), length(dates), "Static data should carry the localization months")

	// The first listed month is served, and serving it again reuses the same registered asset.
	var/datum/asset/changelog_item/localization/item = changelog.get_localization_changelog_item(dates[1])
	TEST_ASSERT_NOTNULL(item, "A listed month ([dates[1]]) was refused")
	TEST_ASSERT_EQUAL(item.item_filename, "localization-[dates[1]].yml", "Localization assets must be namespaced away from upstream's month assets")
	TEST_ASSERT_EQUAL(changelog.get_localization_changelog_item(dates[1]), item, "The same month should reuse its registered asset")

	// A requested date comes from the client and ends up in a file path; anything we did not list must be refused.
	for(var/bad_date in list("../../config/admins", "2026-13", "", null, 5))
		TEST_ASSERT_NULL(changelog.get_localization_changelog_item(bad_date), "Served a changelog asset for unlisted date [bad_date]")
