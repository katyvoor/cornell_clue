open Js_of_ocaml
open Js_of_ocaml_lwt
open Controller
open Types
open Gui

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

(* [unwrap] unwraps a Js.opt -> na *)
let unwrap to_unwrap = Js.Opt.get (to_unwrap) (fun () -> js "default")

(* [get_ai_action] determines an AI action from the previous AI action *)
let get_ai_action (ai:ai_player) (game:state) :(character_name * action) =
  let p = Random.int 1 in
  let cur_st = game in
  let cur_loc = cur_st.locations.(index ai.name) in
  let prev_act = snd cur_st.current_action in
  let ch = (List.fold_left (
      fun y x -> if (snd x  >= 50.0)
                 then true else false||y) false ai.suspect_list.characters ) in
  let we = (List.fold_left (
      fun y x -> if (snd x >= 50.0)
                 then true else false||y) false ai.suspect_list.weapons ) in
  let ro = (List.fold_left (
      fun y x  -> if (snd x >= 50.0)
                  then  true else false||y) false ai.suspect_list.rooms ) in
  match prev_act with
  | Move x when x = (-1,-1) ->
    if in_a_room ai.name cur_st &&
       (is_a_passage map_coordinates.(fst cur_loc).(snd cur_loc))
    then (if p = 1 then (ai.name, Passage) else (ai.name, Roll))
    else (ai.name, Roll)
  (* has roll moved already, can S,A *)
  | Move x when x = (-2,-2) ->
    if ch || we || ro then (ai.name,Accusation(MissMartha, DuffAtrium, DairyBarJug))
    else if in_a_room ai.name cur_st then
      (ai.name, Suggestion(MissMartha, DuffAtrium, DairyBarJug))
    else (next_player ai.name cur_st, Move(-1,-1))
  | Passage ->
    if ch && we && ro then (ai.name,Accusation(MissMartha, DuffAtrium, DairyBarJug))
    else (ai.name, Suggestion(MissMartha, DuffAtrium, DairyBarJug))
  | Suggestion (c,r,w) -> (next_player ai.name cur_st, Move(-1,-1))
  | Accusation (c,r,w)-> (next_player ai.name cur_st, Move(-1,-1))
  | Share (c,r,w) -> (ai.name,Share (c,r,w))
  | _ -> failwith "impossible"

(* [con_to_gui] is part 1 of the mutual recursion game engine. It takes in
   information from [game], the back-end state, and relays it to [gui], the
   front-end state. *)
let rec con_to_gui (gui: gui_state ref) (game: state ref) =
  (let cp = (fst (!game).current_action) in
   let cur_act = (!game).current_action  in
   let cur_st = !game in
   let cur_loc = cur_st.locations.(index cp) in
   (!gui).gamewon<-((!game).winner != -1);
   (!gui).winner<-(if ((!gui).gamewon)
                   then Some (index_to_ch (!game).winner)
                   else None);
   if (player_is_user cp (!game)) then (
     match snd cur_act with
     | Roll ->
       update_gui gui game;
       (get_user_new_loc gui game)
     | Move x when x = (-1,-1) ->
       if in_a_room cp cur_st && (is_a_passage map_coordinates.(fst cur_loc).(snd cur_loc))
       then
         (get_next_action gui game ["R";"P"])
       else
         (get_next_action gui game ["R"])
     | Move _ ->
       update_gui gui game;
       if (in_a_room cp cur_st)
       then
         (get_next_action gui game ["S";"A";"N"])
       else
         (get_next_action gui game ["A";"N"])
     | Passage ->
       update_gui gui game;
       if (in_a_room cp cur_st)
       then (get_next_action gui game ["S";"A";"N"])
       else get_next_action gui game ["A";"N"]
     | Suggestion (c,r,w)->
       update_gui gui game;
       (get_next_action gui game ["N";"A"])
     | Accusation (c,r,w) ->
       update_gui gui game;
     | Share (c,r,w) -> failwith "should never happen"
   ) else (
     match snd cur_act with
     | Roll ->
       cur_st.current_action<-(cp, Move(-2,-2));
       game := cur_st;
       update_gui gui game;
       gui_to_con gui game
     | Move x when x = (-1,-1) ->
       gui_to_con gui game
     | Passage ->
       update_gui gui game;
       gui_to_con gui game
     | Suggestion (c,r,w)->
       cur_st.shared_info<- None;
       game := cur_st;
       update_gui gui game;
       gui_to_con gui game
     | Accusation (c,r,w) ->
       update_gui gui game;
       gui_to_con gui game
     | Share (c,r,w) ->
       update_gui gui game;
       get_shared_info gui game
     | _ -> failwith "Impossible"
   ))

(* [gui_to_con] is part 2 of the mutual recursion game engine. It takes in
   information from [gui], the front-end state, and relays it to [game], the
   back-end state. *)
and gui_to_con (gui: gui_state ref) (game: state ref) =
  let cur_st = (!game) in
  let ch = (fst (!game).current_action) in
  if player_is_user ch (!game)
  then (
    let new_game_state = update_state ch (snd (!game).current_action) (!game) in
    con_to_gui (gui) (ref new_game_state))
  else
    (cur_st.current_action<-(
        (get_ai_action (unwrap_ai (get_playerai ch cur_st)) cur_st));
     game := cur_st;
     if (player_is_user (fst cur_st.current_action) (!game))
     then (con_to_gui gui game)
     else (try
             con_to_gui (gui) (
               ref (update_state
                      (fst cur_st.current_action)
                      (snd cur_st.current_action) (!game)))
           with e -> con_to_gui (gui) (
               ref (update_state
                      (next_player (!game.pl1.name)
                         (!game)) (Move(-1, -1)) (!game)))))

(* [get_user_new_loc] takes in a [gui] gui_state and [game] state and relays
 * information about a user's move to [enable_tiles_for_move] *)
and get_user_new_loc gui game =
  (!gui).can_move <- true;
  let valid_locs = update_gui_valid_locations
      (!game).current_roll
      !game.locations.(index (!game.pl1.name)) !game in
  let filtered = List.filter (fun e -> (fst e <24) && (snd e <25)) valid_locs in
  let filtered_na = List.filter (
      fun e -> map_coordinates.(fst e).(snd e) <> "na") filtered in
  enable_tiles_for_move (filtered_na) gui game

(* [enable_tiles_for_move] takes in a lst of locations, [gui] gui_state, and
   [game] state and disables the buttons that are not to be clicked on the board. *)
and enable_tiles_for_move lst gui game =
  List.iteri (fun i x ->
      if (map_coordinates.(fst x).(snd x) <> "na") then
        (let b = get_element_by_id map_coordinates.(fst x).(snd x) in
         b##removeAttribute (js "disabled");
         b##.onclick := Dom_html.handler
             (fun _ ->
                let new_gui = !gui in
                new_gui.loc_selected <- x;
                new_gui.can_move <- false;
                disable_all_tiles ();
                move_piece  map_coordinates.(fst x).(snd x)
                  (int_to_pieceid (new_gui.chosen_chari));
                let new_game = !game in
                new_game.current_action <- (new_game.pl1.name, Move x);
                gui_to_con (ref new_gui) (ref new_game);
                Js._false))) lst

(* [enable_suggest_buttons] takes in a [gui] gui_state, and [game] state and
   enables the suggest button if the user is allowed to suggest *)
and enable_suggest_buttons gui game =
  let new_game = !game in
  let suspect = ref (-1) in
  let room = ref (-1) in
  let weapon = ref (-1) in
  enable_all_buttons suspect_guess;
  let my_room_id = room_to_index (get_room (!game.locations.(!gui.chosen_chari))) in
  let my_room = (room_guess.(my_room_id)) in
  enable_all_buttons [| my_room |];
  enable_all_buttons weapon_guess;
  Array.iteri (fun i x ->
      let b = get_element_by_id x in
      b##.onclick := Dom_html.handler
          (fun _ ->
             suspect := i; b##.style##.backgroundColor := js "#2cfbff";
             Js._false)) suspect_guess;
  room := my_room_id;
  (get_element_by_id my_room)##.style##.backgroundColor := js "#2cfbff";
  Array.iteri (fun i x ->
      let b = get_element_by_id x in
      b##.onclick := Dom_html.handler
          (fun _ ->
             weapon := i; b##.style##.backgroundColor := js "#2cfbff";
             Js._false)) weapon_guess;
  let b = get_element_by_id "submit" in
  b##.onclick := Dom_html.handler
      (fun _ ->
         new_game.current_action <- (
           new_game.pl1.name, Suggestion (
             index_to_ch !suspect, index_to_room !room, index_to_weapon !weapon));
         (get_element_by_id "guess_modal")##.style##.display := js "none";
         disable_all_buttons_except suspect_guess (-1);
         disable_all_buttons_except room_guess (-1);
         (get_element_by_id my_room)##.style##.backgroundColor := js "#fff";
         disable_all_buttons_except weapon_guess (-1);
         disable_all_buttons_except all_actions (-1);
         gui_to_con gui (ref new_game); Js._false);
  ()

(* [enable_accuse_buttons] takes in a [gui] gui_state, and [game] state and
   enables the accuse button if the user is allowed to accuse *)
and enable_accuse_buttons gui game =
  let new_game = !game in
  let suspect = ref (-1) in
  let room = ref (-1) in
  let weapon = ref (-1) in
  enable_all_buttons suspect_guess;
  enable_all_buttons room_guess;
  enable_all_buttons weapon_guess;
  Array.iteri (fun i x ->
      let b = get_element_by_id x in
      b##.onclick := Dom_html.handler
          (fun _ ->
             suspect := i; b##.style##.backgroundColor := js "#2cfbff";
             Js._false)) suspect_guess;
  Array.iteri (fun i x ->
      let b = get_element_by_id x in
      b##.onclick := Dom_html.handler
          (fun _ ->
             room := i; b##.style##.backgroundColor := js "#2cfbff";
             Js._false)) room_guess;
  Array.iteri (fun i x ->
      let b = get_element_by_id x in
      b##.onclick := Dom_html.handler
          (fun _ ->
             weapon := i; b##.style##.backgroundColor := js "#2cfbff";
             Js._false)) weapon_guess;
  let b = get_element_by_id "submit" in
  b##.onclick := Dom_html.handler
      (fun _ ->
         new_game.current_action <- (
           new_game.pl1.name,
           Accusation (
             index_to_ch !suspect, index_to_room !room, index_to_weapon !weapon));
         (get_element_by_id "guess_modal")##.style##.display := js "none";
         disable_all_buttons_except suspect_guess (-1);
         disable_all_buttons_except room_guess (-1);
         disable_all_buttons_except weapon_guess (-1);
         gui_to_con gui (ref new_game); Js._false);
  ()

(* [get_next_action] handles what the next action of the game is based on what
   was last selected by the user and updates the board accordingly *)
and get_next_action gui game actions =
  if List.mem "N" actions
  then (let skip_button = get_element_by_id "skip" in
        skip_button##removeAttribute (js "disabled");
        skip_button##.onclick := Dom_html.handler
            (fun _ ->
               let new_game = !game in
               new_game.current_action <-
                 (next_player (new_game.pl1.name) (new_game), Move(-1, -1));
               disable_all_buttons_except all_actions (-1);
               gui_to_con gui (ref new_game);
               Js._false));
  if List.mem "R" actions
  then (let roll_button = get_element_by_id "roll" in
        add_to_updates (ch_name_tostring (!game).pl1.name) ("It's Your Turn to Roll!");
        roll_button##removeAttribute (js "disabled");
        roll_button##.onclick := Dom_html.handler
            (fun _ ->
               let new_game = !game in
               let new_gui = !gui in
               new_gui.can_roll <- false;
               new_game.current_action <- (new_game.pl1.name, Roll);
               disable_all_buttons_except all_actions (-1);
               gui_to_con (ref new_gui) (ref new_game);
               Js._false));
  if List.mem "P" actions
  then (let passage_button = get_element_by_id "passage" in
        passage_button##removeAttribute (js "disabled");
        passage_button##.onclick := Dom_html.handler
            (fun _ ->
               let new_game = !game in
               let new_gui = !gui in
               new_gui.can_passage <- false;
               new_game.current_action <- (new_game.pl1.name, Passage);
               disable_all_buttons_except all_actions (-1);
               gui_to_con (ref new_gui) (ref new_game);
               Js._false));
  if List.mem "A" actions
  then (let accuse_button = get_element_by_id "accuse" in
        accuse_button##removeAttribute (js "disabled");
        accuse_button##.onclick := Dom_html.handler
            (fun _ ->
               let new_gui = !gui in
               new_gui.can_guess <- false;
               disable_all_buttons_except all_actions (-1);
               (get_element_by_id "guess_modal")##.style##.display := js "block";
               enable_accuse_buttons gui game;
               gui_to_con (ref new_gui) game;
               Js._false));
  if List.mem "S" actions
  then (let suggest_button = get_element_by_id "guess" in
        suggest_button##removeAttribute (js "disabled");
        suggest_button##.onclick := Dom_html.handler
            (fun _ ->
               let new_gui = !gui in
               new_gui.can_guess <- false;
               disable_all_buttons_except all_actions (-1);
               (get_element_by_id "guess_modal")##.style##.display := js "block";
               enable_suggest_buttons gui game;
               gui_to_con (ref new_gui) game;
               Js._false))

(* [get_shared_info] displays the card when information is shared between player *)
and get_shared_info gui game =
  List.iteri (fun i x ->
      let b = get_element_by_id x in
      b##.onclick := Dom_html.handler
          (fun _ ->
             let new_game = !game in
             if (x<>"none_selected")
             then new_game.shared_info <- Some(List.nth !game.pl1.cards i)
             else new_game.shared_info <- None;
             gui_to_con (gui) (ref new_game);
             Js._false)) ["card1_selected"; "card2_selected";
                          "card3_selected"; "none_selected"]

(* [init_game_state] initiates the board according to user selections and updates
    using con_to_gui*)
let init_game_state gui_state =
  let game_state = init_state (index_to_ch (!gui_state).chosen_chari)
      (get_diff (!gui_state).chosen_diffi) in
  initialize_board gui_state (ref game_state);
  update_gui gui_state (ref game_state);
  con_to_gui (gui_state)
    (ref (update_state (fst game_state.current_action)
            (snd game_state.current_action) (game_state)))


(* [get_character_setup] initiates the game based on what character the user
    has selected in the browser *)
let get_character_setup gui_state  =
  Array.iteri (fun i x -> let b = get_element_by_id x in
                b##.onclick := Dom_html.handler
                    (fun _ ->
                       if (!gui_state).can_choose_player
                       then ((!gui_state).chosen_chari <- i;
                             b##.style##.backgroundColor :=
                               js "#f2ff2c";
                             (!gui_state).can_choose_player <- false;
                             if (!gui_state).can_choose_diff (* diff not chosen *)
                             then (hide_setup false;
                                   hide_gamemode true)
                             else (hide_setup true;
                                   hide_gamemode false;
                                   init_game_state gui_state))
                       else (if (!gui_state).chosen_chari <> i
                             then b##setAttribute (js "disabled") (js "disabled"));
                       Js._false)) all_characters;
  ()

(* [get_level_setup] initiates the game based on what difficulty the user has
   selected in the browser *)
let get_level_setup gui_state =
  Array.iteri (fun i x -> let b = get_element_by_id x in
                b##.onclick := Dom_html.handler
                    (fun _ ->
                       if (!gui_state).can_choose_diff
                       then ((!gui_state).chosen_diffi <- i;
                             b##.style##.backgroundColor :=
                               js "#f2ff2c";
                             (!gui_state).can_choose_diff <- false;
                             if (!gui_state).can_choose_player (* diff not chosen *)
                             then (hide_setup false;
                                   hide_gamemode true)
                             else (hide_setup true;
                                   hide_gamemode false;
                                   init_game_state gui_state))
                       else (if (!gui_state).chosen_diffi <> i
                             then b##setAttribute (js "disabled") (js "disabled"));
                       Js._false)) difficulties;
  ()

(* [setup_tiles] takes in a gui and game state to set up the board and display
    which tiles get selected *)
let setup_tiles gui_state game_state =
  for i = 0 to 185
  do
    if (not (odd_ball i))
    then (let b = get_element_by_id (string_of_int i) in
          b##.onclick := Dom_html.handler
              (fun _ ->
                 (!gui_state).loc_selected <- get_xy_of_id (string_of_int i);
                 b##.style##.backgroundColor := js "#f2ff2c";
                 move_piece (string_of_int i) (int_to_pieceid !gui_state.chosen_chari);
                 Js._false))
  done

(* [main] initiates the GUI and REPL when a game starts and is called when the
    game is first run *)
let main () =
  let gui_state = ref ({
      gamewon = false;
      action_selected = Roll;
      winner = None;
      can_choose_player = true;
      can_choose_diff = true;
      can_roll = false;
      can_passage = false;
      can_move = false;
      can_guess = false;
      can_accuse = false;
      chosen_chari = (-1);
      chosen_diffi = (-1);
      loc_selected = (-1, -1);
      valid_locations = [];
    }) in
  hide_gamemode true;
  get_character_setup gui_state;
  get_level_setup gui_state;
  disable_all_buttons_except all_actions (-1);
  disable_all_tiles ();
  ()

let _ = main ()
