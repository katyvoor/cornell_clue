(* [controller.mli file] *)
open Player
open Enemy_ai
open Types

(* [shuffle] returns a list into a new list in a random order of elements *)
val shuffle : 'a list -> 'a list

(* [card_combo_generator] generates the winning card combination and then deals
    the remaining cards randomly to each of the 6 players *)
val card_combo_generator : card list list

(* [first_player] chooses MissMartha to go first  *)
val first_player : character_name

(* [next_player_init] chooses the next player to go after initializing the first
   player *)
val next_player_init : character_name -> character_name

(* [apply_function] applies [func] to [arg] [num] number of times *)
val apply_function : int -> ('a -> 'a) -> 'a -> 'a

(* [init_state] takes in the character of choice and a difficulty level from the
   user and initiates a game *)
val init_state : character_name -> difficulty -> state

(* [player_is_user] returns whether if [st] user's is [cname] *)
val player_is_user : character_name -> state -> bool

(* [index] returns the integer associated with a character_name *)
val index : character_name -> int

(* [player_guesses] returns a Some card if some AI can share information or None *)
val player_guesses : guess -> character_name -> state -> state

(* [unwrap_card_option] returns a card from a card option
    raises exception when the option is None *)
val unwrap_card_option : card option -> card

(* [ai_guesses] returns an update state based on what guesses have been made by
    players *)
val ai_guesses: guess -> int  -> character_name -> state -> state

(* [update_state] returns a new state based on a action by a player *)
val update_state : character_name -> action -> state -> state
