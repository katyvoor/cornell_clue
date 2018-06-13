open Js_of_ocaml
open Js_of_ocaml_lwt
open Controller
open Types

(* js_of_ocaml helper declarations *)
module Html = Dom_html
let js = Js.string
let make_string = Js.to_string
let document = Html.document

(************************ DOM HELPERS ************************)
(* [fail] is a failure/exception handler *)
let fail = fun _ -> assert false

(* [get_element_by_id id] gets a DOM element by its id *)
let get_element_by_id id =
  Js.Opt.get (Html.document##getElementById (js id)) fail

(* [append_text e s] appends string s to element e *)
let append_text e s = Dom.appendChild e (document##createTextNode (js s))

(* Js.opt -> na *)
let unwrap to_unwrap = Js.Opt.get (to_unwrap) (fun () -> js "default")

(************************ GUI FUNCTIONS ************************)

let all_actions = [| "roll"; "passage"; "guess"; "accuse"; "skip"|]

let get_color m =
  (match m with
   | "Miss Martha" -> "#ce0000"
   | "Mr. Science" -> "#0f549c"
   | "Professor Edmund Ezra" -> "#a100b6"
   | "Mrs. Ginsberg" -> "#9ca9a7"
   | "Colonel Cornell" -> "#c3b746"
   | "Mr. Andy Bernard" -> "#3bbb16"
   | _ -> "#000")

let add_to_updates character text =
  let u = get_element_by_id "updates" in
  let break = Html.createBr document in
  let new_b = Html.createB document in
  let new_text = Html.createI document in
  new_b##.style##.color := js (get_color character);
  append_text new_b character;
  append_text new_text text;
  Dom.appendChild u break;
  Dom.appendChild u new_b;
  Dom.appendChild u new_text

let hide_setup b =
  let init = get_element_by_id "init" in
  if b
  then init##.style##.display := js "none"
  else init##.style##.display := js "block"

let hide_gamemode b =
  let gamemode = get_element_by_id "game_mode" in
  if b
  then gamemode##.style##.display := js "none"
  else gamemode##.style##.display := js "block"

let enable_all_buttons lst =
  Array.iteri (fun i x ->
      let b = get_element_by_id x in
      b##removeAttribute (js "disabled");
      b##.style##.backgroundColor := js "#fff") lst

let odd_ball i =
  (i=42) || (i=43) || (i=44) || (i=45)

let disable_all_tiles () =
  for i = 0 to 185
  do
    if (not (odd_ball i))
    then (let b = get_element_by_id (string_of_int i) in
          b##setAttribute (js "disabled") (js "disabled"));
  done;
  Array.iteri (fun i x ->
      let b = get_element_by_id x in
      b##setAttribute (js "disabled") (js "disabled")) all_rooms

let disable_all_buttons_except lst except =
  (Array.iteri (fun i x ->
       let b = get_element_by_id x in
       if (i<>except)
       then b##setAttribute (js "disabled") (js "disabled")) lst)

let disable_button id =
  (get_element_by_id id)##setAttribute (js "disabled") (js "disabled")

let get_cards cards =
  List.fold_left
    (fun acc e -> match e with
       | Character c -> acc@[get_gui_suspect_card c]
       | Room r -> acc@[get_gui_room_card r]
       | Weapon w -> acc@[get_gui_weapon_card w]) [] cards

let initialize_board gui_state game_state =
  (get_element_by_id "my_character")##setAttribute (js "src") (js (get_gui_suspect_card (!game_state.pl1.name)));
  let card_images = get_cards (!game_state).pl1.cards in
  (get_element_by_id "card1")##.style##.backgroundImage :=
    js ("url(" ^ List.nth card_images 0 ^")");
  (get_element_by_id "card2")##.style##.backgroundImage :=
    js ("url(" ^ List.nth card_images 1 ^")");
  (get_element_by_id "card3")##.style##.backgroundImage :=
    js ("url(" ^ List.nth card_images 2 ^")")

let get_room_offset r =
  match r with
  | "duffield_atrium" -> (40, 60)
  | "barton_hall" -> (60, 80)
  | "upson_lounge" -> (95, 48)
  | "keeton_dining_room" -> (77, 77)
  | "olin_library" -> (44, 44)
  | "statler_ballroom" -> (90, 62)
  | "phillips_kitchen" -> (55, 55)
  | "rpcc_billard_room" -> (80, 44)
  | "bailey_conservatory" -> (55, 44)
  | _ -> failwith "impossible"

let move_piece tile_id piece_id =
  let button_selected = get_element_by_id tile_id in
  let piece = get_element_by_id piece_id in
  if (is_a_room tile_id)
  then
    (piece##.style##.top := js (string_of_int (Js.parseInt button_selected##.style##.top + (snd (get_room_offset tile_id))));
     piece##.style##.left := js (string_of_int (Js.parseInt button_selected##.style##.left + (fst (get_room_offset tile_id)))))
  else
    (piece##.style##.top := button_selected##.style##.top;
     piece##.style##.left := button_selected##.style##.left)

let move_aipiece p new_loc =
  let new_loc = map_coordinates.(fst new_loc).(snd new_loc) in
  let new_loc_tile = get_element_by_id new_loc in
  let piece = get_element_by_id p in
  if (is_a_room new_loc)
  then
    (piece##.style##.top := js (string_of_int (Js.parseInt new_loc_tile##.style##.top + (fst (get_room_offset new_loc))));
     piece##.style##.left := js (string_of_int (Js.parseInt new_loc_tile##.style##.left + (snd (get_room_offset new_loc)))))
  else
    (piece##.style##.top := new_loc_tile##.style##.top;
     piece##.style##.left := new_loc_tile##.style##.left)

let update_card_to_show c =
  let new_card_image = (match c with
      | Some card -> (let card_to_show = get_cards [card] in
                      List.hd card_to_show)
      | None -> "https://media.giphy.com/media/SufoKsersIO2Y/giphy.gif") in
  (get_element_by_id "card_to_show")##setAttribute (js "src") (js new_card_image)

let user_location (game_state: Types.state ref) =
  (!game_state).locations.(index (!game_state).pl1.name)

(* [update_gui]
   first checks if the winner has won/lost, then does the following:
   - adds output_text to updates
   - updates card shown by other users
   - updates my location notif.
   - moves all the pieces according to game state's locations
   otherwise, displays win/lose modal.
*)
let update_gui (gui: Types.gui_state ref) (game: Types.state ref) =
  try (if ((!game).winner = (-1) && not (!game.losers.(!gui.chosen_chari)))
       then (add_to_updates (ch_name_tostring (fst (!game).output_text))
               (snd (!game).output_text);
             update_card_to_show (!game).card_to_show;
             (get_element_by_id "my_location")##.innerHTML :=
               (js (string_of_int (fst (user_location game)) ^ ", " ^
                    string_of_int (snd (user_location game))));
             Array.iteri (fun i x -> move_aipiece (int_to_pieceid i) x)
               (!game).locations)
       else if !game.losers.(!gui.chosen_chari)
       then (((get_element_by_id "lose_modal")##.style##.display := js "block"))
       else ((get_element_by_id "who_won")##.innerHTML :=
               js (ch_name_tostring (index_to_ch (!game).winner) ^ " has won.");
             (get_element_by_id "win_modal")##.style##.display := js "block"))
  with e -> add_to_updates "ERROR"
              "FOUND";
