function onEvent(name, value1, value2)
    if name == "camGame Zoom" then
        doTweenZoom('cameraGameZoomlol', 'camGame', value1, value2, 'quadOut')
    end
end