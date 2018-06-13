(* [types.mli file] *)

(* [character_name] represents one of the six characters playable in the game *)
type character_name =
  | MissMartha
  | MrScience
  | ProfessorEdmundEzra
  | MrsGinsberg
  | ColonelCornell
  | MrAndyBernard

(* [room_name] represents one of the nine rooms in the game game *)
type room_name =
  | DuffAtrium
  | OlinLibrary
  | RPCCBillardRoom
  | BaileyConservatory
  | StatlerBallroom
  | PhillipsKitchen
  | KeetonDiningRoom
  | UpsonLounge
  | BartonHall

(* [weapon_name] represents one of the six weapons in the game *)
type weapon_name =
  | DairyBarJug
  | FuertesTelescope
  | Revolver
  | ArchitectureKnife
  | RisleyCandleStick
  | Rope

(* [card] represents either a character, room, or weapon card a player can have *)
type card =
  | Character of character_name
  | Room of room_name
  | Weapon of weapon_name

(* [secret_passage] represents the beginning and ends of secret passages *)
type secret_passage = {
  start_id : room_name;
  exit_id : room_name; }

(* [guess] represents the structure of a guess a player can make *)
type guess = {
  weapon : weapon_name;
  suspect : character_name;
  room : room_name;
}

(* [room] represents one of the several rooms in the game *)
type room = {
  name : room_name;
  adjacent_rooms : string list;
  location : (int * int) list;
  secret_passage : secret_passage option;
}

(* [card_combination] represents the winning combination of cards involved in
   the murder *)
type card_combination = {
  character : card;
  room : card;
  weapon : card; }

val room_to_index : room_name -> int

(* [difficulty] represents the difficulty of an ai_player *)
type difficulty =
  | Easy
  | Medium
  | Hard

(* [info_record] keeps track of what the information AI knows and doesn't know
   with certainty recorded in float values *)
type info_record = {
  mutable characters : (character_name * float) list;
  mutable weapons : (weapon_name * float) list;
  mutable rooms : (room_name * float) list;
}

(* [ai_player] is one of the five instances of an AI player *)
type ai_player = {
  name: character_name;
  difficulty : difficulty;
  cards: card list;
  mutable suspect_list: info_record;
  mutable visited_locations: (int*int) list;
}

(* [player] represents the user *)
type player = {
  name : character_name;
  cards : card list;
}

(* [user] represents the two kinds of users in the game *)
type user =
  | Player of player
  | AI of ai_player

(* [direction] represents a direction a character can take *)
type direction =
    North of int
  | South of int
  | East of int
  | West of int
  | Enter of room_name

(* [action] represents a possible action that a character can take *)
type action =
  | Roll
  | Passage
  | Move of (int *int)
  | Suggestion of character_name * room_name * weapon_name
  | Accusation of character_name * room_name * weapon_name
  | Share of character_name * room_name * weapon_name

(* [state] represents the current state of the game *)
type state = {
  pl1: player;
  ai1: ai_player;
  ai2: ai_player;
  ai3: ai_player;
  ai4: ai_player;
  ai5: ai_player;
  mutable current_roll : int;
  mutable current_action: (character_name * action);
  locations: (int*int) array;
  win_combination: card_combination;
  mutable shared_info : card option;
  losers: bool array;
  winner: int;
  mutable output_text : (character_name * string);
  mutable card_to_show : card option;
  mutable invalid_move: int;
  mutable weapon_locations: (int*int) array;
}

(* [gui_state] represents the current state of the gui *)
type gui_state = {
  mutable action_selected : action;
  mutable gamewon : bool;
  mutable winner : character_name option;
  mutable can_choose_player : bool;
  mutable can_choose_diff : bool;
  mutable can_roll : bool;
  mutable can_passage : bool;
  mutable can_move : bool;
  mutable can_guess : bool;
  mutable can_accuse : bool;
  mutable chosen_chari : int;
  mutable chosen_diffi : int;
  mutable loc_selected : (int*int);
  mutable valid_locations: (int*int) list;
}

(* [character] represents the starting location of a given character *)
type character = {
  name : character_name;
  start : int * int;
}

(* [weapon] represents a given weapon *)
type weapon = {
  name : weapon_name;
}

val index : character_name -> int

(* [index_to_ch] returns the character type associated with an integer
   raises an error when integer > 5 is passed since only 6 characters exist *)
val index_to_ch : int -> character_name

(* [index_to_room] returns the room type associated with an integer
   raises an error when integer > 8 is passed since only 9 rooms exist *)
val index_to_room : int -> room_name

(* [index_to_weapon] returns the weapon type associated with an integer
   raises an error when integer > 5 is passed since only 6 weapons exist *)
val index_to_weapon : int -> weapon_name

(* [make_card_character] returns a card type with a given [character_name] *)
val make_card_character : character_name -> card

(* [make_card_room] returns a card type with a given [room_name] *)
val make_card_room : room_name -> card

(* [make_card_weapon] returns a card type with a given [weapon_name] *)
val make_card_weapon : weapon_name -> card

(* [start_location] initiates the starting locations of all the player for the
    24 x 25 board *)
val start_location : character_name -> int * int

(* [int_to_pieceid] returns ID of character piece in the GUI based on integer
   raises error when integer > 5 is passed since there are only 6 pieces *)
val int_to_pieceid : int -> string

(* [character_to_pieceid] returns ID of character piece based on character type *)
val character_to_imgid : character_name -> string

(* [duffield_atrium_entrances] represents all the tiles in the 24 x 25 board
    that are DuffAtrium entrances *)
val duffield_atrium_entrances : (int * int) list

(* [duffield_atrium_tiles] represents all the tiles in the 24 x 25 board that
    are part of DuffAtrium *)
val duffield_atrium_tiles : (int * int) list

(* [olin_library] represents all the tiles in the 24 x 25 board
    that are OlinLibrary entrances *)
val olin_library_entrances : (int * int) list

(* [olin_library_tiles] represents all the tiles in the 24 x 25 board that
    are part of OlinLibrary *)
val olin_library_tiles : (int * int) list

(* [rpcc_billard_room_entrances] represents all the tiles in the 24 x 25 board
    that are RPCCBillardRoom entrances *)
val rpcc_billard_room_entrances : (int * int) list

(* [rpcc_billard_room_tiles] represents all the tiles in the 24 x 25 board that
    are part of RPCCBillardRoom *)
val rpcc_billard_room_tiles : (int * int) list

(* [bailey_conservatory_entrances] represents all the tiles in the 24 x 25 board
    that are BaileyConservatory entrances *)
val bailey_conservatory_entrances : (int * int) list

(* [bailey_conservatory_tiles] represents all the tiles in the 24 x 25 board that
    are part of BaileyConservatory *)
val bailey_conservatory_tiles : (int * int) list

(* [barton_hall_tiles] represents all the tiles in the 24 x 25 board that
    are part of BartonHall *)
val barton_hall_tiles : (int * int) list

(* [statler_ballroom_entrances] represents all the tiles in the 24 x 25 board
    that are StatlerBallroom entrances *)
val statler_ballroom_entrances : (int * int) list

(* [statler_ballroom] represents all the tiles in the 24 x 25 board that
    are part of StatlerBallroom *)
val statler_ballroom_tiles : (int * int) list

(* [upson_lounge_entrances] represents all the tiles in the 24 x 25 board
    that are UpsonLounge entrances *)
val upson_lounge_entrances : (int * int) list

(* [upson_lounge_tiles] represents all the tiles in the 24 x 25 board that
    are part of UpsonLounge *)
val upson_lounge_tiles : (int * int) list

(* [phillips_kitchen_entrances] represents all the tiles in the 24 x 25 board
    that are PhillipsKitchen entrances *)
val phillips_kitchen_entrances : (int * int) list

(* [phillips_kitchen_tiles] represents all the tiles in the 24 x 25 board that
    are part of PhillipsKitchen *)
val phillips_kitchen_tiles : (int * int) list

(* [keeton_dining_room_entrances] represents all the tiles in the 24 x 25 board
    that are KeetonDiningRoom entrances *)
val keeton_dining_room_entrances : (int * int) list

(* [keeton_dining_room_tiles] represents all the tiles in the 24 x 25 board that
    are part of KeetonDiningRoom *)
val keeton_dining_room_tiles : (int * int) list

(*  [invalid_middle] represents all the tiles in the 24 x 25 board that are
    not valid locations to move *)
val invalid_middle : (int * int) list

(* [all_rooms_tiles] is a list of all tiles on the board *)
val all_room_tiles : (int * int) list

(* [all_entrance_tiles] is a list of all entrance tiles on the board *)
val all_entrance_tiles : (int * int) list

(* [map_coordinates] returns the array version of the board map *)
val map_coordinates : string array array

(* [is_a_room] returns whether the string represents a room *)
val is_a_room : string -> bool

(* [ch_name_tostring] returns the string representation of a character type *)
val ch_name_tostring : character_name -> string

(* [room_name_tostring] returns the string representation of a room type *)
val room_name_tostring : room_name -> string

(* [weapon_name_tostring] returns the string representation of a weapon type *)
val weapon_name_tostring : weapon_name -> string

(* [is_a_passage] returns whether a given string corresponds to a secret passage *)
val is_a_passage : string -> bool

(* [get_passage] returns the coordinates of the outside of a secret passage based
   on a given string *)
val get_passage : string -> int * int

(* [next_player] returns the next player based on who is still in the game *)
val next_player : character_name -> state -> character_name

(* [get_playerai] returns Some [ai_player] if the character name corresponds to
    an AI player, otherwise it returns None *)
val get_playerai : character_name -> state -> ai_player option

(* [unwrap_ai] returns an [ai_player] if the option refers to an AI player
   raises an error if the option is None *)
val unwrap_ai : ai_player option -> ai_player

(* [all_characters] is an array of all character IDs in the game *)
val all_characters : string array

(* [all_rooms] is an array of all room IDs in the game *)
val all_rooms : string array

(* [suspect_guess] is an array of all character guess IDs in the game *)
val suspect_guess : string array

(* [room_guess] is an array of all room guess IDs in the game *)
val room_guess : string array

(* [weapon_guess] is an array of all weapon guess IDs in the game *)
val weapon_guess : string array

(* [get_diff] is the difficulty based on a given integer, default difficult is
   medium *)
val get_diff : int -> difficulty

(* [difficulties] is an array of all difficulty guess IDs in the game *)
val difficulties : string array

(* [get_gui_suspect_card] returns the image file string of a given character *)
val get_gui_suspect_card : character_name -> string

(* [get_gui_room_card] returns the image file string of a given room *)
val get_gui_room_card : room_name -> string

(* [get_gui_weapon_card] returns the image file string of a given weapon *)
val get_gui_weapon_card : weapon_name -> string

(* [all_rooms_tiles] is a list of all tiles on the board *)
val get_xy_of_id : string -> (int * int)

(* [get_xy_of_id] returns the x,y coordinates of a room string *)
val get_coordinates_of_room : string -> (int * int) list

(* [filter_locations] returns a new list of locations based on whether
    they are valid or not *)
val filter_locations : (int*int) list -> state -> (int * int)list

(* [filter_locations] returns a new list of locations based on whether
    they are valid or not *)
val update_gui_valid_locations : int -> (int*int) -> state ->  (int*int) list

(* [get_room] returns whether a certain character is in a room *)
val in_a_room : character_name -> state -> bool

(* [get_room] returns the room a location is in *)
val get_room : (int*int) -> room_name

(* [act_tostring] returns a string representation of an action *)
val act_tostring : action -> string
