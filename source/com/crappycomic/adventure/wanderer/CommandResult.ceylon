"The result of a command that the player has entered."
abstract class CommandResult() of askAgain | playerMoved | playerQuit {}

"A result that indicates the player should be asked again for input, either
 because the input was not understood, was not valid, or did not result in the
 player moving (and consuming strength)."
object askAgain extends CommandResult() {}

"A result that indicates the player has moved or performed some other action
 that should count as a full turn."
object playerMoved extends CommandResult() {}

"A result that indicates the player has ended the game."
object playerQuit extends CommandResult() {}
