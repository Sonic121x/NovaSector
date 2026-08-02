/// Legacy browse localization must translate only visible labels, never role-ban form identifiers or values.
/datum/unit_test/i18n_roleban

#define I18N_ROLEBAN_TEST_LOCALE "i18n-roleban-unittest"
#define I18N_ROLEBAN_TRANSLATED_TITLE "安保主管"

/datum/unit_test/i18n_roleban/Run()
	var/saved_locale = GLOB.i18n_server_locale
	var/list/en_cache = GLOB.i18n_cache[DEFAULT_UI_LOCALE]
	if(!islist(en_cache))
		en_cache = list()
		GLOB.i18n_cache[DEFAULT_UI_LOCALE] = en_cache
	en_cache["roleban_title"] = JOB_HEAD_OF_SECURITY
	GLOB.i18n_cache[I18N_ROLEBAN_TEST_LOCALE] = list("roleban_title" = I18N_ROLEBAN_TRANSLATED_TITLE)

	GLOB.i18n_reverse.Remove(I18N_ROLEBAN_TEST_LOCALE)
	GLOB.i18n_fallback_state.Remove(I18N_ROLEBAN_TEST_LOCALE)
	GLOB.i18n_fallback_single_state.Remove(I18N_ROLEBAN_TEST_LOCALE)
	GLOB.i18n_fallback_cache.Remove(I18N_ROLEBAN_TEST_LOCALE)
	GLOB.i18n_server_locale = I18N_ROLEBAN_TEST_LOCALE

	var/role_field = roleban_field_name(JOB_HEAD_OF_SECURITY)
	var/group_field = roleban_group_field_name("Security")
	var/list/form_fields = list()
	form_fields[role_field] = "1"
	var/list/submitted_fields = params2list(list2params(form_fields))
	var/html = {"<form data-role='[JOB_HEAD_OF_SECURITY]'>
		<input type='checkbox' name='[role_field]' class='[group_field]' value='1'>
		<span>[JOB_HEAD_OF_SECURITY]</span>
		<a href='byond://?src=admin;addjobslot=[JOB_HEAD_OF_SECURITY]'>[JOB_HEAD_OF_SECURITY]</a>
		<textarea name='reason'>[JOB_HEAD_OF_SECURITY]</textarea>
		<script>const role = '[JOB_HEAD_OF_SECURITY]';</script>
		<style>.role::after { content: '[JOB_HEAD_OF_SECURITY]'; }</style>
	</form>"}
	var/localized_html = lang_fallback_apply_html(html, I18N_ROLEBAN_TEST_LOCALE)

	TEST_ASSERT(findtext(localized_html, "data-role='[JOB_HEAD_OF_SECURITY]'"), "HTML attributes must remain canonical English")
	TEST_ASSERT(findtext(localized_html, "name='[role_field]'"), "Encoded role field changed during browse localization")
	TEST_ASSERT(findtext(localized_html, "class='[group_field]'"), "Stable group field changed during browse localization")
	TEST_ASSERT(findtext(localized_html, "<span>[I18N_ROLEBAN_TRANSLATED_TITLE]</span>"), "Visible role label was not localized")
	TEST_ASSERT(findtext(localized_html, "href='byond://?src=admin;addjobslot=[JOB_HEAD_OF_SECURITY]'"), "Manage Job Slots href value was localized")
	TEST_ASSERT(findtext(localized_html, ">[I18N_ROLEBAN_TRANSLATED_TITLE]</a>"), "Manage Job Slots visible role label was not localized")
	TEST_ASSERT(findtext(localized_html, "<textarea name='reason'>[JOB_HEAD_OF_SECURITY]</textarea>"), "Textarea form value was localized")
	TEST_ASSERT(findtext(localized_html, "const role = '[JOB_HEAD_OF_SECURITY]'"), "Script body was localized")
	TEST_ASSERT(findtext(localized_html, "content: '[JOB_HEAD_OF_SECURITY]'"), "Style body was localized")

	TEST_ASSERT_EQUAL(roleban_role_from_field(role_field), JOB_HEAD_OF_SECURITY, "Encoded role field did not decode to the canonical job title")
	TEST_ASSERT(role_field in submitted_fields, "Encoded role field did not survive HTML form parameter serialization")
	TEST_ASSERT_NULL(roleban_role_from_field(roleban_field_name(I18N_ROLEBAN_TRANSLATED_TITLE)), "Translated or forged role field passed the server allowlist")
	TEST_ASSERT_NULL(roleban_role_from_field(JOB_HEAD_OF_SECURITY), "Unencoded role field passed validation")

	GLOB.i18n_server_locale = saved_locale
	GLOB.i18n_reverse.Remove(I18N_ROLEBAN_TEST_LOCALE)
	GLOB.i18n_fallback_state.Remove(I18N_ROLEBAN_TEST_LOCALE)
	GLOB.i18n_fallback_single_state.Remove(I18N_ROLEBAN_TEST_LOCALE)
	GLOB.i18n_fallback_cache.Remove(I18N_ROLEBAN_TEST_LOCALE)
	GLOB.i18n_cache.Remove(I18N_ROLEBAN_TEST_LOCALE)
	en_cache.Remove("roleban_title")

#undef I18N_ROLEBAN_TEST_LOCALE
#undef I18N_ROLEBAN_TRANSLATED_TITLE
