function onUpdate()
    health = getProperty('health')
    if getProperty('health') > 1.6 then
        setProperty('health', health- 0.002);
    end
end