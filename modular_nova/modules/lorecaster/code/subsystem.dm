// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
SUBSYSTEM_DEF(lorecaster)
	name = "Lorecaster"
	wait = 30 MINUTES
	/// List of stories yet to have been run
	var/list/stories

/datum/controller/subsystem/lorecaster/Initialize()
	GLOB.news_network.create_feed_channel("Nanotrasen News Network", "NNN", "Get the latest stories from the frontier, here! For the not-quite-latest stories, download the \"News Archive\" app to any NTOS-based device today!", locked = TRUE)
	var/config_delay = CONFIG_GET(number/lorecaster_delay)
	if(config_delay)
		wait = config_delay
	return SS_INIT_SUCCESS

/datum/controller/subsystem/lorecaster/fire(resumed)
	if(!fexists(NEWS_FILE))
		return

	if(!length(stories)) // Ran out of stories? Run through 'em again
		stories = json_load(NEWS_FILE)
		return // But skip the cycle this time

	var/picked_story = pick(stories)
	// I18N: story title/text from config/nova/news_stories.json (`news` namespace) → reverse整串; date label LANG.
	var/text = lang_reverse_text(stories[picked_story]["text"])
	var/title = lang_reverse_text(stories[picked_story]["title"])
	text += "\n\n[LANG("_root.news_published_on", list(stories[picked_story]["month"], stories[picked_story]["day"], stories[picked_story]["year"]))]"
	GLOB.news_network.submit_article(text || LANG("_root.news_empty_article", null), title || LANG("_root.news_default_title", null), "Nanotrasen News Network", null)
	stories -= picked_story
