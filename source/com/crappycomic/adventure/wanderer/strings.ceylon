import com.crappycomic.adventure.common {
    Strings
}

object strings extends Strings() {
    shared actual String alreadyHaveArmor => "You are already wearing armor.";
    
    shared actual String alreadyHaveLight => "You already have a flaming torch.";
    
    shared actual String alreadyHaveStrongWeapon => "You already have a sword.";
    
    shared actual String alreadyHaveTeleporter => "You already have the magic amulet.";
    
    shared actual String alreadyHaveWeakWeapon => "You already have an axe.";
    
    shared actual String consumePrompt => "How many do you want to eat?";
    
    shared actual String currentFood(Integer food) => "Your provisions sack holds ``food`` units of food.";
    
    shared actual String currentStrength(String name, Integer strength)
            => "Captain ``name``, your strength is ``strength``.";
    
    shared actual String currentWealth(Integer wealth) => "You have $``wealth``.";
    
    shared actual String danger => "Danger…There is a monster here…";
    
    shared actual String dangerLevel(Integer strength) => "The danger level is ``strength``!!";
    
    shared actual String foodPrompt => "How many units of food?";
    
    shared actual String loseMessage => "You have died………";
    
    shared actual String lowStrength(String name) => "Warning, ``name``, your strength is running low.";
    
    shared actual String namePrompt => "What is your name, explorer?";
    
    shared actual String noExitWest => "You cannot move through solid stone.";
    
    shared actual String noFood => "You have no food.";
    
    shared actual String notEnoughFood => "You do not have that much food.";
    
    shared actual String noTeleporter => "You do not have the magic amulet.";
    
    shared actual String noTreasure => "There is no treasure to pick up.";
    
    shared actual String provisionsHeading => "Provisions & Inventory";
    
    shared actual String provisionsPrompt
        => "You can buy 1 - Flaming torch ($15)
                        2 - Axe           ($10)
                        3 - Sword         ($20)
                        4 - Food  ($2 per unit)
                        5 - Magic amulet  ($30)
                        6 - Suit of armor ($50)
                        0 - To continue adventure";
    
    shared actual String readyArmor => "Your armor increases your chance of success.";
    
    shared actual String readyStrongWeapon => "You draw your sword.";
    
    shared actual String readyWeakWeapon => "You ready your axe.";
    
    shared actual String strongWeapon => "a sword";
    
    shared actual String teleporter => "the magic amulet";
    
    shared actual String weakWeapon => "an axe";
    
    shared actual String weaponPrompt => "Which weapon? 1 - Axe, 2 - Sword";
    
    shared actual String wearingArmor => "You are wearing armor.";
}
