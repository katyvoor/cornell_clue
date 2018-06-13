open Types

let init_player (player_name: character_name) (cards_to_give:card list) : player =
  { name = player_name;
    cards = cards_to_give;
  }

let player_roll (ch:character_name) (num:int) (st:state) =
  if (ch = MrsGinsberg && num = 1) then(
    st.current_roll<-2;
    st.output_text<-(st.pl1.name,"You rolled a "^ string_of_int(st.current_roll)
                                 ^ ". Choose a move.");
    st )
  else ( st.current_roll<-num;
         st.output_text<-(st.pl1.name,"You rolled a "^ string_of_int(st.current_roll)
                                      ^ ". Choose a move.");
         st)

let rec move (d : int*int) (st:state) (ch:character_name) =
  let indexed_name = index ch in
  st.locations.(indexed_name)<-(fst d, snd d);
  st.output_text<-(st.pl1.name,"You moved!");
  st

let accuse (c: character_name) (r: room_name) (w: weapon_name) (st:state) =
  let i = index st.pl1.name in
  match (st.win_combination.character, st.win_combination.room, st.win_combination.weapon) with
  | (Character win_c, Room win_r, Weapon win_w) ->
    if (win_c=c && win_r=r && win_w=w)
    then {st with winner = i}
    else (st.losers.(i)<-true; st)
  | _ -> failwith "Not possible"

let player_share_information (g:card_combination) (st: state) : card option =
  let check = (ListLabels.find_opt (fun x -> x=g.character) st.pl1.cards,
               ListLabels.find_opt (fun x -> x=g.room) st.pl1.cards,
               ListLabels.find_opt (fun x -> x=g.weapon) st.pl1.cards) in
  match check with
  | (Some c, _, _) -> Some c
  | (_, Some r, _) -> Some r
  | (_, _, Some w) -> Some w
  | _ -> None

let p1_get_room (p1 : player) (st:state) :string =
  let coor = st.locations.(index p1.name) in
  map_coordinates.(fst coor).(snd coor)

let valid_passage (p1 : player) (st:state)=
  match p1_get_room p1 st with
  | "duffield_atrium" -> true
  | "bailey_conservatory" -> true
  | "phillips_kitchen" -> true
  | "upson_lounge" -> true
  | _ -> false

let use_passage (p1:player) (st:state) (ch : character_name) =
  if (valid_passage p1 st) then (
    st.locations.(index p1.name)<-(get_passage (p1_get_room p1 st));
    st.output_text<-(st.pl1.name, "You have used the secret passage to enter " ^ p1_get_room p1 st);
    st)
  else (
    st.output_text<-(st.pl1.name,"Invalid move. Make a different move.");
    st.invalid_move<-(1);
    st )
