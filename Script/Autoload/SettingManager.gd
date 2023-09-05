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

var desc := {
	"language": "Switch language.",
	"language/language": "Select language :D",
	"keybind": "Change the keybind.",
	"bind": "What kind of bind do you want?"
}

var descJPN := {
	"language": "言語の変更ができるよ。",
	"language/language": "言語をえらんでね。",
	"keybind": "操作の変更ができるよ。",
	"4k bind": "何にするのかな？",
	"gameplay": "ゲームプレイまわりの設定だよ。",
	"downscroll": "オンにすると、スクロール方向が下になるよ。",
	"middlescroll": "オンにすると、真ん中に\nノーツが降ってくるようになるよ。",
	"hit sound": "ノーツを打ったときの音をカスタマイズできるよ。",
	"hit sound volume": "ノーツを打ったときの音の音量を上げることができるよ。\n[wait][concern]上げすぎると、鼓膜が死ぬよ。",
	"botplay": "全部オートプレイになるよ。\n[wait][angry]人生も全部自動で上手くいってくれればいいのにね。",
	"practice": "HPが0になっても、ゲームオーバーにならなくなるよ。\n[wait][happy]さぁ、練習練習！",
	"deathmatch": "1回のミスでゲームオーバーになるようにするよ。\n[wait][happy]スリル満点だね！",
	"max fps": "FPSの最大値を変えられるよ。\n注意：上げすぎるとPCにとても負荷がかかるよ！！",
	"show ms": "ms表示の切り替えができるよ。",
	"show kps": "KPS表示の切り替えができるよ。\nスパム曲で試してみよう！",
	"syobon-kun": "オンにすると、しょぼん君が画面に現れてキーボードを叩くよ。\n現在、4Kしか対応してないよ。",
	"engine type": "FNF次元を自由自在に移動することができるよ。",
	"visuals and ui": "見た目とかの設定だよ。\n[wait][concern]グラフィックとの違いは、いまいちわからん。",
	"graphics": "見た目とかの設定だよ。\n[wait][concern]ユーアイとの違いは、いまいちわからん。",
	
	"name": "いろいろな物の名前を変えることができるよ。",
	"display": "表示関連のオプションだよ。",
	"marvelous name": "Marvelousの呼び名を変更できるよ。",
	"sick name": "Sickの呼び名を変更できるよ。",
	"good name": "Goodの呼び名を変更できるよ。",
	"bad name": "Badの呼び名を変更できるよ。",
	"shit name": "Shitの呼び名を変更できるよ。",
	"miss name": "Missの呼び名を変更できるよ。",
	"score name": "Scoreの呼び名を変更できるよ。",
	"accuracy name": "Accuracyの呼び名を変更できるよ。",
	"rating name": "Ratingの呼び名を変更できるよ。",
	"health name": "Healthの呼び名を変更できるよ。",
	"combo name": "Comboの呼び名を変更できるよ。",
	"max combo name": "Max Comboの呼び名を変更できるよ。",
	"use marvelous": "Sickより高い評価(Marvelous)を使うかどうかの設定だよ。",
	"use winning icon": "勝利アイコンを使うか使わないかの設定だよ。オンにしても、\n必ずアイコンを３つ用意しなければいけないわけではないから安心！",
	"shit to miss": "ShitがMissになるかどうかの設定だよ。",
	"show turn timer": "次のターンまでの時間を表示するタイマーの切り替えだよ。"
}

var setting: Dictionary = {
	"category": {
		"language": {
			"language": {
				"type": "array",
				"cur": 1,
				"array": ["english", "japanese"],
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
				"cur": true
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
			},
			"deathmatch": {
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
			},
		},
		"visuals and ui": {
			"engine type": {
				"type": "engineType",
				"cur": 0,
				"array": [{"name": "Engines", "data": ["Adam Engine", "Psych Engine", "Leather Engine", "Denpa Engine"], "metadata": ["adam", "psych", "leather", "denpa"]}, {"name": "Kade Engine", "data": ["KE 1.2", "KE 1.4", "KE 1.8"], "metadata": ["kade12", "kade14", "kade18"]}],#, {"name": "Mod Presets", "data": ["Human Impostor", "Strident Crisis", "Voiid Chronicles"], "metadata": ["other a", "other b", "voiid"]}],
				"metadata": ["adam", "psych", "leather", "denpa", "kade12", "kade14", "kade18"],#, "other a", "other b", "voiid"]
				#"array": ["Adam Engine", "Psych Engine", "Kade Engine 1.2", "Kade Engine 1.4", "Kade Engine 1.8", "Leather Engine", "Denpa Engine", "Other A", "Other B"],
				#"metadata": ["adam", "psych", "kade12", "kade14", "kade18", "leather", "denpa", "other a", "other b"]
			}
		}
	}
}

var adv_setting := {
	"category": {
		"name": {
			"marvelous name": {
				"type": "textEdit",
				"cur": "Marvelous"
			},
			"sick name": {
				"type": "textEdit",
				"cur": "Sick"
			},
			"good name": {
				"type": "textEdit",
				"cur": "Good"
			},
			"bad name": {
				"type": "textEdit",
				"cur": "Bad"
			},
			"shit name": {
				"type": "textEdit",
				"cur": "Shit"
			},
			"miss name": {
				"type": "textEdit",
				"cur": "Misses"
			},
			"score name": {
				"type": "textEdit",
				"cur": "Score"
			},
			"accuracy name": {
				"type": "textEdit",
				"cur": "Accuracy"
			},
			"rating name": {
				"type": "textEdit",
				"cur": "Rating"
			},
			"health name": {
				"type": "textEdit",
				"cur": "Health"
			},
			"combo name": {
				"type": "textEdit",
				"cur": "Combo"
			},
			"max combo name": {
				"type": "textEdit",
				"cur": "Max Combo"
			},
		},
		"display": {
			"show turn timer": {
				"type": "bool",
				"cur": false
			},
			"text rating counter": {
				"type": "bool",
				"cur": false
			},
			"show song credits": {
				"type": "bool",
				"cur": false
			},
			"show \"screw you\" text": {
				"type": "bool",
				"cur": false
			},
			"use splash": {
				"type": "bool",
				"cur": false
			}
		},
		"gimmics": {
			"shit to miss": {
				"type": "bool",
				"cur": false
			},
			"use marvelous": {
				"type": "bool",
				"cur": true
			},
			"use winning icon": {
				"type": "bool",
				"cur": true
			},
			"use currency": {
				"type": "bool",
				"cur": false
			},
			"currency name": {
				"type": "textEdit",
				"cur": "Coin"
			},
			"currency name (short)": {
				"type": "textEdit",
				"cur": "C"
			}
		},
		"modchart": {
			"load song script": {
				"type": "bool",
				"cur": true
			},
			"load stage script": {
				"type": "bool",
				"cur": true
			},
			"load script folder": {
				"type": "bool",
				"cur": true
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

func s_get_array(category: String, key: String):
	return setting.category[category][key].metadata[s_get(category, key)]

func s_set(category: String, key: String, value):
	setting.category[category][key].cur = value
	if key.contains("engine type"):
		Audio.refresh()
	
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
	if metadata.size() <= set_value:
		set_value = 0
	if set_value == -1:
		set_value = array.size() - 1
	setting.category[category][key].cur = set_value
	if key.contains("hit sound"):
		Audio.a_stop("Scroll")
		Audio.a_play(metadata[set_value], 1.0, s_get("gameplay", "hit sound volume") * 0.5 - 50)
	if key.contains("engine type"):
		Audio.refresh()
		
	setting_refresh() #設定項目の特殊更新

var conv_jpn := [
	["adam", "アダム"],
	["adamized", "アダムった"],
	["tutorial", "チュートリアル"],
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
	["visuals and ui", "ユーアイ"],
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
	["deathmatch", "デスマッチ"],
	["max fps", "サイダイ エフピーエス"],
	["show ms", "エムエス ヒョウジ"],
	["show kps", "ケーピーエス ヒョウジ"],
	["syobon-kun", "ショボン ヒョウジ"],
	["english", "エイゴ"],
	["japanese", "ニホンゴ"],
	["engine type", "エンジンタイプ"],
	["adam engine", "アダムエンジン"],
	["psych engine", "サイコエンジン"],
	["kade engine 1.2", "ケイドエンジン 1.2"],
	["kade engine 1.4", "ケイドエンジン 1.4"],
	["kade engine 1.8", "ケイドエンジン 1.8"],
	["leather engine", "レザーエンジン"],
	["denpa engine", "デンパエンジン"],
	["other a", "ソノタ エー"],
	["other b", "ソノタ ビー"],
	["resume", "サイカイ"],
	["restart", "リスタート"],
	["difficulty", "ナンイド"],
	["easy", "カンタン"],
	["normal", "フツウ"],
	["hard", "ムズカシイ"],
	["insane", "ゲキヤバ"],
	["hardcore", "ハードコア"],
	["harder", "オニ"],
	["old", "旧バージョン"],
	["canon", "カノン"],
	["mania", "マニア"],
	["god", "ゴッド"],
	["voiid", "ヴォイード"],
	["hell", "ジゴク"],
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
	["haxxer!!", "ハッカーや！！"],
	["cheater!", "チーターや！"],
	["eh", "うごご"],
	["it\'s not overcharted, you\'re just bad.", "これはチャートが酷いんじゃない、あなたがただ下手なだけ"],
	["done for.", "よしとしてやろう"],
	["cope harder", "出直してきな！"],
	["chart editor", "フメン エディター"],
	["stage editor", "ステージ エディター"],
	["modchart editor", "モッドチャート エディター"],
	["back", "メニュー ニ モドル"]
]

func eng():
	return lang == ENG

func jpn():
	return lang == JPN

func engine():
	return Setting.s_get_array("visuals and ui", "engine type")

func bot():
	return Setting.s_get("gameplay", "botplay")

func practice():
	return Setting.s_get("gameplay", "practice")

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

func set_dfont_strident(new_item):
	new_item.add_theme_color_override("font_color", "green")
	new_item.add_theme_color_override("font_outline_color", "black")
	new_item.add_theme_constant_override("shadow_outline_size", 0)
	new_item.add_theme_font_override("font", load("Assets/Fonts/comic.ttf"))
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
	
