// Make sure that the code compiles with AI_VOX undefined
#ifdef AI_VOX

/mob/living/silicon/ai
	/// The currently selected VOX Announcer voice.
	var/vox_type = VOX_BMS
	/// The list of available VOX Announcer voices to choose from.
	var/list/vox_voices = list(VOX_HL, VOX_NORMAL, VOX_BMS, VOX_MIL) // NOVA EDIT CHANGE - ORIGINAL: var/list/vox_voices = list(VOX_HL, VOX_NORMAL, VOX_BMS)
	/// The VOX word(s) that were previously inputed.
	var/vox_word_string

/// Returns a list of vox sounds based on the sound_type passed in
/mob/living/silicon/ai/proc/get_vox_sounds(vox_type)
	switch(vox_type)
		if(VOX_NORMAL)
			return GLOB.vox_sounds
		if(VOX_HL)
			return GLOB.vox_sounds_hl
		if(VOX_BMS)
			return GLOB.vox_sounds_bms
		if(VOX_MIL)
			return GLOB.vox_sounds_mil
	return GLOB.vox_sounds

GAME_VERB_DESC(/mob/living/silicon/ai, switch_vox, "切换沃克斯语音", "Switch your VOX announcement voice!", "AI Commands")
	if(incapacitated)
		return
	var/selection = tgui_input_list(src, LANG("mob.9a2655f50b096f86", null), LANG("mob.e1b6c58dcb4a6bda", null), vox_voices)
	if(selection == null)
		return
	vox_type = selection

	to_chat(src, LANG("mob.403e8ab99ab4a818", list(vox_type)))


GAME_VERB_DESC(/mob/living/silicon/ai, display_word_string, "显示词串", "Display the list of recently pressed vox lines.", "AI Commands")
	if(incapacitated)
		return

	to_chat(src, vox_word_string)

GAME_VERB_DESC(/mob/living/silicon/ai, clear_word_string, "清除词串", "Clear recent vox words.", "AI Commands")
	vox_word_string = ""

#endif
