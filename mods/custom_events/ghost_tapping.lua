function onCreate()

setPropertyFromClass('ClientPrefs', 'ghostTapping', false);

end

function onDestroy()

setPropertyFromClass('ClientPrefs', 'ghostTapping', true);

end