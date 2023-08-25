function onCreatePost()
    if songName == "Asdasdasd" or songName == "Iamangrynow" or songName == "Debug" then
        setProperty('debugKeysChart', null); -- prevents key from doing anything
    end
end

function onUpdate()

    if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.SEVEN') then
        if songName == "Asdasdasd" then
            loadSong('Iamangrynow');
        end
        if songName == "Iamangrynow" then
            loadSong('Debug');
        end
        if songName == "Debug" then
            setProperty('health', 0)
        end
    end
end