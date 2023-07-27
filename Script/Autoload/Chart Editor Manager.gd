extends Node

var placed_notes: Dictionary = {"notes": []}

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

var cur_section: int

var bpm: float = 150
var metronome_bpm: float = 150
var multi: float = 1
var mouse_scroll_speed: float = 1

var playing: bool = false

var cur_song = "test"

var cur_y: float

var metronome: bool = false
var hit_sound: int = 0

func position_to_time():
	if 60.0 / Chart.bpm * (Chart.cur_y * -2.0 / 1600.0) * 4 <= 0.0:
		return 0.0
	return 60.0 / Chart.bpm * (Chart.cur_y * -2.0 / 1600.0) * 4
