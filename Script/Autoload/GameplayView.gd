extends Node

var note_spawn_y: Array = [-600, 600]
var strum_pos: Array
var miss_offset: Array = [750, -100]
var version_text: String = "Adam Engine - Alpha 2"
var version_text_color: Color = Color("c1ccff")

# Gameplay Managerに移動
var keys: Dictionary

func _ready():
	var l = "left"
	var d = "down"
	var u = "up"
	var r = "right"
	var l2 = "left2"
	var d2 = "down2"
	var u2 = "up2"
	var r2 = "right2"
	var s = "square"
	var rl = "rleft"
	var rd = "rdown"
	var ru = "rup"
	var rr = "rright"
	var rl2 = "rleft2"
	var rd2 = "rdown2"
	var ru2 = "rup2"
	var rr2 = "rright2"
	var p = "plus"
	keys = {
		"1k": [s],
		"2k": [l, r],
		"3k": [l, s, r],
		"4k": [l, d, u, r],
		"5k": [l, d, s, u, r],
		"6k": [l, d, r, l2, u2, r2],
		"7k": [l, d, r, s, l2, u2, r2],
		"8k": [l, d, u, r, l2, d2, u2, r2],
		"9k": [l, d, u, r, s, l2, d2, u2, r2],
		"10k": [l, d, u, r, rl, rr, l2, d2, u2, r2],
		"11k": [l, d, u, r, rl, s, rr, l2, d2, u2, r2],
		"12k": [l, d, u, r, rl, rd, ru, rr, l2, d2, u2, r2],
		"13k": [l, d, u, r, rl, rd, s, ru, rr, l2, d2, u2, r2],
		"14k": [l, d, u, r, rl, rd, rl2, rr2, ru, rr, l2, d2, u2, r2],
		"15k": [l, d, u, r, rl, rd, rl2, s, rr2, ru, rr, l2, d2, u2, r2],
		"16k": [l, d, u, r, rl, rd, ru, rr, rl2, rd2, ru2, rr2, l2, d2, u2, r2],
		"17k": [l, d, u, r, rl, rd, ru, rr, s, rl2, rd2, ru2, rr2, l2, d2, u2, r2],
		"18k": [l, d, u, r, rl, rd, ru, rr, s, p, rl2, rd2, ru2, rr2, l2, d2, u2, r2]
	}
