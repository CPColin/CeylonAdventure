"Provides a way for modules to customize certain strings."
shared abstract class Strings() {
    shared formal String alreadyHaveArmor;
    
    shared formal String alreadyHaveLight;
    
    shared formal String alreadyHaveStrongWeapon;
    
    shared formal String alreadyHaveTeleporter;
    
    shared formal String alreadyHaveWeakWeapon;
    
    shared formal String consumePrompt;
    
    shared formal String currentFood(Integer food);
    
    shared formal String currentStrength(String name, Integer strength);
    
    shared formal String currentWealth(Integer wealth);
    
    shared formal String danger;
    
    shared formal String dangerLevel(Integer strength);
    
    shared formal String foodPrompt;
    
    shared formal String loseMessage;
    
    shared formal String lowStrength(String name);
    
    shared formal String namePrompt;
    
    shared formal String noExitWest;
    
    shared formal String noFood;
    
    shared formal String notEnoughFood;
    
    shared formal String noTeleporter;
    
    shared formal String noTreasure;
    
    shared formal String provisionsHeading;
    
    shared formal String provisionsPrompt;
    
    shared formal String readyArmor;
    
    shared formal String readyStrongWeapon;
    
    shared formal String readyWeakWeapon;
    
    shared formal String strongWeapon;
    
    shared formal String teleporter;
    
    shared formal String weakWeapon;
    
    shared formal String weaponPrompt;
    
    shared formal String wearingArmor;
}
