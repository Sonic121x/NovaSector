/// Wiki the in-game guides open (wiki books, the revenant objectives link, the poll type guide).
/// Their page names are /tg/ wiki titles, so this can point at a wiki that has them while WIKIURL
/// (the `wiki` verb, the escape menu) stays the server's own wiki. Unset means WIKIURL.
/datum/config_entry/string/manual_wikiurl

/// Link to a page of the guides' wiki (MANUAL_WIKIURL, else WIKIURL), or null when neither is set.
///
/// Upstream joins `[WIKIURL]/[page]`, which needs the wiki's short URLs (`/wiki/Page`,
/// `/index.php/Page`). `index.php?title=Page` works on every MediaWiki whatever its URL
/// rewriting, so the setting can point at `.../index.php` of a wiki that has no short URLs.
/// `query` is appended as extra parameters, without the leading `&`.
///
/// Callers changed from `[WIKIURL]/[page]`: the wiki books (code/game/objects/items/wiki_manuals.dm),
/// the revenant objectives link and the poll type guide link in code/modules/admin/poll_management.dm
/// (inside a multi-line string, so that one carries no ZH EDIT marker).
/proc/wiki_page_url(page, query)
	var/wiki_url = CONFIG_GET(string/manual_wikiurl) || CONFIG_GET(string/wikiurl)
	if(!wiki_url)
		return null
	. = "[wiki_url][findtext(wiki_url, "?") ? "&" : "?"]title=[page]"
	if(query)
		. += "&[query]"
