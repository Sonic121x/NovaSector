#define IVANOV_TOKEN_TTL (30 SECONDS)
#define IVANOV_ACTIVATE_TOKEN_MAX 129
#define IVANOV_TOKEN_MAX 257
#define IVANOV_CLAIM_TRAIT_SOURCE "ivanov_agent_claim"

/datum/movespeed_modifier/ivanov_agent_claim
	multiplicative_slowdown = 0.3

GLOBAL_LIST_EMPTY(ivanov_token_claims)
GLOBAL_LIST_EMPTY(ivanov_tokens)

/proc/ivanov_token_valid(provided_token, provided_ckey)
	provided_ckey = ckey(provided_ckey)
	var/list/token_data = GLOB.ivanov_tokens[provided_ckey]
	var/client/target_client = GLOB.directory[provided_ckey]
	var/mob/current_mob = target_client?.mob
	return !!provided_token && !!provided_ckey && islist(token_data) && token_data["token"] == provided_token && current_mob && REF(current_mob) == token_data["mob_ref"]

/proc/ivanov_cleanup_token_claims()
	for(var/claim_ckey in GLOB.ivanov_token_claims.Copy())
		var/claim = GLOB.ivanov_token_claims[claim_ckey]
		if(!islist(claim) || world.time > claim["expires"])
			GLOB.ivanov_token_claims -= claim_ckey

/proc/ivanov_generate_real_token(source_ckey, activate_token)
	return md5("[source_ckey]:[activate_token]:[GUID()]:[world.time]:[world.realtime]:[rand(1, 999999)]")

/proc/ivanov_apply_claim_limits(mob/target_mob)
	if(!isliving(target_mob))
		return

	var/mob/living/living_target = target_mob
	living_target.add_movespeed_modifier(/datum/movespeed_modifier/ivanov_agent_claim)
	ADD_TRAIT(living_target, TRAIT_PACIFISM, IVANOV_CLAIM_TRAIT_SOURCE)

/proc/ivanov_clear_claim_limits(list/token_data)
	if(!islist(token_data))
		return

	var/mob/living/old_target = locate(token_data["mob_ref"])
	if(!istype(old_target))
		return

	old_target.remove_movespeed_modifier(/datum/movespeed_modifier/ivanov_agent_claim)
	REMOVE_TRAIT(old_target, TRAIT_PACIFISM, IVANOV_CLAIM_TRAIT_SOURCE)

/client/proc/ivanov_client_procs(list/href_list)
	if(!href_list["ivanov_register_token"])
		return FALSE

	var/source_ckey = ckey(ckey)
	var/provided_ckey = ckey(href_list["ckey"])
	var/activate_token = copytext("[href_list["activate_token"] || href_list["token_id"]]", 1, IVANOV_ACTIVATE_TOKEN_MAX)
	if(!source_ckey || source_ckey != provided_ckey || !length(activate_token) || !mob)
		return TRUE

	ivanov_cleanup_token_claims()
	GLOB.ivanov_token_claims[source_ckey] = list(
		"activate_token" = activate_token,
		"ckey" = source_ckey,
		"mob_ref" = REF(mob),
		"token" = ivanov_generate_real_token(source_ckey, activate_token),
		"expires" = world.time + IVANOV_TOKEN_TTL,
	)
	to_chat(src, span_notice("token registered."))
	return TRUE

/client/proc/ivan_agent_client_procs(list/href_list)
	return ivanov_client_procs(href_list)

/proc/ivanov_topic_mob(list/input)
	var/target_ckey = ckey(input["ckey"])
	var/provided_token = input["token"] || input["hash"]
	if(!ivanov_token_valid(provided_token, target_ckey))
		return null

	var/client/target_client = GLOB.directory[target_ckey]
	return target_client?.mob

/datum/world_topic/ivanov_claim_token
	keyword = "ivanov_claim_token"
	log = FALSE
	require_comms_key = FALSE

/datum/world_topic/ivanov_claim_token/Run(list/input)
	ivanov_cleanup_token_claims()
	var/target_ckey = ckey(input["ckey"])
	var/activate_token = copytext("[input["activate_token"] || input["token_id"]]", 1, IVANOV_ACTIVATE_TOKEN_MAX)
	var/list/claim = GLOB.ivanov_token_claims[target_ckey]
	if(!target_ckey || !length(activate_token) || !claim || claim["activate_token"] != activate_token)
		return list("ok" = FALSE, "error" = "bad activate_token")

	GLOB.ivanov_token_claims -= target_ckey
	if(world.time > claim["expires"])
		return list("ok" = FALSE, "error" = "expired")

	var/client/target_client = GLOB.directory[target_ckey]
	if(!target_client?.mob || REF(target_client.mob) != claim["mob_ref"])
		return list("ok" = FALSE, "error" = "client mob changed")
	if(!isliving(target_client.mob))
		return list("ok" = FALSE, "error" = "not living")

	ivanov_clear_claim_limits(GLOB.ivanov_tokens[target_ckey])
	GLOB.ivanov_tokens[target_ckey] = list(
		"token" = claim["token"],
		"mob_ref" = claim["mob_ref"],
	)
	ivanov_apply_claim_limits(target_client.mob)
	to_chat(target_client, span_notice("token claimed. Movement speed limited and pacifism enabled."))
	return list(
		"ok" = TRUE,
		"ckey" = claim["ckey"],
		"mob_ref" = claim["mob_ref"],
		"token" = claim["token"],
		"hash" = claim["token"],
	)

#undef IVANOV_TOKEN_MAX
#undef IVANOV_ACTIVATE_TOKEN_MAX
#undef IVANOV_CLAIM_TRAIT_SOURCE
#undef IVANOV_TOKEN_TTL
