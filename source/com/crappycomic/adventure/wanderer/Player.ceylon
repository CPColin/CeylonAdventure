import ceylon.collection {
    MutableSet,
    HashSet
}

"Encapsulates the state of the player in our game."
class Player(name) {
    shared variable Boolean amulet = false;
    
    shared variable Boolean armor = false;
    
    shared variable Boolean axe = false;
    
    shared variable Integer food = 0;
    
    shared variable Boolean light = false;
    
    "The [[Monster]]s this player has killed during this game."
    shared MutableSet<Monster> monstersKilled = HashSet<Monster>();
    
    "The name we'll use to address the player."
    shared String name;
    
    shared variable Integer strength = 100;
    
    shared variable Boolean sword = false;
    
    "The number of moves this player has made during this game."
    shared variable Integer tally = 0;
    
    shared variable Integer wealth = 75;
    
    "Describes the state of this player."
    shared void describe() {
        if (strength <= 10) { // Slightly more warning than original version.
            print("Warning, ``name``, your stength is running low.");
            print("");
        }
        
        print("``name``, your strength is ``strength``.");
        
        if (wealth > 0) {
            print("You have $``wealth``.");
        }
        
        if (food > 0) {
            print("Your provisions sack holds ``food`` units of food.");
        }
        
        if (armor) {
            print("You are wearing armor.");
        }
        
        value itemCount = count({axe, sword, amulet});
        
        if (itemCount > 0) {
            value items = StringBuilder();
            
            items.append("You are carrying ");
            
            value allJoiners = [[], [], [" and "], [", ", ", and "]];
            value joiners = allJoiners[itemCount];
            
            assert(exists joiners);
            
            variable value joinerIndex = 0;
            
            void appendJoiner() {
                value joiner = joiners[joinerIndex++];
                
                assert(exists joiner);
                
                items.append(joiner);
            }

            if (axe) {
                items.append("an axe");
            }
            
            if (sword) {
                appendJoiner();
                items.append("a sword");
            }
            
            if (amulet) {
                appendJoiner();
                items.append("the magic amulet");
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
                + food
                + 30 * monstersKilled.size;
        
        print("Your score is ``score``.");
    }
    
}
