/// Docks the target's pay
/datum/smite/dock_pay
	name = "Dock Pay-扣薪"

/datum/smite/dock_pay/effect(client/user, mob/living/target)
	. = ..()
	if (!iscarbon(target))
		to_chat(user, span_warning("必须对碳基生物使用。"), confidential = TRUE)
		return
	var/mob/living/carbon/dude = target
	var/obj/item/card/id/card = dude.get_idcard(TRUE)
	if (!card)
		to_chat(user, span_warning("[dude] 没有佩戴ID卡！"), confidential = TRUE)
		return
	if (!card.registered_account)
		to_chat(user, span_warning("[dude] 的ID卡没有关联账户！"), confidential = TRUE)
		return
	if (card.registered_account.account_balance == 0)
		to_chat(user,  span_warning("ID卡没有任何资金。无薪可扣。"))
		return
	var/new_cost = input("How much pay are we docking? Negative = giving money. Current balance: [card.registered_account.account_balance] [MONEY_NAME].", "预算削减") as num|null
	if (!new_cost)
		return
	if(new_cost < 0)
		card.registered_account.adjust_money(new_cost, "Central Command: Pay Bonus")
		card.registered_account.bank_card_talk("[new_cost] [MONEY_NAME] added to your account based on performance review by Central Command.", force = TRUE)
	else
		SSeconomy.add_audit_entry(card.registered_account, new_cost, "Central Command")
		card.registered_account.adjust_money(-new_cost, "Central Command: Pay Cut")
		card.registered_account.bank_card_talk("[new_cost] [MONEY_NAME] deducted from your account based on performance review by Central Command.", force = TRUE)
	SEND_SOUND(target, 'sound/machines/buzz/buzz-sigh.ogg')
