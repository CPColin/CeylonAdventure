import com.crappycomic.adventure.common {
    currentRoom,
    gameExit = exit,
    gameDisplayWinMessage = displayWinMessage,
    gameLayout = layout,
    gameStrings = strings,
    getEmptyRoom,
    getEmptyRooms,
    getRandomTreasureAmount,
    initializePlayer,
    mainLoop,
    pause,
    roomContents,
    Monster,
    Room,
    Treasure
}

"""Runs "Werewolves and Wanderer.""""
shared void run() {
    gameLayout = layout;
    gameExit = exit;
    gameStrings = strings;
    gameDisplayWinMessage = displayWinMessage;
    currentRoom = entrance;
    
    initializeTreasure();
    
    initializeMonsters();
    
    initializePlayer();
    
    mainLoop();
}

"Displays a congratulatory message."
void displayWinMessage(String name) {
    print("You've done it!!");
    pause();
    print("That was the exit from the castle.");
    pause();
    print("You have succeeded, ``name``!
           You managed to get out of the castle.");
    pause();
    print("Well done!");
    pause();
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

"Places [[Treasure]] in several random [[Room]]s around the castle."
void initializeTreasure() {
    // A few rooms always get a boosted amount of treasure.
    roomContents.put(meeting, getRandomTreasureAmount(100, 200));
    roomContents.put(treasury, getRandomTreasureAmount(100, 200));
    
    getEmptyRooms(4).each((Room room) => roomContents.put(room, getRandomTreasureAmount(10, 100)));
}
