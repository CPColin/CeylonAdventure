import ceylon.collection {
    MutableMap,
    HashMap
}
import ceylon.language.meta.model {
    Attribute
}
import ceylon.random {
    DefaultRandom,
    Random
}

"The [[Room]] the [[player]] is currently occupying."
variable Room currentRoom = entrance;

"The current [[Player]]."
late Player player;

"The random number generator for our application."
Random random = DefaultRandom();

"Maps [[Room]]s to their [[contents|RoomContents]]."
MutableMap<Room, RoomContents> roomContents = HashMap<Room, RoomContents>();

"""Run "Werewolves and Wanderer.""""
shared void run() {
    initializeTreasure();
    
    initializeMonsters();
    
    initializePlayer();
    
    mainLoop();
}

"Allows the [[player]] to purchase provisions for the adventure."
void buyProvisions() {
    print("Provisions & Inventory");
    
    variable CommandResult|Integer item = askAgain;
    
    while (item == askAgain) {
        pause();
        
        if (player.wealth <= 0) {
            print("You have no money.");
            
            return;
        }
        else {
            print("You have $``player.wealth``.");
        }
        
        print("You can buy 1 - Flaming torch   ($15)
                           2 - Axe             ($10)
                           3 - Sword           ($20)
                           4 - Food    ($2 per unit)
                           5 - Magic amulet    ($30)
                           6 - Suit of armor   ($50)
                           0 - To continue adventure
               Enter number of item required.");
        
        item = inputInteger();
        
        switch (item)
        case (1) {
            purchase(15, `Player.light`, "You already have a flaming torch.");
        }
        case (2) {
            purchase(10, `Player.axe`, "You already have an axe.");
        }
        case (3) {
            purchase(20, `Player.sword`, "You already have a sword.");
        }
        case (4) {
            purchaseFood();
        }
        case (5) {
            purchase(30, `Player.amulet`, "You already have the magic amulet.");
        }
        case (6) {
            purchase(50, `Player.armor`, "You already have a suit of armor.");
        }
        case (0) {
            return;
        }
        else {
            print("Please try again.");
        }
        
        item = askAgain;
    }
}

"Displays a message most players don't want to see."
void displayLoseMessage() {
    print("You have died………");
    pause();
}

"Displays a congratulatory message."
void displayWinMessage() {
    print("You've done it!!");
    pause();
    print("That was the exit from the castle.");
    pause();
    print("You have succeeded, ``player.name``!
           You managed to get out of the castle.");
    pause();
    print("Well done!");
    pause();
    player.displayScore();
}

"Prompts for how much food to eat and updates the [[player]]'s state."
CommandResult eat() {
    if (player.food > 0) {
        variable CommandResult|Integer units = askAgain;
        
        while (units == askAgain) {
            print("You have ``player.food`` units of food.
                   How many do you want to eat?");
            
            units = inputInteger();
            
            if (is Integer food = units) {
                if (food > player.food) {
                    print("You do not have that much food.");
                    
                    units = askAgain;
                }
                else {
                    player.food -= food;
                    player.strength += 5 * food;
                    
                    return playerMoved;
                }
            }
        }
    }
    else {
        print("You have no food.");
    }
    
    return askAgain;
}

"Fights the [[Monster]] in the [[current room|currentRoom]], if one exists."
CommandResult fight() {
    value monster = roomContents.get(currentRoom);
    
    if (exists monster, is Monster monster) {
        variable value monsterStrength = monster.strength;
        
        print("Press Enter to fight."); // Don't have INKEY in Ceylon.
        process.readLine();
        
        if (player.armor) {
            print("Your armor increases your change of success.");
            pause();
            monsterStrength *= 3/4;
        }
        
        repeat(6, void() {print("*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*");});
        
        if (player.sword) {
            // TODO: Original version let you choose between sword and axe if you had both.
            print("You draw your sword.");
            monsterStrength *= 3/4;
        }
        else if (player.axe) {
            print("You have only an axe to fight with.");
            monsterStrength *= 4/5;
        }
        else {
            print("You have no weapons.");
            print("You must fight with your bare hands.");
            monsterStrength *= 6/5;
        }
        
        print("");
        print("");
        
        variable value fightCheck = 1.0;
        
        while (fightCheck > 0.35) {
            if (random.nextFloat() > 0.5) {
                print("``monster.name`` attacks.");
            }
            else {
                print("You attack.");
            }
            
            pause();
            
            if (random.nextFloat() > 0.5) {
                print("You manage to wound it.");
                monsterStrength *= 5/6;
            }
            else {
                print("The monster wounds you!");
                player.strength -= 5;
            }
            
            pause();
            
            fightCheck = random.nextFloat();
        }
        
        if (random.nextFloat() * 16 > monsterStrength.float) {
            print("And you managed to kill the ``monster.name``.");
            player.monstersKilled.add(monster);
        }
        else {
            print("The ``monster.name`` defeated you.");
            player.strength /= 2;
        }
        
        roomContents.remove(currentRoom);
        
        pause();
        print("");
        print("");
        pause();
        
        return playerMoved;
    }
    else {
        print("There is nothing to fight here.");
        
        return askAgain;
    }
}

"Returns an [[empty|getEmptyRooms]] [[Room]], chosen at [[random|getRandomRooms]]."
Room getEmptyRoom() {
    value emptyRooms = getEmptyRooms(1);
    value emptyRoom = emptyRooms.first;
    
    assert (exists emptyRoom);
    
    return emptyRoom;
}

"Returns [[count]] [[random|getRandomRooms]] empty [[Room]]s."
{Room*} getEmptyRooms(Integer count) {
    return getRandomRooms()
            .filter((Room room) => !roomContents.keys.contains(room))
            .take(count);
}

"Computes and returns a random [[Treasure]] amount that is between the two values, inclusive."
Treasure getRandomTreasureAmount(Integer minimum, Integer maximum) {
    return random.nextInteger(maximum - minimum + 1) + minimum;
}

"Places [[Monster]]s randomly in several [[Room]]s around the castle."
void initializeMonsters() {
    [
    Monster("Ferocious Werewolf", 5),
    Monster("Fanatical Fleshgorger", 10),
    Monster("Maloventy Maldemer", 15),
    Monster("Devastating Ice-Dragon", 20)
    ].each((Monster monster) => roomContents.put(getEmptyRoom(), monster));
}

"Asks the player's name and initializes the [[player]] member."
void initializePlayer() {
    print("What is your name, explorer?");
    
    String? name = process.readLine();
    
    assert(exists name);
    
    player = Player(name);
}

"Places [[Treasure]] in several [[Room]]s around the castle, some randomly."
void initializeTreasure() {
    // A few rooms always get a boosted amount of treasure.
    roomContents.put(meeting, getRandomTreasureAmount(100, 200));
    roomContents.put(treasury, getRandomTreasureAmount(100, 200));
    
    getEmptyRooms(4).each((Room room) => roomContents.put(room, getRandomTreasureAmount(10, 100)));
}

"Reads and parses an [[Integer]] from the standard input, returning [[askAgain]], if it can't be parsed."
CommandResult|Integer inputInteger() {
    String? line = process.readLine();
    
    if (exists line) {
        Integer? integer = parseInteger(line);
        
        if (exists integer) {
            return integer;
        }
    }
    
    return askAgain;
}

"Transports the [[player]] to a random [[Room]], if the player possesses
 [[the magic amulet|Player.amulet]]."
CommandResult magicAmulet() {
    // Original version didn't check to see if you actually had the amulet.
    if (player.amulet) {
        // Borrowing amulet effect from "Improved Version," so we have another
        // reason to use our repeat() method.
        void printAmuletEffect(Integer time) {
            value space = StringBuilder();
            
            for (i in 1..time) {
                space.append("  ");
            }
            
            print("``space``*");
        }
        
        repeat(10, printAmuletEffect);
        
        currentRoom = getRandomRoom();
        
        return playerMoved;
    }
    else {
        print("You do not have the magic amulet.");
        
        return askAgain;
    }
}

"The main processing loop of the application."
void mainLoop() {
    while (true) {
        print("");
        
        player.strength -= 5;
        
        if (player.strength <= 0) {
            displayLoseMessage();
            
            return;
        }
        
        player.tally += 1;
        
        player.describe();
        
        describeRoom(currentRoom, player.light, roomContents.get(currentRoom));
        
        variable CommandResult commandResult = askAgain;
        
        while (commandResult == askAgain) {
            commandResult = processCommand();
        }
        
        if (commandResult == playerQuit) {
            return;
        }
        
        if (currentRoom == exit) {
            displayWinMessage();
            
            return;
        }
    }
}

"Attempts to move the [[player]] in the given [[direction]] and returns the result of the attempt."
CommandResult move(Room?(Node) direction, String failureMessage) {
    value currentNode = layout.get(currentRoom);
    
    assert (exists currentNode);
    
    value newRoom = direction(currentNode);
    
    if (exists newRoom) {
        value contents = roomContents.get(currentRoom);
        
        if (exists contents, is Monster contents) {
            // Attempt to flee. The original version had lots of bad logic
            // here, including not checking for a monster first and not
            // actually letting you pick a direction to flee in.
            if (random.nextFloat() > 0.7) {
                print("No, you must stand and fight!");
                pause();
                fight();
                
                return playerMoved;
            }
            else {
                print("You flee the ``contents.name``!");
            }
        }
        
        currentRoom = newRoom;
        
        return playerMoved;
    } else {
        print(failureMessage);
        
        return askAgain;
    }
}

"Pauses execution for a brief period."
void pause() {
    // Doing it like the original program, so we don't have go native.
    value until = system.milliseconds + 1000;
    
    while (system.milliseconds < until) {
        // Pretend to be busy!
    }
}

"Picks up the [[Treasure]] in the [[current room|currentRoom]], if any, and
 adds it to the [[player]]'s [[wealth|Player.wealth]]."
CommandResult pickUp() {
    value contents = roomContents.get(currentRoom);
    
    if (exists contents, is Treasure contents) {
        if (player.light) {
            player.wealth += contents;
            roomContents.remove(currentRoom);
            
            return playerMoved;
        }
        else {
            print("You cannot see where it is.");
            pause();
        }
    }
    else {
        print("There is no treasure to pick up.");
        pause();
    }
    
    return askAgain;
}

"Reads a command from the input and attempts to execute it. Returns the result
 so the [[main loop|mainLoop]] knows what to do next."
CommandResult processCommand() {
    print("What do you want to do?");
    
    String? line = process.readLine();
    
    if (!exists line) {
        return playerQuit;
    }
    
    Character? command = line.getFromFirst(0);
    
    if (!exists command) {
        return playerQuit;
    }
    
    print("
           
           ------------------------------------");
    
    switch (command.uppercased)
    // Movement
    case ('N') {
        return move(Node.north, "No exit that way.");
    }
    case ('S') {
        return move(Node.south, "There is no exit south.");
    }
    case ('E') {
        return move(Node.east, "You cannot go in that direction.");
    }
    case ('W') {
        return move(Node.west, "You cannot move through solid stone.");
    }
    case ('U') {
        return move(Node.up, "There is no way up from here.");
    }
    case ('D') {
        return move(Node.down, "You cannot descend from here.");
    }
    // Other commands
    case ('C') {
        return eat();
    }
    case ('F') {
        return fight();
    }
    case ('I') {
        buyProvisions();
        
        return playerMoved;
    }
    case ('M') {
        return magicAmulet();
    }
    case ('P') {
        return pickUp();
    }
    case ('Q') {
        player.displayScore();
        
        return playerQuit;
    }
    else {
        print("Command not understood!");
    }
    
    return askAgain;
}

"Updates the [[player]] state to gain the requested object, if the player has enough money to buy it."
void purchase(Integer cost, Attribute<Player, Boolean, Boolean> attribute, String alreadyHaveIt) {
    value boundAttribute = attribute.bind(player);
    
    if (boundAttribute.get()) {
        print(alreadyHaveIt);
    }
    else if (player.wealth < cost) {
        // Skipping the severe punishment the original version had.
        print("You have tried to cheat me!");
    }
    else {
        player.wealth -= cost;
        boundAttribute.set(true);
    }
}

"Asks for how much food to purchase and updates the [[player]] state, as appropriate."
void purchaseFood() {
    print("How many units of food?");
    
    variable CommandResult|Integer units = askAgain;
    
    while (units == askAgain) {
        units = inputInteger();
        
        if (units == askAgain) {
            continue;
        }
        else if (is Integer food = units) {
            value cost = 2 * food;
            
            if (units == 0) {
                return;
            }
            else if (cost > player.wealth) {
                print("You haven't got enough money.");
                
                units = askAgain;
            }
            else {
                player.food += food;
                player.wealth -= cost;
            }
        }
    }
}

"""Performs the given [[action]] until it has been performed [[times]] times.
   Adapted from <a href="http://ceylon-lang.org/documentation/tour/functions/">this example in the Tour</a>."""
void repeat(Integer times, Anything()|Anything(Integer) action) {
    for (time in 1..times) {
        if (is Anything(Integer) action) {
            action(time);
        }
        else {
            action();
        }
    }
}
