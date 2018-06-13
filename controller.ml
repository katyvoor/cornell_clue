(* [controller.ml file] *)
open Player
open Enemy_ai
open Types

let shuffle lst =
  Random.self_init ();
  let nd = List.map (fun c -> (Random.bits (), c)) lst in
  let sond = List.sort compare nd in
  List.map snd sond

let card_combo_generator : card list list =
  let characters = shuffle [MissMartha; MrScience; ProfessorEdmundEzra;
                            MrsGinsberg; ColonelCornell; MrAndyBernard] in
  let weapons = shuffle [DairyBarJug; FuertesTelescope; Revolver;
                         ArchitectureKnife; RisleyCandleStick; Rope] in
  let rooms = shuffle [DuffAtrium; OlinLibrary; RPCCBillardRoom;
                       BaileyConservatory; StatlerBallroom; PhillipsKitchen;
                       KeetonDiningRoom; UpsonLounge; BartonHall] in
  let winning_combo =
    let (c:card) = (characters |> List.hd |> make_card_character) in
    let (w:card) = (weapons |> List.hd |> make_card_weapon) in
    let (r:card) = (rooms |> List.hd |> make_card_room) in
    c :: w :: r :: [] in
  let remaining_characters = characters |> List.tl |> List.map make_card_character in
  let remaining_weapons = weapons |> List.tl |> List.map make_card_weapon in
  let remaining_rooms = rooms |> List.tl |> List.map make_card_room in
  let shuffled = shuffle (remaining_characters @ remaining_weapons @ remaining_rooms) in
  let rec apply_pipeline num func arg =
    if num = 0 then List.hd arg
    else apply_pipeline (num-1) func (func arg) in
  let pl = (apply_pipeline 0 List.tl shuffled) ::
           (apply_pipeline 6 List.tl shuffled) ::
           (apply_pipeline 12 List.tl shuffled) :: [] in
  let ai1 = (apply_pipeline 1 List.tl shuffled) ::
            (apply_pipeline 7 List.tl shuffled) ::
            (apply_pipeline 13 List.tl shuffled) :: [] in
  let ai2 = (apply_pipeline 2 List.tl shuffled) ::
            (apply_pipeline 8 List.tl shuffled) ::
            (apply_pipeline 14 List.tl shuffled) :: [] in
  let ai3 = (apply_pipeline 3 List.tl shuffled) ::
            (apply_pipeline 9 List.tl shuffled) ::
            (apply_pipeline 15 List.tl shuffled) :: [] in
  let ai4 = (apply_pipeline 4 List.tl shuffled) ::
            (apply_pipeline 10 List.tl shuffled) ::
            (apply_pipeline 16 List.tl shuffled) :: [] in
  let ai5 = (apply_pipeline 5 List.tl shuffled) ::
            (apply_pipeline 11 List.tl shuffled) ::
            (apply_pipeline 17 List.tl shuffled) :: [] in
  [winning_combo; pl; ai1; ai2; ai3; ai4; ai5]

let first_player =
  MissMartha

let rec next_player_init (person : character_name) =
  match person with
  | MrScience -> ProfessorEdmundEzra
  | ProfessorEdmundEzra -> MrsGinsberg
  | MrsGinsberg -> ColonelCornell
  | ColonelCornell ->  MissMartha
  | MissMartha -> MrAndyBernard
  | MrAndyBernard -> MrScience

let rec apply_function num func arg =
  if num = 0 then arg
  else apply_function (num - 1) func (func arg)

let init_state pls_name (dif : difficulty) =
  let init_reco = {
    characters = [
      (MissMartha, 100.0/.6.0);
      (MrScience, 100.0/.6.0);
      (ProfessorEdmundEzra, 100.0/.6.0);
      (MrsGinsberg, 100.0/.6.0);
      (ColonelCornell, 100.0/.6.0);
      (MrAndyBernard, 100.0/.6.0)];
    weapons = [
      (DairyBarJug, 100.0/.6.0);
      (FuertesTelescope, 100.0/.6.0 );
      (Revolver, 100.0/.6.0);
      (ArchitectureKnife, 100.0/.6.0);
      (RisleyCandleStick, 100.0/.6.0);
      (Rope, 100.0/.6.0)];
    rooms = [
      (DuffAtrium, 100.0/.9.0);
      (OlinLibrary, 100.0/.9.0);
      (RPCCBillardRoom, 100.0/.9.0);
      (BaileyConservatory, 100.0/.9.0);
      (StatlerBallroom, 100.0/.9.0);
      (PhillipsKitchen, 100.0/.9.0);
      (KeetonDiningRoom, 100.0/.9.0);
      (UpsonLounge, 100.0/.9.0);
      (BartonHall, 100.0/.9.0)
    ]
  } in
  let card_combo = card_combo_generator in
  let win_character = card_combo |> List.hd |> List.hd in
  let win_weapon = card_combo |> List.hd |> List.tl |> List.hd in
  let win_room = card_combo |> List.hd |> List.tl |> List.tl |> List.hd in
  let (player_combo : card list) = (apply_function 1 List.tl card_combo) |> List.hd in
  let (pl1 : player) = (init_player pls_name player_combo) in
  let ai1_combo = (apply_function 2 List.tl card_combo) |> List.hd in
  let ai1 = (init_ai (
      apply_function 1 (next_player_init) pls_name) ai1_combo dif init_reco) in
  let ai2_combo = (apply_function 3 List.tl card_combo) |> List.hd in
  let ai2 = (init_ai (
      apply_function 2 (next_player_init) pls_name) ai2_combo dif init_reco) in
  let ai3_combo = (apply_function 4 List.tl card_combo) |> List.hd in
  let ai3 = (init_ai (
      apply_function 3 (next_player_init) pls_name) (ai3_combo) dif init_reco) in
  let ai4_combo = (apply_function 5 List.tl card_combo) |> List.hd in
  let ai4 = (init_ai (
      apply_function 4 (next_player_init) pls_name) (ai4_combo) dif init_reco) in
  let ai5_combo = (apply_function 6 List.tl card_combo) |> List.hd in
  let ai5 = (init_ai (
      apply_function 5 (next_player_init) pls_name) (ai5_combo) dif init_reco) in
  let current_act = (first_player, Roll) in
  {
    pl1 = pl1;
    ai1 = ai1;
    ai2 = ai2;
    ai3 = ai3;
    ai4 = ai4;
    ai5 = ai5;
    current_roll = -1;
    current_action = current_act;
    locations = [|
      (start_location MissMartha);
      (start_location MrScience);
      (start_location ProfessorEdmundEzra);
      (start_location MrsGinsberg);
      (start_location ColonelCornell);
      (start_location MrAndyBernard)
    |];
    win_combination = {
      character = win_character;
      room = win_room;
      weapon = win_weapon};
    shared_info = None;
    losers = [| false; false; false; false; false; false |];
    winner = -1;
    output_text = (pl1.name, "Welcome to Clue! " ^ ch_name_tostring(first_player)
                             ^ " will go first.");
    card_to_show = None;
    invalid_move = 0;
    weapon_locations = [|(-1,-1);(-1,-1);(-1,-1);(-1,-1);(-1,-1);(-1,-1);|]
  }

let player_is_user cname st =
  st.pl1.name  = cname

let index name =
  match name with
  | MissMartha -> 0
  | MrScience -> 1
  | ProfessorEdmundEzra -> 2
  | MrsGinsberg -> 3
  | ColonelCornell -> 4
  | MrAndyBernard -> 5

let rec player_guesses g other_player st =
  let next_person = unwrap_ai (get_playerai (next_player other_player st) st) in
  if (enemy_share_information next_person g st).shared_info = None &&
     (next_person.name) = st.pl1.name
  then
    {st with card_to_show = None;
             output_text = st.pl1.name,"No one was able to show you a card to
                                        refute your guess!"}
  else if (enemy_share_information next_person g st).shared_info != None
  then
    {st with output_text = (st.pl1.name, ch_name_tostring next_person.name
                                         ^ " has shared information with you!");
    card_to_show = (enemy_share_information next_person g st).shared_info}
  else (player_guesses g next_person.name st)

let unwrap_card_option c =
  match c with
  | Some x -> x
  | _ -> failwith "Not a valid card"

let rec ai_guesses g asker np_name st =
  let asker_name = index_to_ch asker in
  if np_name != st.pl1.name then(
    let ai_answer = unwrap_ai (get_playerai np_name st ) in
    let ai_asker = unwrap_ai (get_playerai asker_name st ) in
    if (enemy_share_information ai_answer g st).shared_info = None
    && np_name = asker_name
    then begin
      st.output_text<-(asker_name, "Guessed " ^ ch_name_tostring g.suspect
                                   ^ " in the "
        ^ room_name_tostring g.room ^ " with the  "
        ^ weapon_name_tostring g.weapon ^". Can you refute?");
        st.current_action<-(ai_asker.name, Share(g.suspect, g.room, g.weapon));
      st
    end
    else if (enemy_share_information ai_answer g st).shared_info != None
    then (st.output_text<-(ai_answer.name,"Information was shared with "
                                          ^ ch_name_tostring ai_asker.name ^ " !");
          ai_asker.suspect_list<-(prob_shift (unwrap_card_option st.shared_info)
                                    ai_asker.suspect_list);
              st)
    else (ai_guesses g asker (next_player np_name st) st))
  else
    ai_guesses g asker (next_player np_name st) st

let rec update_state ch act st : state =
  let roll_number = Random.int 6 + 1 in
  match act with
  | Roll -> begin
     if player_is_user ch st
     then player_roll ch roll_number st
     else Enemy_ai.move (unwrap_ai (get_playerai ch st)) roll_number st
   end
  | Passage -> begin
     if player_is_user ch st
     then Player.use_passage st.pl1 st ch
     else Enemy_ai.use_passage (unwrap_ai (get_playerai ch st)) st
    end
  | Move (x,y) -> begin
     if player_is_user ch st
     then Player.move (x,y) st ch
     else st
    end
  | Suggestion (c,r,w) -> begin
      if player_is_user ch st
       then begin
         (let guess = {weapon=w; suspect=c; room=r} in
          (if is_a_room
              (map_coordinates.(fst (st.locations.(index ch))).(snd (st.locations.(index ch))))
         then (player_guesses guess st.pl1.name st)
         else st))
       end
       else begin
         let ai = (unwrap_ai (get_playerai ch st)) in
         (ai_guesses (Enemy_ai.guess ai st) (index ai.name) (next_player ai.name st) st)
       end
    end
  | Accusation (c,r,w) -> begin
      if player_is_user ch st
      then Player.accuse c r w st
      else Enemy_ai.accuse (unwrap_ai (get_playerai ch st)) st
    end
  | Share (c,r,w) -> begin
      let ai = (unwrap_ai (get_playerai ch st)) in
      if st.shared_info != None
      then ai.suspect_list<-(prob_shift (unwrap_card_option st.shared_info)
                               ai.suspect_list);
      let new_curr = (next_player ch st, Move(-1,-1)) in
      {st with current_action = new_curr}
    end
