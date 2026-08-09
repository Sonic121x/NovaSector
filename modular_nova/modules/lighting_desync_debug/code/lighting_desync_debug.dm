/**
 * LIGHTING_DESYNC_DEBUG
 *
 * 诊断用管理员 verb：手动强制刷新视野内的静态 turf 光照。
 *
 * 背景：玩家瞬移 / 换 z 层 / 鬼魂观察落地后，整屏静态光照缺失呈灰色，且不会自愈。
 * 已确认服务端算得没问题（SSlighting 队列为空），覆盖层光照（手电光斑）也画得出来，
 * 唯独 turf.vis_contents 里的 lighting_object 外观没送达客户端；服务端认为已发送、
 * 不再重发，只有静态光照真正变化（例如开门触发 reconsider_lights）或格子重进视野才恢复。
 *
 * 这个 verb 不修任何东西，它是一次判别实验：三种策略的成败互为对照，
 * 用来确定"重发被什么抑制了"，再据此决定真正的修法挂在哪。
 */

/// 仅重算外观。若外观算出来和原来一致，BYOND 不会重发 —— 预期无效。
#define LIGHTING_REFRESH_UPDATE "仅重算外观 (update)"
/// 从 turf.vis_contents 摘除再加回。这是结构变更，BYOND 必须传输 —— 预期有效。
#define LIGHTING_REFRESH_VIS_CONTENTS "vis_contents 摘除再加回"
/// 先强制改成明显不同的外观，隔一个 tick 再还原。最粗暴，必定产生外观 diff。
#define LIGHTING_REFRESH_FORCE_DIFF "强制改变外观再还原"

ADMIN_VERB(refresh_static_lighting, R_DEBUG, "调试-刷新视野静态光照", "Force-refreshes static turf lighting in view. Diagnostic for the grey-mask desync.", ADMIN_CATEGORY_DEBUG)
	var/turf/center = get_turf(user.eye) || get_turf(user.mob)
	if(!isturf(center))
		to_chat(user, span_warning("找不到你的视点所在 turf。"))
		return

	var/strategy = tgui_input_list(
		user,
		"选择刷新策略。三者成败互为对照：若『仅重算外观』无效而『vis_contents 摘除再加回』有效，即证实重发被外观 diff 抑制。",
		"刷新静态光照",
		list(LIGHTING_REFRESH_UPDATE, LIGHTING_REFRESH_VIS_CONTENTS, LIGHTING_REFRESH_FORCE_DIFF),
	)
	if(!strategy)
		return

	// 用 range() 而非 view()：我们要覆盖整个渲染方块，不受视线阻挡影响。
	var/list/targets = list()
	for(var/turf/nearby in range(user.view, center))
		if(nearby.lighting_object)
			targets += nearby.lighting_object

	if(!length(targets))
		to_chat(user, span_warning("视野内没有任何 lighting_object（可能整片都是 static_lighting = FALSE 的区域，例如海洋/露天）。"))
		return

	switch(strategy)
		if(LIGHTING_REFRESH_UPDATE)
			for(var/atom/movable/lighting_object/light as anything in targets)
				light.update()

		if(LIGHTING_REFRESH_VIS_CONTENTS)
			for(var/atom/movable/lighting_object/light as anything in targets)
				var/turf/owner = light.affected_turf
				if(!isturf(owner))
					continue
				owner.vis_contents -= light
				owner.vis_contents += light

		if(LIGHTING_REFRESH_FORCE_DIFF)
			// 两趟之间必须跨 tick，否则 BYOND 会把改动与还原合并成"没变化"，等于什么都没发生。
			for(var/atom/movable/lighting_object/light as anything in targets)
				light.icon_state = "lighting_dark"
				light.color = null
			sleep(1)
			for(var/atom/movable/lighting_object/light as anything in targets)
				if(QDELETED(light))
					continue
				light.update()

	to_chat(user, span_notice("已对 [length(targets)] 个 lighting_object 执行『[strategy]』。"))
	log_admin("[key_name(user)] 对 [AREACOORD(center)] 视野内 [length(targets)] 个 lighting_object 执行了静态光照刷新：[strategy]")
	BLACKBOX_LOG_ADMIN_VERB("Refresh Static Lighting")

#undef LIGHTING_REFRESH_UPDATE
#undef LIGHTING_REFRESH_VIS_CONTENTS
#undef LIGHTING_REFRESH_FORCE_DIFF
