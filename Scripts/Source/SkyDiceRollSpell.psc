scriptName SkyDiceRollSpell extends ActiveMagicEffect  

event OnEffectStart(Actor target, Actor caster)
    SkyDice.GetInstance().RollTheDice("the player")
endEvent