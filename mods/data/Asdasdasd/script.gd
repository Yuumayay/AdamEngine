extends Node

var rotation_value := 0.0

func onCreate():
    Modchart.keyToMove("Iamangrynow", "Hard", "7")

func onUpdate():
    rotation_value = lerp(rotation_value, 0.0, 0.1)
    for i in range(8):
        Modchart.strums.get_child(i).rotation_degrees = rotation_value
    for i in Modchart.notes.get_children():
        i.rotation_degrees = rotation_value

func onSectionHit():
    var section: int = Audio.cur_section
    if section < 48:
        if section % 2 == 0: 
            rotation_value = 15
        else:
            rotation_value = -15

func onBeatHit():
    var beat: int = Audio.cur_beat
    var section: int = Audio.cur_section
    if section >= 48:
        if beat % 2 == 0: 
            rotation_value = 30
        else:
            rotation_value = -30