open Types

let char_list = [
  MissMartha ;
  MrScience;
  ProfessorEdmundEzra;
  MrsGinsberg;
  ColonelCornell;
  MrAndyBernard
]

let prob_char lst ch =
  let per = (List.assoc ch lst) /. ((List.length lst - 1) |> float_of_int) in
  (List.fold_left (fun acc (a, b) ->
       if a <> ch then [(a, b +. per)] @ acc else acc) [] lst)

let prob_weapons lst we =
  let per = (List.assoc we lst) /. ((List.length lst - 1) |> float_of_int) in
  (List.fold_left (fun acc (a,b) ->
       if a <> we then [(a,b +. per)] @ acc else acc) [] lst)

let prob_rooms lst ro =
  let per = (List.assoc ro lst) /. ((List.length lst - 1) |> float_of_int) in
  (List.fold_left (fun acc (a,b) ->
       if a <> ro then [(a,b +. per)] @ acc else acc) [] lst)

let prob_shift card prob_reco =
  match card with
  | Character h -> begin
      if List.mem_assoc h prob_reco.characters
      then let new_char = (List.rev(prob_char prob_reco.characters h)) in
        {prob_reco with characters = new_char}
      else prob_reco
    end
  | Weapon h-> begin
      if List.mem_assoc h prob_reco.weapons
      then let new_weap = (List.rev(prob_weapons prob_reco.weapons h)) in
        {prob_reco with weapons = new_weap}
      else prob_reco
    end
  | Room h -> begin
      if List.mem_assoc h prob_reco.rooms
      then let new_room = (List.rev(prob_rooms prob_reco.rooms h)) in
        {prob_reco with rooms = new_room}
      else prob_reco
    end

let init_suspect_list cards prob_reco =
  match cards with
  | [a; b; c] -> (prob_shift a prob_reco) |> (prob_shift b) |> (prob_shift c)
  | _ -> failwith "Player was not given three cards"

let init_ai name_1 ai_combo dif init =
  { name = name_1;
    difficulty = dif;
    cards = ai_combo;
    suspect_list = init_suspect_list ai_combo init;
    visited_locations = []}

let shuffle lst =
  Random.self_init ();
  let nd = List.map (fun c -> (Random.bits (), c)) lst in
  let sond = List.sort compare nd in
  List.map snd sond

(* [guess_hard] similuates a hard AI guess: picks the topmost
 * probabilities using the AI's suspect list *)
let guess_hard ai st =
  let ch = (List.sort (fun y x -> if (snd x > snd y)
                        then 1 else 0) ai.suspect_list.characters) in
  let ch1 = List.hd (shuffle (ch)) in
  let we = (List.sort (fun y x -> if (snd x > snd y)
                        then 1 else 0) ai.suspect_list.weapons) in
  let we1 = List.hd (shuffle (we)) in
 (ch1,we1)

(* [guess_medium] similuates an medium AI guess: picks randomly from the top 50% of
 * probabilities using the AI's suspect list *)
let guess_medium ai st =
  let ch = (List.sort (fun y x -> if (snd x > snd y)
                        then 1 else 0) ai.suspect_list.characters) in
  let ch1 = List.hd (shuffle ((List.hd ch) :: (List.hd (List.tl ch)) ::
                              ((List.hd (List.tl (List.tl ch)))) :: [])) in
  let we = (List.sort (fun y x -> if (snd x > snd y)
                        then 1 else 0) ai.suspect_list.weapons) in
  let we1 = List.hd (shuffle ((List.hd we) :: (List.hd (List.tl we)) ::
                      ((List.hd (List.tl (List.tl we)))) :: [])) in
  (ch1,we1)

(* [guess_easy] guesses while disregarding the AI's suspect list *)
let guess_easy ai st =
  let ch = (List.hd (
      shuffle [MissMartha; MrScience; ProfessorEdmundEzra;
               MrsGinsberg; ColonelCornell; MrAndyBernard]),80.0) in
  let we = (List.hd (
      shuffle [DairyBarJug; FuertesTelescope; Revolver;
               ArchitectureKnife; RisleyCandleStick; Rope]),80.0) in
  (ch,we)

let guess ai st =
  let totals = if (ai.difficulty = Easy) then guess_easy ai st
    else if (ai.difficulty = Medium) then guess_medium ai st
    else guess_hard ai st in
  let ch = fst (fst totals) in
  let we = fst (snd totals) in
  let ro = get_room st.locations.(index ai.name) in
  st.output_text<-(ai.name,(ch_name_tostring ai.name ^ " guessed that it was "
                            ^ ch_name_tostring (ch) ^ " with the " ^
                            weapon_name_tostring (we)
                            ^ " in the " ^ room_name_tostring ro));
  { suspect = ch; weapon = we; room = ro }


let accuse_helper ai st =
  let ch = (List.fold_left (
      fun y x -> if (snd x > snd y)
                 then x else y) (MissMartha,0.0) ai.suspect_list.characters ) in
  let we = (List.fold_left (
      fun y x -> if (snd x > snd y)
                 then x else y) (DairyBarJug,0.0) ai.suspect_list.weapons ) in
  let ro = get_room st.locations.(index ai.name) in
  st.output_text<-(ai.name, (ch_name_tostring ai.name ^ " guessed that it was "
                            ^ ch_name_tostring (fst ch) ^ " with the " ^
                            weapon_name_tostring (fst we)
                            ^ " in the " ^ room_name_tostring ro ^
                            string_of_float (snd ch) ^  string_of_float (snd we)));
  {suspect = fst ch; weapon = fst we; room = ro}

let accuse ai st =
  let g = accuse_helper ai st in
  let ro1 = (List.fold_left (fun y x ->
      if (snd x > snd y)
      then x else y) (DuffAtrium,0.0) ai.suspect_list.rooms ) in
  let i = index ai.name in
  st.output_text<-(ai.name,(ch_name_tostring ai.name ^ " accused " ^
                            ch_name_tostring (g.suspect) ^ " with the " ^
                            weapon_name_tostring (g.weapon) ^ " in the " ^
                            room_name_tostring (fst ro1)));
  if (st.win_combination.character == Character(g.suspect) &&
      st.win_combination.room == Room( fst ro1) &&
      st.win_combination.weapon == Weapon(g.weapon))
  then {st with winner = i}
  else (st.losers.(i)<-true; st)

let rec enemy_share_information  (ai : ai_player) (gu : guess) (st : state) =
  (st.shared_info<-
     List.find_opt
       (fun x ->
          match x with
          | Weapon a -> a = gu.weapon
          | Character a ->  a = gu.suspect
          | Room a -> a = gu.room )
       ai.cards);
  st

let closest_to_room_easy ai loc loc_lst =
  let entrances = all_entrance_tiles in
  let default_move = List.hd (List.rev loc_lst) in
  let best_case = List.fold_left (
      fun acc (x,y) ->
        if List.mem (x,y) entrances then (x,y) else acc) loc loc_lst in
  if (best_case != loc) then best_case else default_move

let closest_to_room_medium ai loc loc_lst =
  let entrances = all_entrance_tiles in
  let default_move = List.hd (List.rev loc_lst) in
  let best_case = List.fold_left (
      fun acc (x,y) ->
        if List.mem (x,y) entrances then (x,y) else acc) loc loc_lst in
  if (best_case != loc) then best_case else default_move

let closest_to_room_hard ai loc loc_lst =
  let visited_locs = ai.visited_locations in
  let entrances = all_entrance_tiles in
  let default_move = List.hd (List.rev loc_lst) in
  let best_default_move = List.hd (
      List.rev (List.filter (
          fun (x,y) -> if (List.mem (x,y) visited_locs)
                       then false else true) loc_lst)) in
  let best_case = List.fold_left (
      fun acc (x,y) -> if List.mem (x,y) entrances
                       then (x,y) else acc) loc loc_lst in
  if (best_case != loc && not(List.mem best_case visited_locs)) then best_case
  else if (best_default_move != loc) then best_default_move
  else default_move

let move (ai : ai_player) (num:int) (st:state) =
  let loc = (st.locations.(index ai.name)) in
  let x = fst loc in
  let y = snd loc in
  let new_loc = if (ai.difficulty = Easy) then
      closest_to_room_easy ai loc (update_gui_valid_locations num loc st)
    else if (ai.difficulty = Medium) then
      closest_to_room_medium ai loc (update_gui_valid_locations num loc st)
    else closest_to_room_hard ai loc (update_gui_valid_locations num loc st) in
  ai.visited_locations <- ai.visited_locations @ [new_loc];
  st.locations.(index ai.name)<-(fst new_loc, snd new_loc );
  print_endline (string_of_int (x + fst new_loc));
  print_endline (string_of_int (y + snd new_loc));
  st.output_text<- (ai.name, "Rolled a " ^ (string_of_int num) ^ ".");
  st

let ai_get_room (ai : ai_player) (st:state) =
  let coor = st.locations.(index ai.name) in
  map_coordinates.(fst coor).(snd coor)

let use_passage (ai:ai_player)(st:state) =
  st.locations.(index ai.name)<-(get_passage (ai_get_room ai st) );
  st.output_text<-(ai.name," has used the secret passage to enter "
                           ^ (ai_get_room ai st));
  st
