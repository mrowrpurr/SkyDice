scriptName SkyDice extends ReferenceAlias
{Sky Dice Roller!}

Sound property SkyDice_DiceRollSoundMarker auto

event OnInit()
    ListenForKeyboardShortcut()
endEvent

event OnPlayerLoadGame()
    ListenForKeyboardShortcut()
endEvent

; Left Alt + Left Shift + R => 19
function ListenForKeyboardShortcut()
    RegisterForKey(19) ; R
endFunction

event OnKeyDown(int keyCode)
    if Input.IsKeyPressed(56) && Input.IsKeyPressed(42) ; Left Alt and Shift
        RollDice()
    endIf
endEvent

function RollDice()
    Debug.Notification("Rolling dice...")
    SkyDice_DiceRollSoundMarker.Play(GetActorReference())
endFunction
