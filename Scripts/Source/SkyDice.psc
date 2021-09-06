scriptName SkyDice extends Quest  

int POSSIBLE_RESULTS_MAP
int DIE_SIDES = 4
string DICE_ROLLS_FILE = "diceRolls.txt"
Actor player

; Custom Sky Dice Actions
int CustomActionIndex
SkyDiceAction[] CustomActionScripts
string[] CustomActionNames

SkyDice function GetInstance() global
    return Game.GetFormFromFile(0x800, "SkyDice.esp") as SkyDice
endFunction

event OnInit()
    CustomActionScripts = new SkyDiceAction[128]
    CustomActionNames = new string[128]
    LoadPossibleRollResults()
    player = Game.GetPlayer()
    StartWatchingForDiceRolls()
endEvent

function StartWatchingForDiceRolls()
    RegisterForUpdate(5.0)
endFunction

function RegisterSkyDiceAction(string name, SkyDiceAction customAction)
    if CustomActionIndex < 128
        CustomActionNames[CustomActionIndex] = name
        CustomActionScripts[CustomActionIndex] = customAction
    else
        Debug.Trace("You cannot register action " + name + " because there are already 128 custom actions registered")
    endIf
endFunction

event OnUpdate()
    string diceRollsText = MiscUtil.ReadFromFile(DICE_ROLLS_FILE)
    if diceRollsText
        MiscUtil.WriteToFile(DICE_ROLLS_FILE, "", append = false)
    endIf
    string[] names = PapyrusUtil.StringSplit(diceRollsText, "\n")
    if names
        int i = 0
        while i < names.Length
            string name = names[i]
            if name
                RollTheDice(name)
            endIf
            i += 1
        endWhile
    endIf
endEvent

function LoadPossibleRollResults()
    POSSIBLE_RESULTS_MAP = JValue.readFromFile("Data\\possibleRollResults.json")
    JValue.retain(POSSIBLE_RESULTS_MAP)
endFunction

function RollTheDice(string username)

    int roll = Utility.RandomInt(1, DIE_SIDES)
    Debug.Notification(username + " rolled a " + roll)

    int possibilities = JMap.getObj(POSSIBLE_RESULTS_MAP, roll)
    int possibilityCount = JArray.count(possibilities)
    int randomPossibilityIndex = Utility.RandomInt(0, possibilityCount - 1)
    int possibility = JArray.getObj(possibilities, randomPossibilityIndex)
    int actions = JMap.getObj(possibility, "actions")
    int actionsCount = JArray.count(actions)
    int i = 0
    while i < actionsCount
        int theAction = JArray.getObj(actions, i)
        string actionType = JMap.getStr(theAction, "type")
        PerformDiceRollAction(actionType, theAction)
        i += 1
    endWhile
endFunction

function PerformDiceRollAction(string type, int theAction)
    if type == "summon"
        Form theForm = JMap.getForm(theAction, "form")
        int count = JMap.getInt(theAction, "count", default = 1)
        player.PlaceAtMe(theForm, count)
    elseIf type == "additem"
        Form theForm = JMap.getForm(theAction, "form")
        int count = JMap.getInt(theAction, "count", default = 1)
        player.AddItem(theForm, count)
    else
        int actionIndex = CustomActionNames.Find(type)
        if actionIndex > -1
            SkyDiceAction customAction = CustomActionScripts[actionIndex]
            customAction.OnAction()
        else
            Debug.Notification("Unknown SkyDice action " + type)
        endIf
    endIf
endFunction
