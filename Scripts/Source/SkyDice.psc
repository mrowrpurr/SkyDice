scriptName SkyDice extends ReferenceAlias
{Sky Dice Roller!}

Sound property SkyDice_DiceRollSoundMarker auto

event OnInit()
    ListenForKeyboardShortcut()
endEvent

event OnPlayerLoadGame()
    ListenForKeyboardShortcut()
endEvent

; Left Alt + Left Shift + X => 45
function ListenForKeyboardShortcut()
    RegisterForKey(45) ; X
endFunction

event OnKeyDown(int keyCode)
    if Input.IsKeyPressed(56) && Input.IsKeyPressed(42) ; Left Alt and Shift
        RollDice()
    endIf
endEvent

function RollDice()
    SkyDice_DiceRollSoundMarker.Play(GetActorReference())
    Utility.WaitMenuMode(2)

    int roll              = 2 ; Utility.RandomInt(1, 4) ; d4
    int outcomes          = JValue.readFromDirectory("Data/SkyDice/RollOutcomes/" + roll)
    string[] outcomeNames = JMap.allKeysPArray(outcomes)
    int randomNameIndex   = Utility.RandomInt(0, outcomeNames.Length - 1)
    int actionRef         = JMap.getObj(outcomes, outcomeNames[randomNameIndex])

    SkyAction.PerformAction(actionRef)

    Debug.Notification("Rolled a " + roll)
endFunction
