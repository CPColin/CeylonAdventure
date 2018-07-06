import ceylon.collection {
    MutableMap,
    HashMap
}

import ceylon.random {
    randomize,
    Random,
    DefaultRandom
}
import ceylon.language.meta.model {
    Attribute
}

shared late variable Room currentRoom;

"Displays a congratulatory message."
shared late Anything(String) displayWinMessage;

shared late Room exit;

shared late Layout layout;

late Player player;

Random random = DefaultRandom();

shared late Strings strings;

"Maps [[Room]]s to their [[contents|RoomContents]]."
shared MutableMap<Room, RoomContents> roomContents = HashMap<Room, RoomContents>();

"Allows the [[player]] to purchase provisions for the adventure."
void buyProvisions() {
    print(strings.provisionsHeading);
    
    variable CommandResult|Integer item = askAgain;
    
    while (item == askAgain) {
        pause();
        
        if (player.wealth <= 0) {
            print("You have no money.");
            
            return;
        }
        else {
            print(strings.currentWealth(player.wealth));
        }
        
        print(strings.provisionsPrompt);
        
        print("Enter number of item required.");
        
        item = inputInteger();
        
        switch (item)
        case (1) {
            purchase(15, `Player.light`, strings.alreadyHaveLight);
        }
        case (2) {
            purchase(10, `Player.weakWeapon`, strings.alreadyHaveWeakWeapon);
        }
        case (3) {
            purchase(20, `Player.strongWeapon`, strings.alreadyHaveStrongWeapon);
        }
        case (4) {
            purchaseFood();
        }
        case (5) {
            purchase(30, `Player.teleporter`, strings.alreadyHaveTeleporter);
        }
        case (6) {
            purchase(50, `Player.armor`, strings.alreadyHaveArmor);
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

"Prompts for how much food to eat and updates the [[player]]'s state."
CommandResult consume() {
    if (player.food > 0) {
        variable CommandResult|Integer units = askAgain;
        
        while (units == askAgain) {
            print(strings.currentFood(player.food));
            
            print(strings.consumePrompt);
            
            units = inputInteger();
            
            if (is Integer food = units) {
                if (food > player.food) {
                    print(strings.notEnoughFood);
                    
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
        print(strings.noFood);
    }
    
    return askAgain;
}

"Displays a message most players don't want to see."
void displayLoseMessage() {
    print(strings.loseMessage);
    pause();
}

"Fights the [[Monster]] in the [[current room|currentRoom]], if one exists."
CommandResult fight() {
    value monster = roomContents.get(currentRoom);
    
    if (is Monster monster) {
        variable value monsterStrength = monster.strength;
        
        print("Press Enter to fight."); // Don't have INKEY in Ceylon.
        process.readLine();
        
        if (player.armor) {
            print(strings.readyArmor);
            pause();
            monsterStrength *= 3/4;
        }
        
        repeat(6, void() {print("*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*");});
        
        value readyStrongWeapon = void() {
            print(strings.readyStrongWeapon);
            monsterStrength *= 3/4;
        };
        value readyWeakWeapon = void() {
            print(strings.readyWeakWeapon);
            monsterStrength *= 4/5;
        };
        
        if (player.strongWeapon && player.weakWeapon) {
            variable CommandResult|Integer choice = askAgain;
            
            while (choice == askAgain) {
                print(strings.weaponPrompt);
                
                choice = inputInteger();
                
                if (is Integer weapon = choice) {
                    if (weapon == 1) {
                        readyWeakWeapon();
                    }
                    else if (weapon == 2) {
                        readyStrongWeapon();
                    }
                    else {
                        choice = askAgain;
                    }
                }
            }
        }
        else if (player.strongWeapon) {
            readyStrongWeapon();
        }
        else if (player.weakWeapon) {
            readyWeakWeapon();
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

"Returns an [[empty|getEmptyRooms]] [[Room]], chosen at random."
shared Room getEmptyRoom() {
    value emptyRooms = getEmptyRooms(1);
    value emptyRoom = emptyRooms.first;
    
    assert (exists emptyRoom);
    
    return emptyRoom;
}

"Returns [[count]] [[random|getRandomRooms]] empty [[Room]]s."
shared {Room*} getEmptyRooms(Integer count) {
    return getRandomRooms()
        .filter((Room room) => !roomContents.keys.contains(room))
        .take(count);
}

"Returns a random, [[non-special|Room.special]] room."
Room getRandomRoom() {
    value randomRooms = getRandomRooms();
    value randomRoom = randomRooms.first;
    
    assert (exists randomRoom);
    
    return randomRoom;
}

"Returns the rooms in the [[layout]] in a random order, minus [[special|Room.special]] rooms."
{Room*} getRandomRooms() =>
    randomize(layout.keys.filter((Room room) => !room.special), random);

"Computes and returns a random [[Treasure]] amount that is between the two values, inclusive."
shared Treasure getRandomTreasureAmount(Integer minimum, Integer maximum) {
    return random.nextInteger(maximum - minimum + 1) + minimum;
}

"Initializes the name of the [[player]] character."
shared void initializePlayer() {
    print(strings.namePrompt);
    
    String? playerName = process.readLine();
    
    assert(exists playerName);
    
    player = Player(playerName);
}

"Reads and parses an [[Integer]] from the standard input, returning
 [[askAgain]], if it can't be parsed."
CommandResult|Integer inputInteger() {
    String? line = process.readLine();
    
    if (exists line) {
        value integer = Integer.parse(line);
        
        if (is Integer integer) {
            return integer;
        }
    }
    
    return askAgain;
}

"The main processing loop of the application."
shared void mainLoop() {
    while (true) {
        print("");
        
        player.strength -= 5;
        
        if (player.strength <= 0) {
            displayLoseMessage();
            
            return;
        }
        
        player.tally += 1;
        
        player.describe();
        
        currentRoom.describe(player.light, roomContents.get(currentRoom));
        
        variable CommandResult commandResult = askAgain;
        
        while (commandResult == askAgain) {
            commandResult = processCommand();
        }
        
        if (commandResult == playerQuit) {
            return;
        }
        
        if (currentRoom == exit) {
            displayWinMessage(player.name);
            
            player.displayScore();
            
            return;
        }
    }
}

"Attempts to move the [[player]] in the given [[direction]] and returns the
 result of the attempt."
CommandResult move(Room?(Node) direction, String failureMessage) {
    value currentNode = layout.get(currentRoom);
    
    assert (exists currentNode);
    
    value newRoom = direction(currentNode);
    
    if (exists newRoom) {
        value contents = roomContents.get(currentRoom);
        
        if (is Monster contents) {
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
shared void pause() {
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
    
    if (is Treasure contents) {
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
        print(strings.noTreasure);
        pause();
    }
    
    return askAgain;
}

"Reads a command from the input and attempts to execute it. Returns the result
 so the [[main loop|mainLoop]] knows what to do next."
CommandResult processCommand() {
    print("
           
           What do you want to do?");
    
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
        return move(Node.west, strings.noExitWest);
    }
    case ('U') {
        return move(Node.up, "There is no way up from here.");
    }
    case ('D') {
        return move(Node.down, "You cannot descend from here.");
    }
    // Other commands
    case ('B' | 'C') {
        return consume();
    }
    case ('F') {
        return fight();
    }
    case ('I') {
        buyProvisions();
        
        return playerMoved;
    }
    case ('M') {
        return teleport();
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
    print(strings.foodPrompt);
    
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

"Teleports the [[player]] to a random [[Room]], if the player possesses
 [[the teleporter|Player.teleporter]]."
CommandResult teleport() {
    // Original version didn't check to see if you could actually teleport.
    if (player.teleporter) {
        // Borrowing amulet effect from "Improved Version," so we have another
        // reason to use our repeat() method.
        void printTeleporterEffect(Integer time) {
            value space = StringBuilder();
            
            for (i in 1..time) {
                space.append("  ");
            }
            
            print("``space``*");
        }
        
        repeat(10, printTeleporterEffect);
        
        currentRoom = getRandomRoom();
        
        return playerMoved;
    }
    else {
        print(strings.noTeleporter);
        
        return askAgain;
    }
}
