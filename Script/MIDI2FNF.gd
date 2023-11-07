extends ConfirmationDialog

const DEFAULT_TEMPO = 0.5
var CONF = {
	"section_keyswitch": [{"note": 85, "set_attr": "mustHitSection", "1": true, "0": false}],
	"mustHitSectionNote": 85,
	"chartFormat": "Kade Engine",
	"midi2fnf key_count": 4
}

var noteState = {}

func ticks2s(ticks, tempo, ticks_per_beat):
	# Converts ticks to seconds
	return ticks / ticks_per_beat * tempo

func note2freq(x):
	# Convert a MIDI note into a frequency (given in Hz)
	var a = 440
	return (a / 32) * (2 ** ((x - 9) / 12))

func round_decimals_up(number: float, decimals: int = 2):
	# Returns a value rounded up to a specific number of decimal places.
	if decimals == 0:
		return ceil(number)

	var factor = 10 ** decimals
	return ceil(number * factor) / factor
	
func getNoteState(note):
		if str(note) in noteState:
			return noteState[str(note)]
		else:
			noteState[str(note)] = [0, 0, 0]
			print("error!")
			return noteState[str(note)]
			
func convertMustHit(mustHit, in_notes, key_count):
	if mustHit:
		for i in range(len(in_notes)):
			if in_notes[i][1] >= key_count:
				in_notes[i][1] =in_notes[i][1] - key_count
			else:
				in_notes[i][1] = in_notes[i][1] + key_count
	return in_notes


func midi2fnf(path):
	var bpm = 150
	var key_count = CONF["midi2fnf key_count"]

	var nyxTracks = {}
	for i in range(16):
		nyxTracks[i] = []
	
	var smf = SMF.new()
	var mid = smf.read_file(path).data
	
	var tracksMerged = []
		
	var max_totaltime:float  = 0
	var tempo:float = DEFAULT_TEMPO
	
	for i in range(mid.tracks.size()):
		var track = mid.tracks[i].events
		for j in range(track.size()):
			var message = track[j]
			var event = message.event
			if event is SMF.MIDIEventSystemEvent:  # SYSTEM event Tempo change
				#print("SYSTEM EVENT:")
				if event.args["type"] == SMF.MIDISystemEventType.set_tempo:
					tempo = event.args["bpm"] / (1000000.0)
					bpm = floor(60000000.0 / event.args["bpm"] * 100.0)/100.0 
					break
	
	print("BPM: ",bpm)
	print("TEMPO:", tempo)
	print("Timebase:", mid.timebase)
	var tick_duration:float  = 60.0/(mid.timebase*bpm)
	print("Tick Duration:")
	print(tick_duration)
	var msec_per_beat:float  = 60.0 / bpm * 1000.0 
	var msec_per_step:float  = 60.0 / bpm * 1000.0 / 4.0
	noteState = {}
	
	for i in range(mid.tracks.size()):
		var currTrack = i
		var totaltime:float  = 0
		var globalTime:float  = 0
		var track = mid.tracks[i].events
		var ticks_per_beat:float  = mid.timebase

		# MIDIEventChunk ループ
		for j in range(track.size()):
			var message = track[j]
			var channel_number = message.channel_number
			
			#var t = ticks2s(message.time, tempo, ticks_per_beat)
			var event = message.event

			if event is SMF.MIDIEventNoteOn:
				var abstime = message.time #SMF.gdは絶対時間で入れてくれてる
				var note = event.note
				var currTime = abstime * tick_duration * 1000 #ms変換
				var noteToUse = 0
				
				if channel_number == 0:  # only use channel 0
					if 60 <= note and note <= 71:
						noteToUse = note - 60
					elif 72 <= note and note <= 83:
						noteToUse = note - 72 + key_count
					else:
						# special command
						noteToUse = note
				print(note, "-> ", noteToUse)

				var aux = [currTime, noteToUse, 0]
				nyxTracks[channel_number].append(aux)
				noteState[str(note)] = len(nyxTracks[channel_number]) - 1
				totaltime = currTime

			elif event is SMF.MIDIEventNoteOff:
				var note = event.note
				# long notes detection
				var target_auxid = getNoteState(note)
				var lastaux = nyxTracks[channel_number][target_auxid]
				var currTime = message.time * tick_duration * 1000 - 5
				lastaux[2] = currTime - lastaux[0]
				if msec_per_step > lastaux[2]:
					lastaux[2] = 0
				nyxTracks[channel_number][target_auxid][2] = lastaux[2]
				noteState.erase(str(note))
				print(note, " OFF | long:", msec_per_step, " " ,lastaux[2])
				totaltime = currTime

		print("totaltime: " + str(totaltime) + "ms")
		if max_totaltime < totaltime:
			max_totaltime = totaltime
	
	max_totaltime /= 1000.0
	
	var frames = []
	var section_settings = []
	var currTime = 240.0 / bpm
	var tolerance = (240.0 / bpm) / 32.0
	
	while currTime < max_totaltime:
		var aux = []
		var section_special_command = {}
		for v in CONF["section_keyswitch"]:
			section_special_command[v["set_attr"]] = v["0"]
			
		for j in range(2):
			for i in range(len(nyxTracks[j])):
				var note = nyxTracks[j][i]
				if note == null:
					continue
				var roundedNote = round_decimals_up(note[0], 3)
				if roundedNote + tolerance < currTime * 1000:
					# check special command
					var special_f = false
					for v in CONF["section_keyswitch"]:
						if note[1] == v["note"]:
							print("FRAME:", str(currTime), v["set_attr"], ":", v["1"])
							special_f = true
							section_special_command[v["set_attr"]] = v["1"]
					if special_f == false and note[1] > key_count * 2:
						print(roundedNote, "wrong note:", note[1])
						special_f = true
					# normal notes
					if special_f == false:
						aux.append([roundedNote, note[1], note[2], 0, 0])
					nyxTracks[j][i] = null

		frames.append(aux)
		section_settings.append(section_special_command)
		currTime += 240 / bpm
		
	var dicc = {}
	dicc["song"] = {}
	dicc["song"]["player1"] = "bf"
	dicc["song"]["player2"] = "dad"
	dicc["song"]["notes"] = []
	dicc["song"]["isHey"] = false
	dicc["song"]["cutsceneType"] = "none"
	dicc["song"]["song"] = "midisong"
	dicc["song"]["isSpooky"] = false
	dicc["song"]["validScore"] = true
	dicc["song"]["speed"] = 2
	dicc["song"]["isMoody"] = false
	dicc["song"]["sectionLengths"] = []
	dicc["song"]["uiType"] = "normal"
	dicc["song"]["stage"] = "stage"
	dicc["song"]["sections"] = 0
	dicc["song"]["needsVoices"] = true
	dicc["song"]["bpm"] = bpm
	dicc["song"]["gf"] = "gf"

	var notes = []
	
	for i in range(len(frames)):
		var note = frames[i]
		var auxDicc = {}
		auxDicc["typeOfSection"] = 0
		auxDicc["lengthInSteps"] = 16
		auxDicc["sectionNotes"] = convertMustHit(section_settings[i]["mustHitSection"], note, key_count)
		auxDicc["altAnim"] = false
		auxDicc["mustHitSection"] = true
		auxDicc["bpm"] = bpm
		for k in section_settings[i].keys():
			var v = section_settings[i][k]
			auxDicc[k] = v
		notes.append(auxDicc)

	dicc["song"]["notes"] = notes
	
	return dicc
