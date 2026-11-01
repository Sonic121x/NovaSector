/// wiki_page_url() (modular_zh/master_files/code/game/objects/items/wiki_manuals.dm) builds
/// index.php?title= links, which work on a wiki without short URLs.
/datum/unit_test/wiki_page_url
	var/saved_wiki

/datum/unit_test/wiki_page_url/Destroy()
	CONFIG_SET(string/wikiurl, saved_wiki)
	return ..()

/datum/unit_test/wiki_page_url/Run()
	saved_wiki = CONFIG_GET(string/wikiurl)

	CONFIG_SET(string/wikiurl, "https://tg.wiki/index.php")
	TEST_ASSERT_EQUAL(wiki_page_url("Space_Law"), "https://tg.wiki/index.php?title=Space_Law", "page link")
	TEST_ASSERT_EQUAL(wiki_page_url("Guide_to_chemistry", "useskin=vector"), "https://tg.wiki/index.php?title=Guide_to_chemistry&useskin=vector", "extra parameters follow the title")

	CONFIG_SET(string/wikiurl, "https://tg.wiki/index.php?lang=zh")
	TEST_ASSERT_EQUAL(wiki_page_url("Surgery"), "https://tg.wiki/index.php?lang=zh&title=Surgery", "a setting that already has a query string gets the title appended with &")

	CONFIG_SET(string/wikiurl, null)
	TEST_ASSERT_NULL(wiki_page_url("Surgery"), "no wiki configured means no link")
