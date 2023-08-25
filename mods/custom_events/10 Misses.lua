function onCreate()
    makeLuaText("misses", "0 / 10", 500, 385, 0)
    setTextAlignment("misses", 'center')
    setTextSize("misses", 50)
    setTextColor("misses", 'FF0000')
    addLuaText("misses")

    setProperty('healthBar.visible', false)
    setProperty('healthBarBG.visible', false)
end

function onUpdate()
    misses = getProperty('songMisses')
    health = getProperty('health')
    setTextString("misses", misses .. " / 10")
    if misses >= 10 then
        setProperty('health', 0)
    else
        setProperty('health', 1)
    end
end