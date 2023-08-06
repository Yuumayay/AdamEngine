extends Node

# test
var input: Array
var sub_input: Array

var keybind_default: Dictionary = {
	"1k": ["Space"],
	"2k": ["F", "J"],
	"3k": ["F", "Space", "J"],
	"4k": ["D", "F", "J", "K"],
	"5k": ["D", "F", "Space", "J", "K"],
	"6k": ["S", "D", "F", "J", "K", "L"],
	"7k": ["S", "D", "F", "Space", "J", "K", "L"],
	"8k": ["A", "S", "D", "F", "H", "J", "K", "L"],
	"9k": ["A", "S", "D", "F", "Space", "H", "J", "K", "L"],
	"10k": ["A", "S", "D", "F", "V", "N", "J", "K", "L", "Equal"],
	"11k": ["A", "S", "D", "F", "V", "Space", "N", "J", "K", "L", "Equal"],
	"12k": ["A", "S", "D", "F", "C", "V", "N", "M", "J", "K", "L", "Equal"],
	"13k": ["A", "S", "D", "F", "C", "V", "Space", "N", "M", "J", "K", "L", "Equal"],
	"14k": ["A", "S", "D", "F", "X", "C", "V", "N", "M", "Comma", "J", "K", "L", "Equal"],
	"15k": ["A", "S", "D", "F", "X", "C", "V", "Space", "N", "M", "Comma", "J", "K", "L", "Equal"],
	"16k": ["A", "S", "D", "F", "Z", "X", "C", "V", "N", "M", "Comma", "Period", "J", "K", "L", "Equal"],
	"17k": ["A", "S", "D", "F", "Z", "X", "C", "V", "Space", "N", "M", "Comma", "Period", "J", "K", "L", "Equal"],
	"18k": ["A", "S", "D", "F", "Z", "X", "C", "V", "R", "U", "N", "M", "Comma", "Period", "J", "K", "L", "Equal"]
}

var keybind_default_sub: Dictionary = {}

enum {ENG, JPN}
var lang = ENG

var setting: Dictionary = {
	"category": {
		"language": {
			"language": {
				"type": "array",
				"cur": 1,
				"array": ["english", "japanese"]
			},
		},
		"keybind": {
			"4k bind": {
				"type": "bind",
				"key": 4,
				"cur": keybind_default["4k"]
			}
		},
		"gameplay": {
			"downscroll": {
				"type": "bool",
				"cur": false
			},
			"middlescroll": {
				"type": "bool",
				"cur": false
			},
			"hit sound": {
				"type": "array",
				"cur": 0,
				"array": ["None", "Osu hit", "AE hit 1", "AE hit 2", "AE hit 3", "AE hit 4", "AE hit 5", "AE hit 6", "AE hit 7", "AE hit 8", "AE hit 9", "KE clap", "KE snap", "Keystroke"],
				"metadata": ["none", "osu", "aehit1", "aehit2", "aehit3", "aehit4", "aehit5", "aehit6", "aehit7", "aehit8", "aehit9", "clap", "snap", "key"]
			},
			"hit sound volume": {
				"type": "int_range",
				"cur": 100,
				"range": [0, 200],
				"changesec": 0,
				"step": 1
			},
			"botplay": {
				"type": "bool",
				"cur": false
			},
			"practice": {
				"type": "bool",
				"cur": false
			}
		},
		"graphics": {
			"max fps": {
				"type": "int_range",
				"cur": 60,
				"range": [60, 1000],
				"changesec": 0,
				"step": 1
			},
			"show ms": {
				"type": "bool",
				"cur": true
			},
			"show kps": {
				"type": "bool",
				"cur": false
			},
			"syobon-kun": {
				"type": "bool",
				"cur": false
			}
		}
	}
}

func _ready():
	var l = "left"
	var d = "down"
	var u = "up"
	var r = "right"
	
	keybind_default_sub["1k"] = [l]
	keybind_default_sub["2k"] = [l, r]
	keybind_default_sub["3k"] = [l, d, r]
	keybind_default_sub["4k"] = [l, d, u, r]
	keybind_default_sub["5k"] = [l, d, u, u, r]
	keybind_default_sub["6k"] = [l, d, r, l, u, r]
	keybind_default_sub["7k"] = [l, d, r, u, l, u, r]
	keybind_default_sub["8k"] = [l, d, u, r, l, d, u, r]
	keybind_default_sub["9k"] = [l, d, u, r, u, l, d, u, r]
	keybind_default_sub["10k"] = [l, d, u, r, l, r, l, d, u, r]
	keybind_default_sub["11k"] = [l, d, u, r, l, u, r, l, d, u, r]
	keybind_default_sub["12k"] = [l, d, u, r, l, d, u, r, l, d, u, r]
	keybind_default_sub["13k"] = [l, d, u, r, l, d, u, u, r, l, d, u, r]
	keybind_default_sub["14k"] = [l, d, u, r, l, d, l, r, u, r, l, d, u, r]
	keybind_default_sub["15k"] = [l, d, u, r, l, d, l, u, r, u, r, l, d, u, r]
	keybind_default_sub["16k"] = [l, d, u, r, l, d, u, r, l, d, u, r, l, d, u, r]
	keybind_default_sub["17k"] = [l, d, u, r, l, d, u, r, u, l, d, u, r, l, d, u, r]
	keybind_default_sub["18k"] = [l, d, u, r, l, d, u, r, l, r, l, d, u, r, l, d, u, r]

func s_get(category: String, key: String):
	return setting.category[category][key].cur

func s_set(category: String, key: String, value):
	setting.category[category][key].cur = value
	
	setting_refresh() #設定項目の特殊更新

func setting_refresh():
	Engine.max_fps = s_get("graphics", "max fps")
	lang = s_get("language", "language") #setting.category["language"]["language"].array[s_get("language", "language")]

func s_set_array(category: String, key: String, value):
	var ind = setting.category[category][key].cur
	var array = setting.category[category][key].array
	var metadata
	if setting.category[category][key].has("metadata"):
		metadata = setting.category[category][key].metadata
	else:
		metadata = array
	var set_value = ind + value
	if array.size() <= set_value:
		set_value = 0
	if set_value == -1:
		set_value = array.size() - 1
	setting.category[category][key].cur = set_value
	if key.contains("hit sound"):
		Audio.a_stop("Scroll")
		Audio.a_play(metadata[set_value], 1.0, s_get("gameplay", "hit sound volume") * 0.5 - 50)
		
	setting_refresh() #設定項目の特殊更新

var conv_jpn := [
	["daddy dearest", "親愛なるパパ"],
	["spooky month", "コワーい ヤツら"],
	["pico", "ピコ"],
	["mommy must murder", "親愛なるママ"],
	["red snow", "クリスマスだ！"],
	["hating simulator ft. moawling", "嫉妬シュミレーター 呪"],
	["tankman", "タンクマン"],
	["options", "オプション"],
	["keybind", "ソウサヘンコウ"],
	["language", "ゲンゴ"],
	["gameplay", "ゲームプレイ"],
	["graphics", "グラフィック"],
	["upscroll", "ウエスクロール"],
	["downscroll", "シタスクロール"],
	["middlescroll", "チュウオウスクロール"],
	["hit sound", "ダケンオン"],
	["none", "ナシ"],
	["osu hit", "タイプ エー"],
	["ae hit 1", "タイプ ビー"],
	["ae hit 2", "タイプ シー"],
	["ae hit 3", "タイプ ディー"],
	["ae hit 4", "タイプ イー"],
	["ae hit 5", "タイプ エフ"],
	["ae hit 6", "タイプ ジー"],
	["ae hit 7", "タイプ エイチ"],
	["ae hit 8", "タイプ アイ"],
	["ae hit 9", "タイプ ジェイ"],
	["ke clap", "タイプ ケイ"],
	["ke snap", "タイプ エル"],
	["keystroke", "タイプ エム"],
	["bind", "ソウサ"],
	["hit sound volume", "ダケンオン オンリョウ"],
	["botplay", "オート"],
	["botplay on", "オート オン"],
	["botplay off", "オート オフ"],
	["practice", "レンシュウ"],
	["practice on", "レンシュウ オン"],
	["practice off", "レンシュウ オフ"],
	["max fps", "サイダイ エフピーエス"],
	["show ms", "エムエス ヒョウジ"],
	["show kps", "ケーピーエス ヒョウジ"],
	["syobon-kun", "ショボン ヒョウジ"],
	["english", "エイゴ"],
	["japanese", "ニホンゴ"],
	["resume", "サイカイ"],
	["restart", "リスタート"],
	["difficulty", "ナンイド"],
	["easy", "カンタン"],
	["normal", "フツウ"],
	["hard", "ムズカシイ"],
	["insane", "ゲキヤバ"],
	["true", "オン"],
	["false", "オフ"],
	["save", "セーブ"],
	["save json", "JSON セーブ"],
	["gf", "ガールフレンド"],
	["bf", "ボーイフレンド"],
	["dad", "オトウサン"],
	["perfect!!", "カンペキ！！"],
	["sick!", "スゲェ！"],
	["great", "スバラシー"],
	["good", "イイネ"],
	["nice", "ナイス"],
	["meh", "フツー"],
	["bruh", "ウーン"],
	["bad", "ダメ"],
	["shit", "ダメダメ！"],
	["you suck!", "下手くそ！"],
	["chart editor", "フメン エディター"],
	["stage editor", "ステージ エディター"],
	["modchart editor", "モッドチャート エディター"],
	["back", "メニュー ニ モドル"]
]

func eng():
	return lang == ENG

func jpn():
	return lang == JPN

# dynamic fontを使うか？
func dfont():
	return Setting.lang == JPN
	
# dynamic fontのひな形set
func set_dfont(new_item):
	if !Setting.eng():
		new_item.add_theme_font_override("font", load("Assets/Fonts/DarumadropOne-Regular.ttf"))
		new_item.add_theme_font_size_override("font_size", 100)
		new_item.add_theme_constant_override("outline_size", 25)
		new_item.add_theme_color_override("font_outline_color", Color(0, 0, 0))
	return new_item
	
# dynamic fontのひな形set
func set_dfont_mini(new_item):
	if !Setting.eng():
		new_item.add_theme_font_override("font", load("Assets/Fonts/BugMaru.ttc"))
		new_item.add_theme_color_override("font_outline_color", Color(0.5, 0.5, 0.5))
		new_item.add_theme_constant_override("shadow_outline_size", 5)
	return new_item
	
# ゲームの多言語化対応
func translate(text: String):
	if lang == JPN:
		for i in conv_jpn:
			if i[0] == text.to_lower():
				return i[1]
	return text

# ゲームの多言語から英語取得
func rev_translate(text: String):
	if lang == JPN:
		for i in conv_jpn:
			if i[1] == text.to_lower():
				return i[0]	
	return text

# JSONの翻訳データ取得　（key + "JPN" などがあれば、翻訳データなのでそれを読む
func get_translate(jsondat : Dictionary, key : String):
	var text = ""
	if Setting.lang == JPN:
		if jsondat.has(key + "JPN"):
			text = jsondat[key + "JPN"]
		else:
			text = Setting.translate(jsondat[key])
	else:
		text = jsondat[key]
	
	return text
	
