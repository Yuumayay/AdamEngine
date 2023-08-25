function onEvent(name, value1, value2)
    if name == "camHUD Zoom" then
        cancelTween('camZoom')
        doTweenZoom('cameraHUDZoomlol', 'camHUD', value1, value2, 'quadOut')
    end
end