import ceylon.random {
    randomize
}

"A place in the [[Layout]] that the [[Player]] and other objects can occupy."
class Room(shared String description) {}

alias RoomContents => Treasure|Monster;

alias Treasure => Integer;

"Describes the given [[Room]], lamenting the darkness when there isn't enough
 [[light]] and revealing the [[RoomContents]], if any."
void describeRoom(Room room, Boolean light, RoomContents? contents) {
    if (light) {
        print(room.description);
    }
    else {
        print("It is too dark to see anything.");
    }
    
    switch(contents)
    case (is Treasure) {
        print("There is treasure here worth $``contents``.");
    }
    case (is Monster) {
        print("Danger…There is a monster here…");
        pause();
        print("It is a ``contents.name``!");
        print("The danger level is ``contents.strength``!!");
    }
    else {
        // Room is empty.
    }
    
    pause();
}

"Returns the rooms in the [[Layout]] in a random order, minux the [[entrance]] and [[exit]]."
{Room*} getRandomRooms() => randomize(layout.keys.filter((Room room) => room != entrance && room != exit));

"Returns a random room that is neither the [[entrance]] nor the [[exit]]."
Room getRandomRoom() {
    value randomRooms = getRandomRooms();
    value randomRoom = randomRooms.first;
    
    assert (exists randomRoom);
    
    return randomRoom;
}

// The rooms we'll be moseying through:

Room hallway = Room("You are in the hallway.
                     There is a door to the south.
                     Through windows to the north you can see a secret herb garden.");
Room audience = Room("This is the audience chamber.
                      There is a window to the west. By looking to the right
                      through it you can see the entrance to the castle.
                      Doors leave this room to the north, east, and south.");
Room greatHall = Room("You are in the great hall, an L-shaped room.
                       There are doors to the east and to the north.
                       In the alcove is a door to the west.");
Room meeting = Room("This is the monarch's private meeting room.
                     There is a single exit to the south.");
Room innerHallway = Room("This inner hallway contains a door to the north
                          and one to the west and a circular stairwell
                          passes through the room.
                          You can see an ornamental lake through the
                          windows to the south.");
Room entrance = Room("You are looking at the entrance to a forbidding-looking
                      stone castle. You are facing east.");
Room kitchen = Room("This is the castle's kicthen. Through windows in
                     the north wall you can see a secret herb garden.");
Room storeroom = Room("You are in the storeroom, amidst spices,
                       vegetables, and vast sacks of flour and
                       other provisions. There is a door to the north
                       and one to the south.");
// The original version paused during this description, then automatically
// moved the player to the Rear Vestibule, without a chance to pick up treasure
// or fight a monster, if present.
Room lift = Room("You have entered the lift…
                  It slowly descends…");
Room vestibule = Room("You are in the rear vestibule.
                       There are windows to the south, from wich you
                       can see the ornamental lake.
                       There is an exit to the east and
                       one to the south.");
Room exit = Room("You've done it!!
                  That was the exit from the castle!");
Room dungeon = Room("You are in the dank, dark dungeon.
                     There is a single exit: a small hole in
                     the wall towards the west.");
Room guardroom = Room("You are in the prison guardroom, in the
                       basement of the castle. The stairwell
                       ends in this room. There is one other
                       exit: a small hole in the east wall.");
Room masterBedroom = Room("You are in the master bedroom on the upper
                           level of the castle.
                           Looking down from the window to the west, you
                           can see the entrance to the castle, while the
                           secret herb garden is visible below the north
                           window.There are doors to the east and
                           to the south…");
Room upperHallway = Room("This is the L-shaped upper hallway.
                          To the north is a door and there is a
                          stairwell in the hall as well. You can see
                          the lake through the south windows.");
Room treasury = Room("This room was used as the castle treasury in
                      by-gone years…
                      There are no windows, just exists to the
                      north and to the east.");
Room chambermaidsBedroom = Room("Ooooh…You are in the chambermaids' bedroom.
                                 There is an exit to the west and a door
                                 to the south….");
Room dressingChamber = Room("This tiny room on the upper level is the
                             dressing chamber. There is a window to the
                             north, with a view of the herb garden down
                             below. A door leaves to the south.");
Room outsideLift = Room("This is the small room outside the castle
                         lift, which can be entered by a door to the north.
                         Another door leads to the west. You can see
                         the lake through the southern windows.");

"Encapsulates the linkages between [[Room]]s in the [[Layout]]."
class Node(shared Room? north = null,
    shared Room? south = null,
    shared Room? east = null,
    shared Room? west = null,
    shared Room? up = null,
    shared Room? down = null) {}

"Associates [[Room]]s with their [[Node]]s. We have to initialize all the rooms
 first because we can't make forward references to the rooms the various doors
 lead to."
alias Layout => Map<Room, Node>;

"The [[Layout]] of our castle."
Layout layout = map {
    hallway -> Node { west = entrance; south = audience; },
    audience -> Node { north = hallway; south = greatHall; east = greatHall; },
    greatHall -> Node { north = audience; east = innerHallway; },
    meeting -> Node { south = innerHallway; },
    innerHallway -> Node { north = meeting; west = greatHall; up = upperHallway; down = guardroom; },
    entrance -> Node { east = hallway; },
    kitchen -> Node { south = storeroom; },
    storeroom -> Node { north = kitchen; south = vestibule; },
    lift -> Node { south = vestibule; },
    vestibule -> Node { north = storeroom; east = exit; },
    exit -> Node { west = vestibule; },
    dungeon -> Node { west = guardroom; },
    guardroom -> Node { east = dungeon; up = innerHallway; },
    masterBedroom -> Node { south = upperHallway; east = chambermaidsBedroom; },
    upperHallway -> Node { north = masterBedroom; down = innerHallway; },
    treasury -> Node { north = chambermaidsBedroom; east = outsideLift; },
    chambermaidsBedroom -> Node { north = dressingChamber; south = treasury; west = masterBedroom; },
    dressingChamber -> Node { south = chambermaidsBedroom; },
    outsideLift -> Node { north = lift; west = treasury; }
};
