extends Node

var chartData: Dictionary = {"notes": [{"lengthInSteps":16,"mustHitSection":false,"sectionNotes":[]}]}

# {"notes": [{"lengthInSteps":16,"mustHitSection":false,"sectionNotes":[]}]}

var modcharts: Dictionary = {
	"category": {
		"gameplay": {
			"HealthDrain": {
				"tooltip": "Placeholder"
			},
			"HealthGain": {
				"tooltip": "Placeholder"
			},
			"NoHealthGain": {
				"tooltip": "Placeholder"
			},
			"NoHealthDrain": {
				"tooltip": "Placeholder"
			}
		},
		"effect": {
			"WavyBG": {
				"tooltip": "Placeholder"
			},
			"RainbowEyesore": {
				"tooltip": "Placeholder"
			},
			"Shockwave": {
				"tooltip": "Placeholder"
			},
			"Distortion": {
				"tooltip": "Placeholder"
			},
			"Glitch": {
				"tooltip": "Placeholder"
			},
			"Flash": {
				"tooltip": "Placeholder"
			},
			"Darkness": {
				"tooltip": "Placeholder"
			},
			"Glow": {
				"tooltip": "Placeholder"
			}
		},
		"ui": {
			"ScreenShake": {
				"tooltip": "Placeholder"
			},
			"ShowImage": {
				"tooltip": "Placeholder"
			},
			"HideImage": {
				"tooltip": "Placeholder"
			},
			"ToggleTrail": {
				"tooltip": "Placeholder"
			},
			"ChangeStage": {
				"tooltip": "Placeholder"
			},
			"ChangeNoteSkin": {
				"tooltip": "Placeholder"
			},
			"ChangeUISkin": {
				"tooltip": "Placeholder"
			},
			"ChangeFont": {
				"tooltip": "Placeholder"
			},
			"ChangeTextColor": {
				"tooltip": "Placeholder"
			},
			"Flash": {
				"tooltip": "Placeholder"
			},
			"ShowPopup": {
				"tooltip": "Placeholder"
			},
			"Lyrics": {
				"tooltip": "Placeholder"
			},
			"ApplyShader": {
				"tooltip": "Placeholder"
			}
		},
		"camera": {
			"CameraBump": {
				"tooltip": "Placeholder"
			},
			"PlayCameraBump": {
				"tooltip": "Placeholder"
			},
			"StopCameraBump": {
				"tooltip": "Placeholder"
			},
			"MoveCamera2D": {
				"tooltip": "Placeholder"
			},
			"MoveCamera3D": {
				"tooltip": "Placeholder"
			},
			"ZoomCamera": {
				"tooltip": "Placeholder"
			},
			"RotateCamera2D": {
				"tooltip": "Placeholder"
			},
			"RotateCamera3D": {
				"tooltip": "Placeholder"
			}
		},
		"property": {
			"ScrollSpeed": {
				"tooltip": "Placeholder"
			},
			"Character": {
				"tooltip": "Placeholder"
			},
			"HealthIcon": {
				"tooltip": "Placeholder"
			},
			"BPM": {
				"tooltip": "Placeholder"
			},
			"GhostTapping": {
				"tooltip": "Placeholder"
			},
			"ScrollDirection": {
				"tooltip": "Placeholder"
			},
			"Practice": {
				"tooltip": "Placeholder"
			},
			"Botplay": {
				"tooltip": "Placeholder"
			},
			"FlipPosition": {
				"tooltip": "Placeholder"
			},
			"Keybind": {
				"tooltip": "Placeholder"
			},
			"KeyCount": {
				"tooltip": "Placeholder"
			},
			"HealthLoss": {
				"tooltip": "Placeholder"
			},
			"HealthGain": {
				"tooltip": "Placeholder"
			},
			"Poison": {
				"tooltip": "Placeholder"
			},
			"Freeze": {
				"tooltip": "Placeholder"
			},
			"Flip": {
				"tooltip": "Placeholder"
			},
			"GhostNotes": {
				"tooltip": "Placeholder"
			}
		},
		"misc": {
			"ChangeProperty": {
				"tooltip": "Placeholder"
			}
		}
	}
}

var menu_dict: Dictionary = {
	"Charting": {
		"Metronome": {
			"type": "bool",
			"cur": false
		},
		"Autoscroll": {
			"type": "bool",
			"cur": true
		},
		"m": {
			"type": "margin",
			"cur": 0
		},
		"BPM": {
			"type": "range",
			"cur": 150.0,
			"range": [0.1, 99999.0],
			"step": 0.1
		},
		"Offset": {
			"type": "range",
			"cur": 0.0,
			"range": [-1000.0, 1000.0],
			"step": 0.1,
			"suffix": "ms"
		},
		"m2": {
			"type": "margin",
			"cur": 10
		},
		"Inst Wave": {
			"type": "bool",
			"cur": false
		},
		"Voices Wave": {
			"type": "bool",
			"cur": false
		},
		"m3": {
			"type": "margin",
			"cur": 0
		},
		"Ignore Warning": {
			"type": "bool",
			"cur": false
		},
		"Auto Save": {
			"type": "bool",
			"cur": true
		},
		"m4": {
			"type": "margin",
			"cur": 0
		},
		"Playback Rate": {
			"type": "range",
			"cur": 1.0,
			"range": [0.1, 3.0],
			"step": 0.1,
			"suffix": "x"
		},
		"Mouse Scroll Speed": {
			"type": "range",
			"cur": 1.0,
			"range": [0.1, 3.0],
			"step": 0.1,
			"suffix": "x"
		},
		"m5": {
			"type": "margin",
			"cur": 0
		},
		"Show Strums": {
			"type": "bool",
			"cur": false
		},
		"m6": {
			"type": "margin",
			"cur": 0
		},
		"Inst Volume": {
			"type": "range",
			"cur": 60.0,
			"range": [0.0, 100.0],
			"step": 0.1,
			"suffix": "%"
		},
		"Voices Volume": {
			"type": "range",
			"cur": 100.0,
			"range": [0.0, 100.0],
			"step": 0.1,
			"suffix": "%"
		}
	},
	"Events": {
		"Placeholder": {
			"type": "bool",
			"cur": false
		}
	},
	"Modchart": {
		"Placeholder": {
			"type": "bool",
			"cur": false
		}
	},
	"Note": {
		"Placeholder": {
			"type": "bool",
			"cur": false
		}
	},
	"Options": {
		"Placeholder": {
			"type": "bool",
			"cur": false
		}
	},
	"Section": {
		"Placeholder": {
			"type": "bool",
			"cur": false
		}
	},
	"Song": {
		"Placeholder": {
			"type": "bool",
			"cur": false
		}
	}
}

#var key_count: Array = [[4], [4], [4]]

var cur_section: int

var bpm: float = 150
var metronome_bpm: float = 150
var multi: float = 1
var mouse_scroll_speed: float = 1

var playing: bool = false

var cur_song: String
var songSpeed := 1.0

var cur_x: float
var cur_y: float
var cur_zoom: float = 1.0

var bf_count: int = 1
var dad_count: int = 1
var gf_count: int = 1

var bf_data: Dictionary = {"icon_name": ["bf"], "key_count": [4], "note_skin": ["default"], "modchart": [[]]}
var dad_data: Dictionary = {"icon_name": ["dad"], "key_count": [4], "note_skin": ["default"], "modchart": [[]]}
var gf_data: Dictionary = {"icon_name": ["gf"], "key_count": [4], "note_skin": ["default"], "modchart": [[]]}

## SETTINGS ##
var metronome: bool = false
var hit_sound: int = 0

func position_to_time():
	if 60.0 / Chart.bpm * (Chart.cur_y * -2.0 / 1600.0) * 4 <= 0.0:
		return 0.0
	return 60.0 / Chart.bpm * (Chart.cur_y * -2.0 / 1600.0) * 4
