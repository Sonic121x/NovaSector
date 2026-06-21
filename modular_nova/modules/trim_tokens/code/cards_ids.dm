// Proc to use a trim token on an ID
/obj/item/card/id/proc/apply_token(obj/item/trim_token/token, mob/user)
	if(token.has_required_trim)
		if(!(src.trim in token.valid_trims))
			to_chat(user, span_warning("你的ID饰边不适用于此饰边令牌。"))
			return
	if(token.uses == 0)
		to_chat(user, span_warning("当你将[token.name]按在你的ID上时，它解体了，它可能仅剩勉强维持形状的电量了！"))
		qdel(token)
		return

	// Just to make sure to give feedback if it requires a better card to grant the trim.
	if(SSid_access.apply_trim_to_card(src, token.token_trim, copy_access = token.force_access))
		playsound(src, token.usesound, 40)
		to_chat(user, span_notice("[token.name]与你的ID融合，将其饰边替换为[token.assignment]饰边！"))
		// If it's INFINITE (-1), it won't be affected by this.
		if(token.uses > 0)
			token.uses -= 1
		if(token.uses == 0)
			qdel(token)
			return
		to_chat(user, span_notice("[token.name]在你眼前重新凝固成一个实体令牌，它已成功替换了你ID的饰边。不错。"))
		return
	else
		to_chat(user, span_warning("你的ID稀有度不足以支持此饰边升级！"))
