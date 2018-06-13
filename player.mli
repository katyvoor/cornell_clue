open Types

(* [init_player c] takes in a character variant and returns the
   record representing the player. *)
val init_player : character_name -> card list -> player

(* [player_roll] similuates a player_roll and returns a state asking
   the user to choose a move *)
val player_roll: character_name -> int -> state -> state

(* [player_move] returns the state with the user's updated location
   and corresponding output text *)
val move : (int*int) -> state -> character_name -> state

(* [accuse] returns the state with the user's as a winner or loser when
   they choose to accuse *)
val accuse : character_name -> room_name -> weapon_name -> state -> state

(* [player_share_information] returns a card option based on whether a player
   can share information with the others *)
val player_share_information : card_combination -> state -> card option

(* [p1_get_room] returns a string representation of the room the player is in *)
val p1_get_room : player -> state -> string

(* [use_passage] returns the state with the user's updated location
   and corresponding output text when they chose to use a passage
   instead of roll *)
val use_passage : player -> state -> character_name -> state
