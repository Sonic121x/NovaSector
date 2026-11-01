/// 本局出现过的玩家角色名（身份名）。TGUI 负载本地化（`lang_payload_localize`）见到它们一律不翻。
///
/// 负载里的显示值靠「整串反查」翻译，而反查表只认字符串、不认来源：玩家给角色起名 `Not`，目录里
/// 恰好有电路「非门」的 `Not` → `不是`，于是环绕菜单里这个人就叫「不是」。字符串本身分不出这是人名
/// 还是物品名，只有服务器在**设名的那一刻**知道，所以在那里登记。
///
/// 判据沿用显示边界那条（`lang_localize_name_for_display`）：名字偏离 `initial(name)` 才是身份名，
/// 等于 `initial(name)` 的是类型标签（玩家控制的 `mouse`、`pAI`），照常翻译。整局只增不减：
/// 改过名的人旧名字仍可能留在别人的记录、菜单里。
GLOBAL_LIST_EMPTY(i18n_identity_names)

/proc/lang_register_identity_name(mob/owner, name)
	if(!istext(name) || !length(name) || name == initial(owner.name))
		return
	GLOB.i18n_identity_names[name] = TRUE

/mob/Login()
	. = ..()
	if(!. || isnewplayer(src))
		return
	lang_register_identity_name(src, name)
	lang_register_identity_name(src, real_name)

/mob/fully_replace_character_name(oldname, newname, log_new_name = FALSE)
	. = ..()
	if(. && (mind || client))
		lang_register_identity_name(src, newname)
