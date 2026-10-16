/// 输入法友好按键。
///
/// 中文（日文、韩文同理）输入法开着时，游戏按键在到达 DreamSeeker 的按键宏之前就被输入法拿去组字了：
/// 按 WASD 弹出拼音候选框，人走不动，快捷键全部失灵。服务端改不了原生地图控件的输入法，能改的只有
/// 下发到客户端的浏览器控件。这里在 mapwindow 里放一个很小的 WebView2 控件当按键捕获器：
///   · 焦点停在它的不可编辑元素上时，Chromium 会对自己的窗口关闭输入法，按键原样到达页面；
///   · 页面 JS 按原生宏的格式转发（`KeyDown "W" [[map.mouse-pos]] [[map.size]]`），服务端的按键系统
///     一行不用改，按键绑定拿到的鼠标位置也和原生宏完全一致；
///   · 焦点被地图抢走（点地图、关掉说话框、关掉弹窗）时，页面在客户端本地把焦点收回来；可编辑的
///     输入框（聊天栏、说话框、TGUI 文本框）一律不抢，那些地方照常用输入法打字。
#define IME_CAPTURE_ID "ime_capture"

/datum/preference/toggle/ime_keyboard
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "ime_keyboard"
	savefile_identifier = PREFERENCE_PLAYER
	default_value = TRUE

/datum/preference/toggle/ime_keyboard/apply_to_client(client/client, value)
	if(!istype(client))
		return
	if(value)
		client.ime_capture_install()
	else
		client.ime_capture_remove()

/client
	/// 按键捕获器是否已安装并接管键盘。
	var/ime_capture_active = FALSE
	/// 页面里注入的那份宏命令（JSON），用来判断键位变了要不要重载页面。
	var/ime_capture_commands

/client/proc/ime_capture_install(take_focus = TRUE)
	winset(src, IME_CAPTURE_ID, "parent=mapwindow;type=browser;pos=0,0;size=1x1;anchor1=0,0;is-visible=true")
	ime_capture_commands = json_encode(ime_capture_macro_commands())
	var/page = file2text('modular_zh/modules/ime_keyboard/html/ime_capture.html')
	page = replacetext(page, "/*IME_MACRO_COMMANDS*/{}", ime_capture_commands)
	src << browse(page, "window=[IME_CAPTURE_ID]")
	ime_capture_active = TRUE
	if(take_focus)
		winset(src, IME_CAPTURE_ID, "focus=true")

/client/proc/ime_capture_remove()
	if(!ime_capture_active)
		return
	ime_capture_active = FALSE
	ime_capture_commands = null
	// 运行期创建的控件把 parent 清空即销毁；焦点还给地图，回到原生宏。
	winset(src, IME_CAPTURE_ID, "parent=")
	winset(src, "map", "focus=true")

/// 键位、管理员身份变了（登录时管理员身份晚于偏好设置建立、改键、上下管理员）都会走这里：
/// 页面里注入的宏命令要跟着换，否则管理员的 asay 键在捕获器里没有命令可执行。
/client/update_special_keybinds(datum/preferences/direct_prefs)
	. = ..()
	if(ime_capture_active && json_encode(ime_capture_macro_commands()) != ime_capture_commands)
		ime_capture_install(take_focus = FALSE)

/// 捕获器拿着焦点时 BYOND 的宏一个都不触发，所以除了 `Any`（由页面转发成 KeyDown/KeyUp）之外，
/// 原生宏在客户端执行的那部分（Esc 开关菜单、Tab 切到聊天栏、退格清空输入、管理员的 asay 键）
/// 要原样交给页面执行。键 → 原始命令文本（去掉皮肤参数那层引号转义）。
/client/proc/ime_capture_macro_commands()
	var/list/commands = list()
	for(var/key in SSinput.macro_set)
		if(key == "Any" || key == "Any+UP")
			continue
		commands[key] = ime_unquote_macro_command(SSinput.macro_set[key])
	if(holder && prefs?.key_bindings)
		for(var/key in prefs.key_bindings[ADMIN_CHANNEL])
			commands[key] = ime_unquote_macro_command(tgui_say_create_open_command(ADMIN_CHANNEL))
	return commands

/// 宏命令按皮肤参数的写法存（外层引号、`\n` 换行、`\"` 引号），执行前还原成原始命令文本。
/proc/ime_unquote_macro_command(command)
	if(length(command) >= 2 && copytext(command, 1, 2) == "\"" && copytext(command, -1) == "\"")
		command = copytext(command, 2, -1)
	command = replacetext(command, "\\n", "\n")
	command = replacetext(command, "\\\"", "\"")
	command = replacetext(command, "\\\\", "\\")
	return command

#undef IME_CAPTURE_ID
