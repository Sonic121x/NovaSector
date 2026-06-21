// Hey listen! Imgur doesn't actually work, it's been tested.

/datum/preference/text/headshot
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	savefile_identifier = PREFERENCE_CHARACTER
	savefile_key = "headshot"
	maximum_value_length = MAX_MESSAGE_LEN
	///How much time between the informational chat messages?
	var/cooldown_duration = 1 MINUTES
	///Handles the informational chat message timer.
	var/cooldown_timer = 0
	///Assoc list of ckeys and their links, used to cut down on chat spam
	var/list/stored_links = list()
	var/static/link_regex = regex(@"i\.gyazo\.com|[a-z]\.l3n\.co|images2\.imgbox\.com|thumbs2\.imgbox\.com|files\.byondhome\.com")
	var/static/list/valid_extensions = list("jpg", "png", "jpeg") // Regex works fine, if you know how it works

/datum/preference/text/headshot/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	target?.dna.features[EXAMINE_DNA_HEADSHOT] = value

/datum/preference/text/headshot/is_valid(value)
	if(!length(value))
		return TRUE

	var/find_index = findtext(value, "https://")
	if(find_index != 1)
		to_chat(usr, span_warning("你的链接必须是 https！"))
		return

	if(!findtext(value, "."))
		to_chat(usr, span_warning("链接无效！"))
		return
	var/list/value_split = splittext(value, ".")

	// extension will always be the last entry
	var/extension = value_split[length(value_split)]
	if(!(extension in valid_extensions))
		to_chat(usr, span_warning("图像必须是以下扩展名之一：'[english_list(valid_extensions)]'"))
		return

	find_index = findtext(value, link_regex)
	if(find_index != 9)
		to_chat(usr, span_warning("The image must be hosted on one of the following sites: 'Gyazo (i.gyazo.com), Byond (files.byondhome.com), Imgbox (images2.imgbox.com, thumbs2.imgbox.com), Lensdump (x.l3n.co)'"))
		return

	if(stored_links[usr.ckey] && stored_links[usr.ckey][type] != value && cooldown_timer <= world.time)
		cooldown_timer = cooldown_duration + world.time
		to_chat(usr, span_notice("请使用相对适合工作环境的头部和肩部图像，以保持沉浸感。可以把它想象成你身份证上的头像。最后，[span_bold("do not use a real life photo or use any image that is less than serious.")]"))
		to_chat(usr, span_notice("如果照片在游戏中没有正确显示，请确保它是一个能在浏览器中正常打开的直链图片链接。"))
		to_chat(usr, span_notice("请注意，照片将被缩小至250x250像素，因此照片越接近正方形，效果就越好。"))
		log_game("[usr] has set their Headshot image to '[value]'.")

	apply_headshot(value)
	return TRUE

/datum/preference/text/headshot/proc/apply_headshot(value)
	if(isnull(stored_links[usr?.ckey]))
		stored_links[usr?.ckey] = list()
	stored_links[usr?.ckey][type] = value
	return TRUE

/datum/preference/text/headshot/silicon
	savefile_key = "silicon_headshot"

/datum/preference/text/headshot/silicon/apply_to_human(mob/living/carbon/human/target, value, datum/preferences/preferences)
	return FALSE
