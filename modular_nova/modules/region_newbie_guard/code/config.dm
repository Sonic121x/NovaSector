/// Master switch. Off by default; admins flip it with the "切换新人软管制" verb.
/datum/config_entry/flag/newbie_guard

/// Career living playtime, in minutes, at or above which a player is never restricted.
/datum/config_entry/number/newbie_guard_playtime
	default = 60
	min_val = 0
	integer = TRUE

/// Minutes a restricted player must stay alive this round before restrictions lift on their own.
/datum/config_entry/number/newbie_guard_survival
	default = 30
	min_val = 1
	integer = TRUE

/// How many days an admin-approved appeal keeps the player exempt.
/datum/config_entry/number/newbie_guard_bypass_days
	default = 30
	min_val = 1
	integer = TRUE
