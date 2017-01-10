import ceylon.collection {
    ArrayList,
    MutableList
}

"Encapsulates the state of the player in our game."
class Player(name) {
    shared variable Boolean armor = false;
    
    shared variable Integer food = 0;
    
    shared variable Boolean light = false;
    
    "The [[Monster]]s this player has killed during this game."
    shared MutableList<Monster> monstersKilled = ArrayList<Monster>();
    
    "The name we'll use to address the player."
    String name;
    
    shared variable Integer strength = 100;
    
    shared variable Boolean strongWeapon = false;
    
    "The number of moves this player has made during this game."
    shared variable Integer tally = 0;
    
    shared variable Boolean teleporter = false;
    
    shared variable Integer wealth = 75;
    
    shared variable Boolean weakWeapon = false;
    
    "Describes the state of this player."
    shared void describe() {
        if (strength <= 10) { // Slightly more warning than original version.
            print(strings.lowStrength(name));
            print("");
        }
        
        print(strings.currentStrength(name, strength));
        
        if (wealth > 0) {
            print(strings.currentWealth(wealth));
        }
        
        if (food > 0) {
            print(strings.currentFood(food));
        }
        
        if (armor) {
            print(strings.wearingArmor);
        }
        
        value itemCount = count({weakWeapon, strongWeapon, teleporter});
        
        if (itemCount > 0) {
            value items = StringBuilder();
            
            items.append("You are carrying ");
            
            value allJoiners = [[], [""], [" and ", ""], [", ", ", and "]];
            value joiners = allJoiners[itemCount];
            
            assert(exists joiners);
            
            variable value joinerIndex = 0;
            
            void appendJoiner() {
                value joiner = joiners[joinerIndex++];
                
                assert(exists joiner);
                
                items.append(joiner);
            }

            if (weakWeapon) {
                items.append(strings.weakWeapon);
                appendJoiner();
            }
            
            if (strongWeapon) {
                items.append(strings.strongWeapon);
                appendJoiner();
            }
            
            if (teleporter) {
                items.append(strings.teleporter);
            }
            
            items.append(".");
            
            print(items);
        }
    }
    
    "Calculates and displays this player's current score."
    shared void displayScore() {
        value score
                = 3 * tally
                + 5 * strength
                + 2 * wealth
                + food // Oxygen was worth $10 in Asimovian Disaster. Good investment!
                + 30 * monstersKilled.size;
        
        print("Your score is ``score``.");
    }
}
