scriptName SkyDiceAction extends Quest hidden
{Extend this to create your own action types for SkyDice!}

string property ActionName auto

event OnAction()
endEvent

event OnActionSetup()
endEvent

; On Mod Installation, Register this SkyDice action with SkyDice!
event OnInit()
    OnActionSetup()
    if ! ActionName
        string name = self ; [StaggerDiceAction <...>]
        int diceActionIndex = StringUtil.Find(name, "DiceAction ")
        if diceActionIndex > -1
            ActionName = StringUtil.Substring(name, 1, diceActionIndex - 1)
        endIf
    endIf
    if ActionName
        SkyDice.GetInstance().RegisterSkyDiceAction(ActionName, self)
    endIf
endEvent
