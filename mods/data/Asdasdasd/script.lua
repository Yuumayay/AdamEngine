function onUpdate()
    local songPos = getPropertyFromClass('Conductor', 'songPosition');
    setPropertyFromClass('openfl.Lib','application.window.x',math.sin(songPos/1000)*400 + 400)
end