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

var setting: Dictionary = {
	"category": {
		"keybind": {
			"bind": {
				"type": "bind",
				"key": 4,
				"cur": keybind_default["4k"]
			}
		},
		"gameplay": {
			"downscroll": {
				"type": "bool",
				"cur": false,
			},
			"middlescroll": {
				"type": "bool",
				"cur": false,
			},
			"hit sound": {
				"type": "array",
				"cur": 0,
				"array": ["None", "Osu hit", "AE hit 1", "AE hit 2", "AE hit 3", "AE hit 4", "KE clap", "KE snap", "Keystroke"],
				"metadata": ["none", "osu", "aehit1", "aehit2", "aehit3", "aehit4", "clap", "snap", "key"]
			}
		},
		"graphics": {
			"max fps": {
				"type": "int_range",
				"cur": 60,
				"range": [30, 240],
				"changesec": 0,
				"step": 1
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

func s_set_array(category: String, key: String, value):
	var ind = setting.category[category][key].cur
	var array = setting.category[category][key].array
	var metadata = setting.category[category][key].metadata
	var set = ind + value
	if array.size() <= set:
		set = 0
	if set == -1:
		set = array.size() - 1
	setting.category[category][key].cur = set
	if key.contains("hit sound"):
		Audio.a_stop("Scroll")
		Audio.a_play(metadata[set])

func _process(delta):
	Engine.max_fps = s_get("graphics", "max fps")
