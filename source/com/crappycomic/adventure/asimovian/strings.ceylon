import com.crappycomic.adventure.common {
    Strings
}

object strings extends Strings() {
    shared actual String alreadyHaveArmor => "You are already wearing a combat suit.";
    
    shared actual String alreadyHaveLight => "You already have a nucleonic light.";
    
    shared actual String alreadyHaveStrongWeapon => "You already have a laser.";
    
    shared actual String alreadyHaveTeleporter => "You already have a matter transporter.";
    
    shared actual String alreadyHaveWeakWeapon => "You already have an ion gun.";
    
    shared actual String consumePrompt(Integer food)
        => "You have ``food`` units of oxygen left.
            How many do you want to add to your tanks?";
    
    shared actual String currentFood(Integer food) => "Your reserve tank holds ``food`` units of oxygen.";
    
    shared actual String currentStrength(String name, Integer strength)
        => "Captain ``name``, your strength is ``strength``.";
    
    shared actual String currentWealth(Integer wealth) => "You have $``wealth`` in Solarian credits.";
    
    shared actual String foodPrompt => "How many units of oxygen?";
    
    shared actual String loseMessage => "You have run out of oxygen……";
    
    shared actual String lowStrength(String name)
        => "Warning, Captain ``name``, your stregth is running low.
            You need an oxygen boost.";
    
    shared actual String namePrompt => "What is your name, space hero?";
    
    shared actual String noExitWest => "You cannot move through solid walls.";
    
    shared actual String noFood => "You have no oxygen.";
    
    shared actual String notEnoughFood => "You do not have that much oxygen.";
    
    shared actual String noTeleporter => "You do not have the matter transporter.";
    
    shared actual String noTreasure => "There is nothing of value here.";
    
    shared actual String provisionsHeading => "A supply android has arrived.";
    
    shared actual String provisionsPrompt
        => "You can buy 1 - Nucleonic Light    ($15)
                        2 - Ion Gun            ($10)
                        3 - Laser              ($20)
                        4 - Oxygen     ($2 per unit)
                        5 - Matter transporter ($30)
                        6 - Combat suit        ($50)
                        0 - To continue exploration";
    
    shared actual String readyArmor => "Your combat suit increases your chance of success.";
    
    shared actual String readyStrongWeapon => "You charge and ready your laser.";
    
    shared actual String readyWeakWeapon => "Your ion gun hums with energy.";
    
    shared actual String strongWeapon => "a laser";
    
    shared actual String teleporter => "the matter transporter";
    
    shared actual String weakWeapon => "an ion gun";
    
    shared actual String weaponPrompt => "Which weapon? 1 - Ion Gun, 2 - Laser";
    
    shared actual String wearingArmor => "You are wearing a combat suit.";
}
