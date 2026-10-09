/// Characters a player may use to describe how their TTS voice sounds.
/// The TTS server caps instructions at 100 units with CJK counting double; this leaves
/// room for the context the game appends, such as singing.
#define TTS_INSTRUCTION_MAX_LENGTH 30
/// Where the TTS server's voice metadata is cached between rounds.
#define TTS_VOICE_INFO_CACHE "data/cached_tts_voice_info.json"
/// Voice instruction for station-wide announcements.
#define TTS_ANNOUNCER_INSTRUCTION "标准播音风格：吐字清晰精准，字正腔圆"
/// Longest composed voice instruction, in characters. All CJK counts 96 of the server's 100 units.
#define TTS_INSTRUCTION_TOTAL_MAX_LENGTH 48
/// Introduces a custom say verb that no tag covers, e.g. "说话方式：醉醺醺地说".
#define TTS_VERB_INSTRUCTION "说话方式："
/// Longest custom say verb passed on as a voice instruction, in characters.
#define TTS_VERB_INSTRUCTION_MAX_LENGTH 12
/// Voice instruction appended while singing.
#define TTS_SING_INSTRUCTION "像唱歌一样带着旋律起伏"
/// Prefix of player-made TTS voice IDs; the TTS server resolves them.
#define TTS_CUSTOM_VOICE_PREFIX "custom:"
/// Largest recording a donor may upload for voice cloning.
#define TTS_MAX_RECORDING_BYTES (10 * 1024 * 1024)
/// Longest voice design description, in characters.
#define TTS_MAX_VOICE_PROMPT_LENGTH 200
/// Longest custom voice name, in characters.
#define TTS_MAX_VOICE_NAME_LENGTH 24
/// Where uploaded recordings wait before they are sent to the TTS server.
#define TTS_UPLOAD_DIR "data/tts_voice_uploads/"
/// What an uploader confirms before a recording may be cloned. Stored with the voice for admins.
#define TTS_VOICE_CONSENT "我确认上传的录音是我本人的声音，或已获得声音本人的明确授权；同意将录音提交给语音服务商（阿里云百炼）生成音色，并用于本服务器的角色语音。"
/// Message mod: the speaker only went quiet because they spoke into a radio, so TTS keeps the normal voice.
#define MODE_TTS_RADIO_HUSH "tts_radio_hush"
