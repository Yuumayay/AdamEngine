extends Node

func onBeatHit():
    var beat = Audio.cur_beat
    if beat == 64:
        Modchart.camZoomSet(0.7, -1)
        Modchart.camLock()