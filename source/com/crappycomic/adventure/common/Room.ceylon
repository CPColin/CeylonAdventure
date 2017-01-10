shared alias DescriptionLine => String|OccasionalDescription;

shared alias Layout => Map<Room, Node>;

shared alias OccasionalDescription => [String, Float];

"Encapsulates the linkages between [[Room]]s in the [[Layout]]."
shared class Node(shared Room? north = null,
    shared Room? south = null,
    shared Room? east = null,
    shared Room? west = null,
    shared Room? up = null,
    shared Room? down = null) {}

shared alias RoomContents => Treasure|Monster;

shared alias Treasure => Integer;

shared class Room({DescriptionLine+} descriptionLines, shared Boolean special = false) {
    "Describes the current [[Room]], lamenting the darkness when there isn't enough [[light]] and revealing the
     [[RoomContents]], if any."
    shared void describe(Boolean light, RoomContents? contents) {
        if (light) {
            printDescription();
        }
        else {
            print("It is too dark to see anything.");
        }
        
        switch(contents)
        case (is Treasure) {
            print("There is treasure here worth $``contents``.");
        }
        case (is Monster) {
            print(strings.danger);
            pause();
            print("It is a ``contents.name``!");
            print(strings.dangerLevel(contents.strength));
        }
        else {
            // Room is empty.
        }
        
        pause();
    }
    
    "Prints the lines that make up the description of this room, taking into account any desired probabilities."
    void printDescription() {
        for (DescriptionLine line in descriptionLines) {
            String text;
            
            switch (line)
            case (is String) {
                text = line;
            }
            case (is OccasionalDescription) {
                if (random.nextFloat() > line[1]) {
                    continue;
                }
                
                text = line[0];
            }
            
            print(text);
        }
    }
}
