/// Link to a page of the configured wiki (WIKIURL), or null when no wiki is configured.
///
/// Upstream joins `[WIKIURL]/[page]`, which needs the wiki's short URLs (`/wiki/Page`,
/// `/index.php/Page`). `index.php?title=Page` works on every MediaWiki whatever its URL
/// rewriting, so WIKIURL can point at `.../index.php` of a wiki that has no short URLs.
/// `query` is appended as extra parameters, without the leading `&`.
///
/// Callers changed from `[WIKIURL]/[page]`: the wiki books (code/game/objects/items/wiki_manuals.dm),
/// the revenant objectives link and the poll type guide link in code/modules/admin/poll_management.dm
/// (inside a multi-line string, so that one carries no ZH EDIT marker).
/proc/wiki_page_url(page, query)
	var/wiki_url = CONFIG_GET(string/wikiurl)
	if(!wiki_url)
		return null
	. = "[wiki_url][findtext(wiki_url, "?") ? "&" : "?"]title=[page]"
	if(query)
		. += "&[query]"
