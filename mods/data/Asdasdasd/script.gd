extends Node

var rotation_value := 0.0
var z_rot_value := 0.0

func onCreate():
    Modchart.hideUI()
    Modchart.hideStrum()
    Modchart.keyToMove("Iamangrynow", "Hard", "7")

func onUpdate():
    var section: int = Audio.cur_section
    rotation_value = lerp(rotation_value, 0.0, 0.1)
    for i in range(8):
        Modchart.strums.get_child(i).rotation_degrees = rotation_value
    for i in Modchart.notes.get_children():
        i.rotation_degrees = rotation_value
    if section >= 48 and section < 208:
        z_rot_value += 0.17
        var sin_value = sin(z_rot_value) * 0.75
        Modchart.notePropertySetAll("scale", Vector2(sin_value, 0.75))
        #Modchart.doTween(1, 'dad', 490 - 130 * sin((currentBeat * 999) * PI), 0.001)

func onSectionHit():
    var section: int = Audio.cur_section
    if section == 16:
        Flash.flash()
        Modchart.showUI()
        Modchart.showStrum()
    if section < 48:
        if section % 2 == 0: 
            rotation_value = 15
        else:
            rotation_value = -15
    else:
        if section % 2 == 0: 
            Modchart.camZoomSet(2.0, -1)
        else:
            Modchart.camZoomSet(1.8, -1)
    if section == 48:
        Modchart.camLock()

func onBeatHit():
    var beat: int = Audio.cur_beat
    var section: int = Audio.cur_section
    if section >= 48:
        if beat % 2 == 0: 
            rotation_value = 30
        else:
            rotation_value = -30