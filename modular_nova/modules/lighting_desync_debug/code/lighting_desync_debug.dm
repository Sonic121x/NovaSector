/**
 * LIGHTING_DESYNC_DEBUG
 *
 * 玩家自助按钮：强制重新同步视野内的静态 turf 光照。
 *
 * 绕开一个 BYOND 引擎缺陷：视野被整批替换时（瞬移、换 z 层、鬼魂观察落地、新出生），
 * 客户端拿到的 turf 静态光照外观是错的，而服务端认定外观没变、永不重发，于是整屏
 * 呈灰色遮罩且**不会自愈**——站着不动 60 秒一格都不恢复，只有静态光照真正变化
 * （例如开门触发 reconsider_lights）或那些格子离开视野再进来才会修正。
 *
 * 生产环境实测过三种手段，这里用的是唯一有效的那种：
 *   1. 仅调用 lighting_object.update() 重算外观 —— 无效
 *   2. 从 turf.vis_contents 摘除再加回          —— 无效
 *   3. 先改成明显不同的外观，跨 tick 后再还原    —— 有效
 *
 * 失配发生在**外观 ID 这一层**：既不是外观算错了，也不是容器关系的问题，只有制造一次
 * 真实且跨越 tick 边界的外观 diff 才能逼服务端重发。
 *
 * 做成手动而非自动，是因为根因（为什么只在高人数服触发）尚未查清，不宜让全服在每次
 * 跳变时都付出代价；交给撞上的玩家自己按。
 *
 * 上游同类问题：tgstation#95948（被官方标为 BYOND Issue）、#96002，均未修复。
 * BYOND 516.1686 仍复现。
 */

/// 与 lighting_object.update() 里判定「不发光」时写入的 icon_state 一致
#define LIGHTING_RESYNC_DARK_STATE "lighting_dark"
/// 防刷。重同步要遍历整屏 turf 并写两趟外观，不该被连点。
#define LIGHTING_RESYNC_COOLDOWN (10 SECONDS)

/client
	COOLDOWN_DECLARE(lighting_resync_cooldown)

GAME_VERB_DESC(/client, fix_lighting, "修复光照bug", "Forces static lighting in view to redraw, for when teleporting leaves the screen greyed out.", "OOC")
	if(!COOLDOWN_FINISHED(src, lighting_resync_cooldown))
		to_chat(src, span_warning(LANG("client.e3b7e6fe", null)))
		return
	var/turf/center = get_turf(eye) || get_turf(mob)
	if(!isturf(center))
		return
	COOLDOWN_START(src, lighting_resync_cooldown, LIGHTING_RESYNC_COOLDOWN)

	var/list/touched = list()
	for(var/turf/nearby in range(view, center))
		var/atom/movable/lighting_object/light = nearby.lighting_object
		// 已经是暗态的本来就没画错，跳过能省掉大半写入
		if(isnull(light) || light.icon_state == LIGHTING_RESYNC_DARK_STATE)
			continue
		touched += light
		light.icon_state = LIGHTING_RESYNC_DARK_STATE
		light.color = null

	if(!length(touched))
		to_chat(src, span_notice(LANG("client.c69c470e", null)))
		return

	// 必须跨 tick。同一 tick 内改了又改回，BYOND 会把两次写入合并成「没有变化」，
	// 于是既不重发也不重绘，等于什么都没做。
	addtimer(CALLBACK(src, PROC_REF(finish_lighting_resync), touched), 1)
	to_chat(src, span_notice(LANG("client.d9ac69f4", null)))

/// 第二趟：还原真实光照。update() 会按当前 corner 重算出正确外观。
/client/proc/finish_lighting_resync(list/touched)
	for(var/atom/movable/lighting_object/light as anything in touched)
		if(QDELETED(light) || !isturf(light.affected_turf))
			continue
		light.update()

#undef LIGHTING_RESYNC_DARK_STATE
#undef LIGHTING_RESYNC_COOLDOWN
