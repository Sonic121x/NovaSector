// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md

ADMIN_VERB(requests, R_NONE, "请求管理器", "Open the request manager panel to view all requests during this round", ADMIN_CATEGORY_GAME)
	GLOB.requests.ui_interact(usr)
	BLACKBOX_LOG_ADMIN_VERB("Request Manager")
