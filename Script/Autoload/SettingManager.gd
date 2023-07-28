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

var OG_SETTINGS: Dictionary = {
	"options": {
		"category": {
			"keybinds": {
				"binds": {
					"type": "bind",
					"bind": input,
					"desc": "Enter to go keybind menu."
				}
			},
			"gameplay": {
				"downscroll": {
					"type": "bool",
					"default": true,
					"current": true,
					"desc": "Scroll direction. if checked, scroll direction is down."
				},
				"updownscroll": {
					"type": "bool",
					"default": false,
					"current": false,
					"desc": "Placeholder"
				},
				"botplay": {
					"type": "bool",
					"default": false,
					"current": false,
					"desc": ""
				},
				"practice mode": {
					"type": "bool",
					"default": false,
					"current": false,
					"desc": ""
				},
				"awful miss": {
					"type": "bool",
					"default": false,
					"current": false,
					"desc": ""
				},
				"drain type": {
					"type": "array",
					"array": ["adam", "psych", "kade 1.2"],
					"array_data": ["adam", "psych", "old-kade"],
					"default": 0,
					"current": 0,
					"desc": "Placeholder"
				}
			},
			"graphics": {
				"fps": {
					"type": "value",
					"value_range": [60, 240],
					"default": 240,
					"current": 240,
					"desc": "The number of times the screen is updated per second."
				}
			},
			"sounds": {
				"hit sound": {
					"type": "array",
					"array": ["no sound", "sound a", "sound b", "sound c", "sound d"],
					"array_data": ["none", "hit", "hit2", "hit3", "hit4"],
					"default": 2,
					"current": 2,
					"desc": "Change the sound when hitting the notes."
				}
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
	return OG_SETTINGS.options.category[category][key].current
