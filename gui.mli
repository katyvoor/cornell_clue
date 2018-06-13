(* [gui.mli file] *)
open Js_of_ocaml
open Js_of_ocaml_lwt
open Controller
open Types

(* [all_actions] is a string list of all the actions possible *)
val all_actions : string array

(* [add_to_updates] takes in 2 strings and outputs to the acitvity log in our game *)
val add_to_updates : string -> string -> unit

(*[hide_setup hides the initial game set up screen once the user has chose a
[character_name] and an ai [difficulty] *)
val hide_setup : bool -> unit

(* [hide_gamemode] hides the game mode once a winner is declared *)
val hide_gamemode : bool -> unit

(* [odd_ball determines whether int is 43,44,45,46 and deals with game bounds *)
val odd_ball : int -> bool

(* [get_color] returns the string hex of all of the players *)
val get_color : string -> string

(* [move_piece] takes in a tile and piece_id and moves the characters around
the game board *)
val move_piece : string -> string -> unit

(*[enable_abll_buttons] validates all of the buttons from the string array
passed in as a parameter *)
val enable_all_buttons : string array -> unit

(* [disable_alll_tiles] disables the tiles on the screen *)
val disable_all_tiles :  unit -> unit

(* [get_room_offset] gets the location of the spot in a room where
   a character will be displayed when in the room *)
val get_room_offset : string -> (int * int)

(* [disable_all_buttons_except] disables all buttons in
   the string array except for the one at index int *)
val disable_all_buttons_except : string array -> int -> unit

(* [get_card] trasnforms the passed in card list into a
   string list of the cards *)
val get_cards : card list -> string list

(* [initialize_board] takes in a gui_state and draws the board based on
   various fields in the state. *)
val initialize_board : Types.gui_state ref -> Types.state ref -> unit

(* [user_locations] takes in the game state ref and outputs a users
   location from the locations field *)
val user_location : Types.state ref -> (int * int)

(* [disable_button] disables a specific button passed in as a string *)
val disable_button : string -> unit

(* [update_card_to_show] displays a card if an AI has shared information
   with the user. Else, it is a question mark *)
val update_card_to_show : card option -> unit

(* [move_aipiece] takes in the piece and location and moves it on the game board *)
val move_aipiece : string -> (int * int) -> unit

(* [update_gui] takes in the new game state and updates the game board
   based on the previous move *)
val update_gui : Types.gui_state ref -> Types.state ref -> unit
