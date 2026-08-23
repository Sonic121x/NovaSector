// Proc to use a trim token on an ID
/obj/item/card/id/proc/apply_token(obj/item/trim_token/token, mob/user)
	if(token.has_required_trim)
		if(!(src.trim in token.valid_trims))
			to_chat(user, span_warning(LANG("obj.226276f01519278c", null)))
			return
	if(token.uses == 0)
		to_chat(user, span_warning(LANG("obj.762f86eadc1419ec", list(token.name))))
		qdel(token)
		return

	// Just to make sure to give feedback if it requires a better card to grant the trim.
	if(SSid_access.apply_trim_to_card(src, token.token_trim, copy_access = token.force_access))
		playsound(src, token.usesound, 40)
		to_chat(user, span_notice(LANG("obj.60fadbe668511916", list(token.name, token.assignment))))
		// If it's INFINITE (-1), it won't be affected by this.
		if(token.uses > 0)
			token.uses -= 1
		if(token.uses == 0)
			qdel(token)
			return
		to_chat(user, span_notice(LANG("obj.2427364ce8b8c59b", list(token.name))))
		return
	else
		to_chat(user, span_warning(LANG("obj.7032080c77b40fa3", null)))
