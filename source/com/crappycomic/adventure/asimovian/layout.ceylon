import com.crappycomic.adventure.common {
    Layout,
    Node,
    Room
}

Room androidStorage = Room {
    "You are standing in the android storage hold.
     Row upon row of metal men stand stiffly at
     attention, awaiting the distinctive sound of
     their long-dead captain to set them into motion.
     A light comes from the west and through the
     gravity well set into the floor."
};

Room commandCenter = Room {
    "You've stumbled on the secret command center,
     where screes bring views from all around the ship.
     There are two exits.",
    // This was an if-else in the original code.
    ["One exit is the gravity well.", 0.5],
    ["One exit leads to the goods hold.", 0.5]
};

Room crewQuarters = Room {
    "You are in the crew's sleeping quarters.",
    ["Most of the sleeping shells are empty.", 0.5],
    ["The few remaining crew stir fitfully
      in their endless, dreamless sleep.", 0.5],
    ["There are exits to the north, east, and west.", 0.3]
};

Room engineRoom = Room {
    "This is the power center of the ship.
     The characteristic blue metal light
     of the still-functioning ion drive
     fills the engine room.",
    ["Through the haze, you can see doors to the north and west.", 0.1],
    ["A shaft leads downwards to the repair center.", 0.4]
};

Room escapePod = Room {
    "Aha…. That looks like the space pod
     now and its outside dials
     indicate it is still in perfect condition."
};

Room exit = Room {
    special = true;
    "You are free. You have made it.
     Your pod sails free into space…."
};

Room galley = Room {
    "Food for all the crew was prepared in this galley.
     The remains from the preparations of the
     final meal can be seen. Doors leave the
     galley to the south and to the west."
};

Room hospital = Room {
    "This is the ship's hospital, white and sterile.
     A buzzing sound and a strange warmth come from
     the south, while a chill is felt to the north."
};

Room hydroponics = Room {
    "Acre upon acre of dried-up hydroponic
     plant beds stretch around you. Once, this
     area fed the thousand on board the ship.",
    ["The solar lamps are still shining.", 0.5],
    ["A few plants are still alive to the east.", 0.5]
};

Room maintenanceHold = Room {
    "This was the repair and maintenance
     hold of the ship. You can only leave it
     via the giant hangar door to the west."
};

Room navigation = Room {
    ["This is the ship's main navigation room.", 0.5],
    "Strange machinery lines the walls, while
     overhead, a holographic star map slowly turns.",
    ["By the flickering green light, you can just
      make out exits to the south and to the east.", 0.2]
};

Room observationPlatform = Room {
    ["What a superb sight….", 0.4],
    "The view of the stars from this observation
     platform is magnificent, as far as the eye
     can see. The single exit is back where you
     came from."
};

Room passengerQuarters = Room {
    "The former passenger suspended animation dormitory….",
    ["Passengers float by at random.", 0.5],
    ["It is enormous; it seems to go on forever.", 0.5],
    ["The only exits are to the west and south.", 0.1]
};

/* TODO
 This room is supposed to kill the player after two turns and is also supposed to forbit teleporting.
 I kind of like giving the player an escape route, though.
*/
Room radiationField = Room {
    special = true;
    ["Your body twists and burns….", 0.5],
    "You are caught in a deadly radiation field.
     Slowly, you realize this is the end…",
    ["…no matter what you do…", 0.5],
    ["…you are doomed to die here.", 0.5]
};

Room recreationCenter = Room {
    "You are in the former recreation
     center. Equipment for muscle-training
     in zero gravity litters the area."
};

Room repairCenter = Room {
    "Above you is the gravity shaft leading to
     the engine room. This is the ship repair
     center with emergency exits to the soldier
     androids storage and to the trading goods hold."
};

Room tradingGoods = Room {
    "Another cavernous, seemingly endless hold,
     this one crammed with goods for trading…",
    ["Rare metals and Venusian sculptures…", 0.3],
    ["Preserved Scalpian desert fish…", 0.2],
    ["Flashing ebony scith stones from Xariax IV…", 0.3],
    ["Awesome trader ant effigies from the Qwertyuiopian Empire…", 0.2],
    ["The light is stronger to the west.", 0.1]
};

Room weapons = Room {
    "A stark, metallic room, reeking of lubricants.
     Weapons line the wall, rank upon rank. Exits for
     soldier androids are to the north and the east."
};

Room wreckedHold = Room {
    special = true;
    "You are in the wrecked hold of a spaceship.
     The cavernous interior is littered with
     floating wreckage, as if from some
     terrible explosion eons ago…."
};

"The [[Layout]] of the ship."
Layout layout = map {
    androidStorage -> Node { west = engineRoom; down = commandCenter; },
    commandCenter -> Node { south = navigation; up = androidStorage; },
    crewQuarters -> Node { north = wreckedHold; east = passengerQuarters; west = hydroponics; },
    engineRoom -> Node { north = galley; east = androidStorage; west = weapons; down = repairCenter; },
    escapePod -> Node {
        // This room was probably padding, to keep the number of rooms the same between "Werewolves and Wanderer"
        // and this game. Otherwise, why not just end the game here?
        north = exit;
        south = exit;
        east = exit;
        west = exit;
        up = exit;
        down = exit;
    },
    exit -> Node {},
    galley -> Node { south = engineRoom; west = hospital; },
    hospital -> Node { north = escapePod; south = radiationField; east = galley; },
    hydroponics -> Node {
        north = recreationCenter;
        south = hydroponics;
        east = crewQuarters;
        west = hydroponics;
        up = hydroponics;
        down = hydroponics;
    },
    maintenanceHold -> Node { west = recreationCenter; },
    navigation -> Node { north = passengerQuarters; south = tradingGoods; east = commandCenter; },
    observationPlatform -> Node { west = wreckedHold; },
    passengerQuarters -> Node {
        north = passengerQuarters;
        south = navigation;
        east = passengerQuarters;
        west = crewQuarters;
        up = passengerQuarters;
        down = passengerQuarters;
    },
    radiationField -> Node { north = radiationField; west = radiationField; down = radiationField; },
    recreationCenter -> Node { south = hydroponics; east = maintenanceHold; },
    repairCenter -> Node { east = tradingGoods; west = weapons; up = engineRoom; },
    tradingGoods -> Node {
        north = navigation;
        south = tradingGoods;
        east = tradingGoods;
        west = repairCenter;
        up = tradingGoods;
        down = tradingGoods;
    },
    weapons -> Node { north = engineRoom; east = repairCenter; },
    wreckedHold -> Node {
        north = wreckedHold;
        south = crewQuarters;
        east = observationPlatform;
        west = wreckedHold;
        up = wreckedHold;
        down = wreckedHold;
    }
};
