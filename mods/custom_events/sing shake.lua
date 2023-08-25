function opponentNoteHit(id, noteData, noteType, isSustainNote)
    characterPlayAnim('gf', 'scared', false);
    triggerEvent('Screen Shake', '0.05, 0.025', '0.05, 0.01');
end