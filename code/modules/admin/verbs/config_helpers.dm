#define GENERATE_JOB_CONFIG_VERB_DESC "Generate a job configuration (jobconfig.toml) file for the server. If TOML file already exists, will re-generate it based off the already existing config values. Will migrate from the old jobs.txt format if necessary."

ADMIN_VERB(generate_job_config, R_SERVER, "Generate Job Configuration", GENERATE_JOB_CONFIG_VERB_DESC, ADMIN_CATEGORY_SERVER)
	if(tgui_alert(user, "如果您不是拥有配置文件目录访问权限的服务器管理员，此指令将毫无用处。您确定要继续吗？", "生成 jobconfig.toml 以供下载", list("Yes", "No")) != "Yes")
		return

	if(SSjob.generate_config(user))
		to_chat(user, span_notice("职位配置文件已生成。下载提示应会立即出现。"))
	else
		to_chat(user, span_warning("职位配置文件无法生成。请检查服务器日志/运行时/上方警告信息以获取更多详情。"))

	BLACKBOX_LOG_ADMIN_VERB("Generate Job Configuration")

#undef GENERATE_JOB_CONFIG_VERB_DESC
