import com.crappycomic.adventure.common {
    currentRoom,
    gameDisplayWinMessage = displayWinMessage,
    gameExit = exit,
    gameLayout = layout,
    gameStrings = strings,
    getEmptyRoom,
    getEmptyRooms,
    getRandomTreasureAmount,
    initializePlayer,
    mainLoop,
    roomContents,
    Monster,
    Room,
    Treasure,
    pause
}

"""Runs "Aftermath of the Asimovian Disaster.""""
shared void run() {
    gameLayout = layout;
    gameExit = exit;
    gameStrings = strings;
    gameDisplayWinMessage = displayWinMessage;
    currentRoom = wreckedHold;
    
    initializeTreasure();
    
    initializeMonsters();
    
    initializePlayer();
    
    mainLoop();
}

"Displays a congratulatory message."
void displayWinMessage(String name) {
    print("You are free! You have made it!");
    pause();
    print("Your pod sails free into space……");
    pause();
}

"Places [[Monster]]s randomly in several [[Room]]s around the ship."
void initializeMonsters() {
    [
    Monster("Berserk Android", 5),
    Monster("Deranged Del-Fievian", 10),
    Monster("Rampaging Robotic Device", 15),
    Monster("Sniggering Green Alien", 20)
    ].repeat(2)
    .each((Monster monster) => roomContents.put(getEmptyRoom(), monster));
}

"Places [[Treasure]] in several random [[Room]]s around the ship."
void initializeTreasure() {
    getEmptyRooms(4)
        .each((Room room) => roomContents.put(room, getRandomTreasureAmount(10, 100)));
}
