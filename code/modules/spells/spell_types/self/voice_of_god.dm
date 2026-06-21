/datum/action/cooldown/spell/voice_of_god
	name = "上帝之声"
	desc = "以极具感染力的口吻讲话，迫使听众服从你的指令。"
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "voice_of_god"
	sound = 'sound/effects/magic/clockwork/invoke_general.ogg'

	cooldown_time = 120 SECONDS // Varies depending on command
	invocation = "" // Handled by the VOICE OF GOD itself
	invocation_type = INVOCATION_SHOUT
	spell_requirements = NONE
	antimagic_flags = NONE

	/// The command to deliver on cast
	var/command
	/// The modifier to the cooldown, after cast
	var/cooldown_mod = 1
	/// The modifier put onto the power of the command
	var/power_mod = 1
	/// A list of spans to apply to commands given
	var/list/spans = list("colossus", "yell")

/datum/action/cooldown/spell/voice_of_god/before_cast(atom/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return

	command = tgui_input_text(cast_on, "以神之音发言", "命令", max_length = MAX_MESSAGE_LEN)
	if(QDELETED(src) || QDELETED(cast_on) || !can_cast_spell())
		return . | SPELL_CANCEL_CAST
	if(!command)
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/voice_of_god/cast(atom/cast_on)
	. = ..()
	var/command_cooldown = voice_of_god(uppertext(command), cast_on, spans, base_multiplier = power_mod)
	cooldown_time = (command_cooldown * cooldown_mod)

// "Invocation" is done by the actual voice of god proc
/datum/action/cooldown/spell/voice_of_god/invocation(mob/living/invoker)
	return

/datum/action/cooldown/spell/voice_of_god/clown
	name = "小丑之音"
	desc = "用一种非常有趣的声音说话，让人们在短时间内惊讶地服从你。"
	sound = 'sound/misc/scary_horn.ogg'
	cooldown_mod = 0.5
	power_mod = 0.1
	spans = list("clown")
