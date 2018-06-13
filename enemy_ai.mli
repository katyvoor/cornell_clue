(* [enemy_ai.ml file] *)
open Types

(* [char_list] is the list of all [character_name] types *)
val char_list : character_name list

(* [prob_characters] recalculates the new probabilites for a tuple list of
   character names and their probabilities based on a character card [x] not
   being in the correct combination *)
val prob_char : (character_name * float) list -> character_name
  -> (character_name * float) list

(* [prob_rooms] recalculates the new probabilites for a tuple list of
   room names and their probabilities based on a room card [x] not being in the
   correct combination *)
val prob_rooms : (room_name * float) list -> room_name
  -> (room_name * float) list

(* [prob_weapons] recalculates the new probabilites for a tuple list of
   weapons names and their probabilities based on a weapon card [x] not being in
   the correct combination *)
val prob_weapons : (weapon_name * float) list -> weapon_name
  -> (weapon_name * float) list

(* [prob_helper] updates the probability for a [prob_reco] give a [card] and
   returns a corresponding [info_record] *)
val prob_shift : card -> info_record -> info_record

(* [init_suspect_list] creates an [info_record] for the the AI based on what
   cards they received in [card list] and a starting [prob_reco] *)
val init_suspect_list : card list -> info_record -> info_record

(* [init_ai] creates an [ai_player] for the user to play against *)
val init_ai : character_name -> card list -> difficulty -> info_record
  -> ai_player

(* [shuffle] is a list shuffle function that returns a randomly sorted list *)
val shuffle : 'a list -> 'a list

(* [guess_easy] simulates an easy AI guess: picks randomly from the top 66% of
 * probabilities using the AI's suspect list *)
val guess_easy : ai_player -> state -> ((character_name*float) * (weapon_name*float))

(* [guess_medium] simulates an medium AI guess: picks randomly from the top 33%
 * of probabilities using the AI's suspect list *)
val guess_medium : ai_player -> state -> ((character_name*float) * (weapon_name*float))

(* [guess_medium] simulates an hard AI guess: it picks the topmost
 * probabilities using the AI's suspect list *)
val guess_hard : ai_player -> state -> ((character_name*float) * (weapon_name*float))

(* [guess] simulates an AI guess based on the difficulty and updates the state *)
val guess : ai_player -> state -> guess

(* [accuse_helper] creates a guess-like accusation based on the ai_player and
    state *)
val accuse_helper: ai_player -> state -> guess

(* [accuse] functions like guess but is called when it has a >90% probability
   for each card in a card combination *)
val accuse: ai_player -> state -> state

(* [share_information] takes in an [ai_player] and [player] to determine what
   information is shared between them *)
val enemy_share_information : ai_player -> guess -> state -> state

(* [closest_to_room_easy] simulates an easy AI move *)
val closest_to_room_easy : ai_player -> (int*int) -> (int*int) list -> (int*int)

(* [closest_to_room_medium] simulates an medium AI move *)
val closest_to_room_medium : ai_player -> (int*int) -> (int*int) list -> (int*int)

(* [closest_to_room_hard] simulates an hard AI move *)
val closest_to_room_hard : ai_player -> (int*int) -> (int*int) list -> (int*int)

(* [move] returns an updated state with the given player's new location *)
val move : ai_player -> int -> state -> state

(* [ai_get_room] returns the current room of an AI*)
val ai_get_room : ai_player -> state -> string

(* [use_passage] returns an updated state with the given player's new location *)
val use_passage: ai_player -> state -> state
