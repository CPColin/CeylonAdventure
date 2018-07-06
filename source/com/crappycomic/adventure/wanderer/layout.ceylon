import com.crappycomic.adventure.common {
    Layout,
    Node,
    Room
}

Room audience = Room {
    "This is the audience chamber.
     There is a window to the west. By looking to the right
     through it you can see the entrance to the castle.
     Doors leave this room to the north, east, and south."
};

Room chambermaidsBedroom = Room {
    "Ooooh…You are in the chambermaids' bedroom.
     There is an exit to the west and a door
     to the south…."
};

Room dressingChamber = Room {
    "This tiny room on the upper level is the
     dressing chamber. There is a window to the
     north, with a view of the herb garden down
     below. A door leaves to the south."
};

Room dungeon = Room {
    "You are in the dank, dark dungeon.
     There is a single exit: a small hole in
     the wall towards the west."
};

Room entrance = Room {
    special = true;
    "You are looking at the entrance to a forbidding-looking
     stone castle. You are facing east."
};

Room exit = Room {
    special = true;
    "You've done it!!
     That was the exit from the castle!"
};

Room greatHall = Room {
    "You are in the great hall, an L-shaped room.
     There are doors to the east and to the north.
     In the alcove is a door to the west."
};

Room guardroom = Room {
    "You are in the prison guardroom, in the
     basement of the castle. The stairwell
     ends in this room. There is one other
     exit: a small hole in the east wall."
};

Room hallway = Room {
    "You are in the hallway.
     There is a door to the south.
     Through windows to the north you can see a secret herb garden."
};

Room innerHallway = Room {
    "This inner hallway contains a door to the north
     and one to the west and a circular stairwell
     passes through the room.
     You can see an ornamental lake through the
     windows to the south."
};

Room kitchen = Room {
    "This is the castle's kicthen. Through windows in
     the north wall you can see a secret herb garden."
};

// The original version paused during this description, then automatically
// moved the player to the Rear Vestibule, without a chance to pick up treasure
// or fight a monster, if present.
Room lift = Room {
    "You have entered the lift…
     It slowly descends…"
};

Room masterBedroom = Room {
    "You are in the master bedroom on the upper
     level of the castle.
     Looking down from the window to the west, you
     can see the entrance to the castle, while the
     secret herb garden is visible below the north
     window.There are doors to the east and
     to the south…"
};

Room meeting = Room {
    "This is the monarch's private meeting room.
     There is a single exit to the south."
};

Room outsideLift = Room {
    "This is the small room outside the castle
     lift, which can be entered by a door to the north.
     Another door leads to the west. You can see
     the lake through the southern windows."
};

Room storeroom = Room {
    "You are in the storeroom, amidst spices,
     vegetables, and vast sacks of flour and
     other provisions. There is a door to the north
     and one to the south."
};

Room treasury = Room {
    "This room was used as the castle treasury in
     by-gone years…
     There are no windows, just exits to the
     north and to the east."
};

Room upperHallway = Room {
    "This is the L-shaped upper hallway.
     To the north is a door and there is a
     stairwell in the hall as well. You can see
     the lake through the south windows."
};

Room vestibule = Room {
    "You are in the rear vestibule.
     There are windows to the south, from wich you
     can see the ornamental lake.
     There is an exit to the east and
     one to the south."
};

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
