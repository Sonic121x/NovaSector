/// wiki_page_url() (modular_zh/master_files/code/game/objects/items/wiki_manuals.dm) builds
/// index.php?title= links and prefers MANUAL_WIKIURL over WIKIURL.
/datum/unit_test/wiki_page_url
	var/saved_wiki
	var/saved_manual

/datum/unit_test/wiki_page_url/Destroy()
	CONFIG_SET(string/wikiurl, saved_wiki)
	CONFIG_SET(string/manual_wikiurl, saved_manual)
	return ..()

/datum/unit_test/wiki_page_url/Run()
	saved_wiki = CONFIG_GET(string/wikiurl)
	saved_manual = CONFIG_GET(string/manual_wikiurl)

	CONFIG_SET(string/wikiurl, "https://own.wiki/w/index.php")
	CONFIG_SET(string/manual_wikiurl, null)
	TEST_ASSERT_EQUAL(wiki_page_url("Space_Law"), "https://own.wiki/w/index.php?title=Space_Law", "without MANUAL_WIKIURL the guides use WIKIURL")

	CONFIG_SET(string/manual_wikiurl, "https://tg.wiki/index.php")
	TEST_ASSERT_EQUAL(wiki_page_url("Guide_to_chemistry", "useskin=vector"), "https://tg.wiki/index.php?title=Guide_to_chemistry&useskin=vector", "MANUAL_WIKIURL wins, extra parameters follow the title")

	CONFIG_SET(string/manual_wikiurl, "https://tg.wiki/index.php?lang=zh")
	TEST_ASSERT_EQUAL(wiki_page_url("Surgery"), "https://tg.wiki/index.php?lang=zh&title=Surgery", "a setting that already has a query string gets the title appended with &")

	CONFIG_SET(string/wikiurl, null)
	CONFIG_SET(string/manual_wikiurl, null)
	TEST_ASSERT_NULL(wiki_page_url("Surgery"), "no wiki configured means no link")
