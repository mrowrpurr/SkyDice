scriptName SkyDiceVersionManager extends ReferenceAlias  

event OnPlayerLoadGame()
    SkyDice.GetInstance().StartWatchingForDiceRolls()
endEvent