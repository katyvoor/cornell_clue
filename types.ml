(* [types.ml file] *)

type character_name =
  | MissMartha
  | MrScience
  | ProfessorEdmundEzra
  | MrsGinsberg
  | ColonelCornell
  | MrAndyBernard

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

type weapon_name =
  | DairyBarJug
  | FuertesTelescope
  | Revolver
  | ArchitectureKnife
  | RisleyCandleStick
  | Rope

type card =
  | Character of character_name
  | Room of room_name
  | Weapon of weapon_name

type secret_passage = {
  start_id: room_name;
  exit_id: room_name;
}

type guess = {
  weapon : weapon_name;
  suspect : character_name;
  room : room_name;
}

type room = {
  name: room_name;
  adjacent_rooms: string list;
  location: (int * int) list;
  secret_passage: secret_passage option
}

type card_combination = {
  character: card;
  room: card;
  weapon: card
}

type difficulty =
  | Easy
  | Medium
  | Hard

type info_record = {
  mutable characters: (character_name * float) list;
  mutable weapons: (weapon_name * float) list;
  mutable rooms: (room_name * float) list;
}

type ai_player = {
  name: character_name;
  difficulty : difficulty;
  cards: card list;
  mutable suspect_list: info_record;
  mutable visited_locations: (int*int) list;
}

type player = {
  name: character_name;
  cards: card list;
}

type user =
  | Player of player
  | AI of ai_player

type direction =
  | North of int
  | South of int
  | East of int
  | West of int
  | Enter of room_name

type action =
  | Roll
  | Passage
  | Move of (int*int)
  | Suggestion of character_name * room_name * weapon_name
  | Accusation of character_name * room_name * weapon_name
  | Share of character_name * room_name * weapon_name

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

type character = {
  name: character_name;
  start: (int*int);
}

type weapon = {
  name: weapon_name;
}

let index name =
  match name with
  | MissMartha -> 0
  | MrScience -> 1
  | ProfessorEdmundEzra -> 2
  | MrsGinsberg -> 3
  | ColonelCornell -> 4
  | MrAndyBernard -> 5

let index_to_ch (ind : int) =
  match ind with
  | 0 -> MissMartha
  | 1 -> MrScience
  | 2 -> ProfessorEdmundEzra
  | 3 -> MrsGinsberg
  | 4 -> ColonelCornell
  | 5 -> MrAndyBernard
  | _ -> failwith "Not an index"

let index_to_room ind =
  match ind with
  | 0 -> DuffAtrium
  | 1 -> OlinLibrary
  | 2 -> RPCCBillardRoom
  | 3 -> BaileyConservatory
  | 4 -> StatlerBallroom
  | 5 -> PhillipsKitchen
  | 6 -> KeetonDiningRoom
  | 7 -> UpsonLounge
  | 8 -> BartonHall
  | _ -> failwith "Not an index"

let room_to_index r =
  match r with
  | DuffAtrium -> 0
  | OlinLibrary -> 1
  | RPCCBillardRoom -> 2
  | BaileyConservatory -> 3
  | StatlerBallroom -> 4
  | PhillipsKitchen -> 5
  | KeetonDiningRoom -> 6
  | UpsonLounge -> 7
  | BartonHall -> 8

let index_to_weapon ind =
  match ind with
  | 0 -> DairyBarJug
  | 1 -> FuertesTelescope
  | 2 -> Revolver
  | 3 -> ArchitectureKnife
  | 4 -> RisleyCandleStick
  | 5 -> Rope
  | _ -> failwith "Not an index"

let make_card_character x =
  Character (x)

let make_card_room (x:room_name) =
  Room (x)

let make_card_weapon (x:weapon_name) =
  Weapon (x)

let start_location player :(int*int) =
  match player with
  | MrScience -> (0, 18)
  | ProfessorEdmundEzra -> (0, 5)
  | MrsGinsberg -> (14, 24)
  | ColonelCornell -> (23, 7)
  | MissMartha -> (16, 0)
  | MrAndyBernard -> (9, 24)

let int_to_pieceid i =
  match i with
  | 0 -> "missmartha_piece"
  | 1 -> "msscience_piece"
  | 2 -> "professoredmundezra_piece"
  | 3 -> "mrsginsberg_piece"
  | 4 -> "colonelcornell_piece"
  | 5 -> "mrandybernard_piece"
  | _ -> failwith "Not possible"

let character_to_imgid character =
  match character with
  | MissMartha -> "missmartha_piece"
  | MrScience -> "msscience_piece"
  | ProfessorEdmundEzra -> "professoredmundezra_piece"
  | MrsGinsberg -> "mrsginsberg_piece"
  | ColonelCornell -> "colonelcornell_piece"
  | MrAndyBernard -> "mrandybernard_piece"

let duffield_atrium_entrances = [(6,3)]

let duffield_atrium_tiles =  [
  (0, 0); (0, 1); (0, 2); (0, 3); (1, 0); (1, 1); (1, 2); (1, 3); (2, 0);
  (2, 1); (2, 2); (2, 3); (3, 0); (3, 1); (3, 2); (3, 3); (4, 0); (4, 1);
  (4, 2); (4, 3); (5, 0); (5, 1); (5, 2); (5, 3); (6, 1); (6, 2); (6, 3)]

let olin_library_entrances = [(3,10); (6,8)]

let olin_library_tiles = [
  (0, 7); (0, 8); (0, 9); (1, 6); (1, 7); (1, 8); (1, 9); (1, 10); (2, 6);
  (2, 7); (2, 8); (2, 9); (2, 10); (3, 6); (3, 7); (3, 8); (3, 9); (3, 10);
  (4, 6); (4, 7); (4, 8); (4, 9); (4, 10); (5, 6); (5, 7); (5, 8); (5, 9);
  (5, 10); (6, 7); (6, 8); (6, 9)
]

let rpcc_billard_room_entrances = [(1,12); (5,15)]

let rpcc_billard_room_tiles = [
  (0, 12); (0, 13); (0, 14); (0, 15); (0, 16); (1, 12); (1, 13); (1, 14);
  (1, 15); (1, 16); (2, 12); (2, 13); (2, 14); (2, 15); (2, 16); (3, 12);
  (3, 13); (3, 14); (3, 15); (3, 16); (4, 12); (4, 13); (4, 14); (4, 15);
  (4, 16); (5, 12); (5, 13); (5, 14); (5, 15); (5, 16)
]

let bailey_conservatory_entrances = [(4,19)]

let bailey_conservatory_tiles = [
  (0, 20); (0, 21); (0, 22); (0, 23); (1, 19); (1, 20); (1, 21); (1, 22);
  (1, 23); (2, 19); (2, 20); (2, 21); (2, 22); (2, 23); (3, 19); (3, 20);
  (3, 21); (3, 22); (3, 23); (4, 19); (4, 20); (4, 21); (4, 22); (4, 23);
  (5, 20); (5, 21); (5, 22); (5, 23)
]

let barton_hall_entrances = [(9,4); (11,6); (12,6)]

let barton_hall_tiles = [
  (9, 0); (9, 1); (9, 2); (9, 3); (9, 4); (9, 5); (9, 6); (10, 0); (10, 1);
  (10, 2); (10, 3); (10, 4); (10, 5); (10, 6); (11, 0); (11, 1); (11, 2);
  (11, 3); (11, 4); (11, 5); (11, 6); (12, 0); (12, 1); (12, 2); (12, 3);
  (12, 4); (12, 5); (12, 6); (13, 0); (13, 1); (13, 2); (13, 3); (13, 4);
  (13, 5); (13, 6); (14, 0); (14, 1); (14, 2); (14, 3); (14, 4); (14, 5);
  (14, 6)]

let statler_ballroom_entrances = [(8,19); (9,17); (14,17); (15,19)]

let statler_ballroom_tiles = [
  (8, 17); (8, 18); (8, 19); (8, 20); (8, 21); (8, 22); (9, 17); (9, 18);
  (9, 19); (9, 20); (9, 21); (9, 22); (10, 17); (10, 18); (10, 19); (10, 20);
  (10, 21); (10, 22); (10, 23); (11, 17); (11, 18); (11, 19); (11, 20);
  (11, 21); (11, 22); (11, 23); (12, 17); (12, 18); (12, 19); (12, 20);
  (12, 21); (12, 22); (12, 23); (13, 17); (13, 18); (13, 19); (13, 20);
  (13, 21); (13, 22); (13, 23); (14, 17); (14, 18); (14, 19); (14, 20);
  (14, 21); (14, 22); (15, 17); (15, 18); (15, 19); (15, 20); (15, 21);
  (15, 22)
]

let upson_lounge_entrances = [(17,5)]

let upson_lounge_tiles = [
  (17, 1); (17, 2); (17, 3); (17, 4); (17, 5); (18, 0); (18, 1); (18, 2);
  (18, 3); (18, 4); (18, 5); (19, 0); (19, 1); (19, 2); (19, 3); (19, 4);
  (19, 5); (20, 0); (20, 1); (20, 2); (20, 3); (20, 4); (20, 5); (21, 0);
  (21, 1); (21, 2); (21, 3); (21, 4); (21, 5); (22, 0); (22, 1); (22, 2);
  (22, 3); (22, 4); (22, 5); (23, 0); (23, 1); (23, 2); (23, 3); (23, 4);
  (23, 5)
]

let phillips_kitchen_entrances = [(19,18)]

let phillips_kitchen_tiles = [
  (18, 18); (18, 19); (18, 20); (18, 21); (18, 22); (18, 23); (19, 18);
  (19, 19); (19, 20); (19, 21); (19, 22); (19, 23); (20, 18); (20, 19);
  (20, 20); (20, 21); (20, 22); (20, 23); (21, 18); (21, 19); (21, 20);
  (21, 21); (21, 22); (21, 23); (22, 18); (22, 19); (22, 20); (22, 21);
  (22, 22); (22, 23); (23, 19); (23, 20); (23, 21); (23, 22); (23, 23)
]

let keeton_dining_room_entrances = [(16,12); (17,9)]

let keeton_dining_room_tiles = [
  (16, 9); (16, 10); (16, 11); (16, 12); (16, 13); (16, 14); (17, 9);
  (17, 10); (17, 11); (17, 12); (17, 13); (17, 14); (18, 9); (18, 10);
  (18, 11); (18, 12); (18, 13); (18, 14); (19, 9); (19, 10); (19, 11);
  (19, 12); (19, 13); (19, 14); (19, 15); (20, 9); (20, 10); (20, 11);
  (20, 12); (20, 13); (20, 14); (20, 15); (21, 9); (21, 10); (21, 11);
  (21, 12); (21, 13); (21, 14); (21, 15); (22, 9); (22, 10); (22, 11);
  (22, 12); (22, 13); (22, 14); (22, 15); (23, 9); (23, 10); (23, 11);
  (23, 12); (23, 13); (23, 14); (23, 15)
]

let invalid_middle = [
  (9,8); (9,9); (9,10); (9,11); (9,12); (9,13); (9,14);
  (10,8); (10,9); (10,10); (10,11); (10,12); (10,13); (10,14);
  (11,8); (11,9); (11,10); (11,11); (11,12); (11,13); (11,14);
  (12,8); (12,9); (12,10); (12,11); (12,12); (12,13); (12,14);
  (13,8); (13,9); (13,10); (13,11); (13,12); (13,13); (13,14)
]

let all_room_tiles = invalid_middle @ duffield_atrium_tiles @ olin_library_tiles
                     @ rpcc_billard_room_tiles @ bailey_conservatory_tiles @
                     barton_hall_tiles @ statler_ballroom_tiles @ upson_lounge_tiles
                     @ phillips_kitchen_tiles @ keeton_dining_room_tiles

let all_entrance_tiles = duffield_atrium_entrances @ olin_library_entrances
                         @ rpcc_billard_room_entrances @
                         bailey_conservatory_entrances @ barton_hall_entrances
                         @ statler_ballroom_entrances @ upson_lounge_entrances
                         @ phillips_kitchen_entrances @ keeton_dining_room_entrances


let map_coordinates =
  [|
    [| "duffield_atrium"; "duffield_atrium"; "duffield_atrium"; "duffield_atrium";
       "na"; "professoredmundezra_piece"; "na"; "olin_library"; "olin_library";
       "olin_library"; "na"; "na"; "rpcc_billard_room"; "rpcc_billard_room";
       "rpcc_billard_room"; "rpcc_billard_room"; "rpcc_billard_room"; "na";
       "msscience_piece"; "na"; "bailey_conservatory"; "bailey_conservatory";
       "bailey_conservatory"; "bailey_conservatory";  "na";|] ;
    [| "duffield_atrium"; "duffield_atrium"; "duffield_atrium"; "duffield_atrium";
       "0"; "1"; "olin_library"; "olin_library"; "olin_library"; "olin_library";
       "olin_library"; "2"; "rpcc_billard_room"; "rpcc_billard_room";
       "rpcc_billard_room";  "rpcc_billard_room";  "rpcc_billard_room"; "3"; "4";
       "bailey_conservatory"; "bailey_conservatory"; "bailey_conservatory";
       "bailey_conservatory"; "bailey_conservatory"; "na"; |];
    [| "duffield_atrium"; "duffield_atrium"; "duffield_atrium"; "duffield_atrium";
       "5"; "6"; "olin_library"; "olin_library"; "olin_library"; "olin_library";
       "olin_library"; "7"; "rpcc_billard_room"; "rpcc_billard_room";
       "rpcc_billard_room";  "rpcc_billard_room";  "rpcc_billard_room"; "8"; "9";
       "bailey_conservatory"; "bailey_conservatory"; "bailey_conservatory";
       "bailey_conservatory"; "bailey_conservatory"; "na"; |];
    [| "duffield_atrium"; "duffield_atrium"; "duffield_atrium"; "duffield_atrium";
       "10"; "11"; "olin_library"; "olin_library"; "olin_library"; "olin_library";
       "olin_library"; "12"; "rpcc_billard_room"; "rpcc_billard_room";
       "rpcc_billard_room";  "rpcc_billard_room";  "rpcc_billard_room"; "13"; "14";
       "bailey_conservatory"; "bailey_conservatory"; "bailey_conservatory";
       "bailey_conservatory"; "bailey_conservatory"; "na"; |];
    [| "duffield_atrium"; "duffield_atrium"; "duffield_atrium"; "duffield_atrium";
       "15"; "16"; "olin_library"; "olin_library"; "olin_library"; "olin_library";
       "olin_library"; "17"; "rpcc_billard_room"; "rpcc_billard_room";
       "rpcc_billard_room";  "rpcc_billard_room";  "rpcc_billard_room"; "18"; "19";
       "bailey_conservatory"; "bailey_conservatory"; "bailey_conservatory";
       "bailey_conservatory"; "bailey_conservatory"; "na"; |];
    [| "duffield_atrium"; "duffield_atrium"; "duffield_atrium"; "duffield_atrium";
       "20"; "21"; "olin_library"; "olin_library"; "olin_library"; "olin_library";
       "olin_library"; "22"; "rpcc_billard_room"; "rpcc_billard_room";
       "rpcc_billard_room";  "rpcc_billard_room";  "rpcc_billard_room"; "23"; "24";
       "25"; "bailey_conservatory"; "bailey_conservatory"; "bailey_conservatory";
       "bailey_conservatory"; "na"; |];
    [| "na"; "duffield_atrium"; "duffield_atrium"; "duffield_atrium"; "66"; "67";
       "68"; "olin_library"; "olin_library"; "olin_library"; "69"; "70"; "71";
       "72";  "73";  "74";  "75"; "76"; "77"; "78"; "79"; "80"; "81"; "na"; "na"; |];
    [| "82"; "83"; "84"; "85"; "86"; "87"; "88"; "89"; "90"; "91"; "92"; "93";
       "94"; "95";  "96";  "97";  "98"; "99"; "100"; "101"; "102"; "103"; "104";
       "105"; "na"; |];
    [| "na"; "106"; "107"; "108"; "109"; "110"; "111"; "112"; "113"; "114"; "115";
       "116"; "117"; "118";  "119";  "120";  "121"; "statler_ballroom";
       "statler_ballroom"; "statler_ballroom"; "statler_ballroom"; "statler_ballroom";
       "statler_ballroom"; "122"; "na"; |];
    [| "barton_hall"; "barton_hall"; "barton_hall"; "barton_hall"; "barton_hall";
       "barton_hall"; "barton_hall"; "26"; "na"; "na"; "na"; "na"; "na"; "na";
       "na";  "27";  "28"; "statler_ballroom"; "statler_ballroom"; "statler_ballroom";
       "statler_ballroom"; "statler_ballroom"; "statler_ballroom"; "29";
       "mrandybernard_piece" |];
    [| "barton_hall"; "barton_hall"; "barton_hall"; "barton_hall"; "barton_hall";
       "barton_hall"; "barton_hall"; "30"; "na"; "na"; "na"; "na"; "na"; "na";
       "na";  "31";  "32"; "statler_ballroom"; "statler_ballroom";
       "statler_ballroom"; "statler_ballroom"; "statler_ballroom";
       "statler_ballroom"; "statler_ballroom"; "na"; |];
    [| "barton_hall"; "barton_hall"; "barton_hall"; "barton_hall"; "barton_hall";
       "barton_hall"; "barton_hall"; "33"; "na"; "na"; "na"; "na"; "na"; "na";
       "na";  "34";  "35"; "statler_ballroom"; "statler_ballroom"; "statler_ballroom";
       "statler_ballroom"; "statler_ballroom"; "statler_ballroom"; "statler_ballroom";
       "na"; |];
    [| "barton_hall"; "barton_hall"; "barton_hall"; "barton_hall"; "barton_hall";
       "barton_hall"; "barton_hall"; "36"; "na"; "na"; "na"; "na"; "na"; "na";
       "na";  "37";  "38"; "statler_ballroom"; "statler_ballroom"; "statler_ballroom";
       "statler_ballroom"; "statler_ballroom"; "statler_ballroom"; "statler_ballroom";
       "na"; |];
    [| "barton_hall"; "barton_hall"; "barton_hall"; "barton_hall"; "barton_hall";
       "barton_hall"; "barton_hall"; "39"; "na"; "na"; "na"; "na"; "na"; "na";
       "na";  "40";  "41"; "statler_ballroom"; "statler_ballroom"; "statler_ballroom";
       "statler_ballroom"; "statler_ballroom"; "statler_ballroom"; "statler_ballroom";
       "na"; |];
    [| "barton_hall"; "barton_hall"; "barton_hall"; "barton_hall"; "barton_hall";
       "barton_hall"; "barton_hall"; "140"; "141"; "142"; "143"; "144"; "145";
       "146";  "147";  "148";  "149"; "statler_ballroom"; "statler_ballroom";
       "statler_ballroom"; "statler_ballroom"; "statler_ballroom"; "statler_ballroom";
       "150"; "mrsginsberg_piece"; |];
    [| "na"; "123"; "124"; "125"; "126"; "127"; "128"; "129"; "130"; "131"; "132";
       "133"; "134"; "135";  "136";  "137";  "138"; "statler_ballroom";
       "statler_ballroom";  "statler_ballroom"; "statler_ballroom";
       "statler_ballroom"; "statler_ballroom"; "139"; "na"; |];
    [| "missmartha_piece"; "151"; "152"; "153"; "154"; "155"; "156"; "157"; "158";
       "keeton_dining_room"; "keeton_dining_room"; "keeton_dining_room";
       "keeton_dining_room"; "keeton_dining_room";  "keeton_dining_room";  "159";
       "160"; "161"; "162"; "163"; "164"; "165"; "166"; "167"; "na"; |];
    [| "na"; "upson_lounge"; "upson_lounge"; "upson_lounge"; "upson_lounge";
       "upson_lounge"; "168"; "169"; "170"; "keeton_dining_room";
       "keeton_dining_room"; "keeton_dining_room"; "keeton_dining_room";
       "keeton_dining_room";  "keeton_dining_room";  "171";  "172"; "173";
       "174"; "175"; "176"; "177"; "178"; "na"; "na"; |];
    [| "upson_lounge"; "upson_lounge"; "upson_lounge"; "upson_lounge";
       "upson_lounge"; "upson_lounge"; "179"; "180"; "181"; "keeton_dining_room";
       "keeton_dining_room"; "keeton_dining_room"; "keeton_dining_room";
       "keeton_dining_room";  "keeton_dining_room";  "182";  "183"; "184";
       "phillips_kitchen"; "phillips_kitchen"; "phillips_kitchen";
       "phillips_kitchen"; "phillips_kitchen"; "phillips_kitchen"; "na"; |];
    [| "upson_lounge"; "upson_lounge"; "upson_lounge"; "upson_lounge";
       "upson_lounge"; "upson_lounge"; "46"; "47"; "48"; "keeton_dining_room";
       "keeton_dining_room"; "keeton_dining_room"; "keeton_dining_room";
       "keeton_dining_room";  "keeton_dining_room";  "keeton_dining_room";
       "49"; "50"; "phillips_kitchen"; "phillips_kitchen"; "phillips_kitchen";
       "phillips_kitchen"; "phillips_kitchen"; "phillips_kitchen"; "na"; |];
    [| "upson_lounge"; "upson_lounge"; "upson_lounge"; "upson_lounge";
       "upson_lounge"; "upson_lounge"; "51"; "52"; "53"; "keeton_dining_room";
       "keeton_dining_room"; "keeton_dining_room"; "keeton_dining_room";
       "keeton_dining_room";  "keeton_dining_room";  "keeton_dining_room";
       "54"; "55"; "phillips_kitchen"; "phillips_kitchen"; "phillips_kitchen";
       "phillips_kitchen"; "phillips_kitchen"; "phillips_kitchen"; "na"; |];
    [| "upson_lounge"; "upson_lounge"; "upson_lounge"; "upson_lounge";
       "upson_lounge"; "upson_lounge"; "56"; "57"; "58"; "keeton_dining_room";
       "keeton_dining_room"; "keeton_dining_room"; "keeton_dining_room";
       "keeton_dining_room";  "keeton_dining_room";  "keeton_dining_room";
       "59"; "60"; "phillips_kitchen"; "phillips_kitchen"; "phillips_kitchen";
       "phillips_kitchen"; "phillips_kitchen"; "phillips_kitchen"; "na"; |];
    [| "upson_lounge"; "upson_lounge"; "upson_lounge"; "upson_lounge";
       "upson_lounge"; "upson_lounge"; "61"; "62"; "63"; "keeton_dining_room";
       "keeton_dining_room"; "keeton_dining_room"; "keeton_dining_room";
       "keeton_dining_room";  "keeton_dining_room";  "keeton_dining_room";
       "64"; "65"; "phillips_kitchen"; "phillips_kitchen"; "phillips_kitchen";
       "phillips_kitchen"; "phillips_kitchen"; "phillips_kitchen"; "na"; |];
    [| "upson_lounge"; "upson_lounge"; "upson_lounge"; "upson_lounge";
       "upson_lounge"; "upson_lounge"; "na"; "colonelcornell_piece"; "na";
       "keeton_dining_room"; "keeton_dining_room"; "keeton_dining_room";
       "keeton_dining_room"; "keeton_dining_room";  "keeton_dining_room";
       "keeton_dining_room";  "na"; "185"; "na"; "phillips_kitchen";
       "phillips_kitchen"; "phillips_kitchen"; "phillips_kitchen";
       "phillips_kitchen"; "na"; |];
  |]

let is_a_room room  =
  match room with
  | "duffield_atrium" | "barton_hall" | "upson_lounge" | "keeton_dining_room"
  | "olin_library" | "statler_ballroom" | "phillips_kitchen"
  | "rpcc_billard_room" | "bailey_conservatory" -> true
  | _ -> false

let ch_name_tostring ch_name =
  match ch_name with
  | MissMartha -> "Miss Martha"
  | MrScience -> "Mr. Science"
  | ProfessorEdmundEzra -> "Professor Edmund Ezra"
  | MrsGinsberg -> "Mrs. Ginsberg"
  | ColonelCornell -> "Colonel Cornell"
  | MrAndyBernard -> "Mr. Andy Bernard"

let room_name_tostring ro_name =
  match ro_name with
  | DuffAtrium -> "Duffield Atrium"
  | OlinLibrary -> "Olin Library"
  | RPCCBillardRoom -> "RPCC Billiard Room"
  | BaileyConservatory -> "Bailey Conservatory"
  | StatlerBallroom -> "Statler Ballroom"
  | PhillipsKitchen -> "Phillips Kitchen"
  | KeetonDiningRoom -> "Keeton Dining Room"
  | UpsonLounge -> "Upson Lounge"
  | BartonHall -> "Barton Hall"

let weapon_name_tostring we_name =
  match we_name with
  | DairyBarJug -> "Dairy Bar Jug"
  | FuertesTelescope -> "Fuertes Telescope"
  | Revolver -> "Revolver"
  | ArchitectureKnife -> "Architecture Knife"
  | RisleyCandleStick -> "Risley Candle Stick"
  | Rope -> "Rope"

let is_a_passage p =
  match p with
  | "duffield_atrium" -> true
  | "bailey_conservatory" -> true
  | "phillips_kitchen" -> true
  | "upson_lounge" -> true
  | _ -> false

let get_passage (ro : string) : (int*int) =
  match ro with
  | "duffield_atrium" -> List.hd phillips_kitchen_tiles
  | "bailey_conservatory" -> List.hd upson_lounge_tiles
  | "phillips_kitchen" -> (List.hd duffield_atrium_tiles)
  | "upson_lounge"-> List.hd bailey_conservatory_tiles
  | _ -> (-1,-1)

let rec next_player (person : character_name) (st : state) =
  match person with
  | MrScience -> if st.losers.(2) then next_player ProfessorEdmundEzra st else ProfessorEdmundEzra
  | ProfessorEdmundEzra -> if st.losers.(3) then next_player MrsGinsberg st else MrsGinsberg
  | MrsGinsberg -> if st.losers.(4) then next_player ColonelCornell st else ColonelCornell
  | ColonelCornell ->  if st.losers.(0) then next_player MissMartha st else MissMartha
  | MissMartha -> if st.losers.(5) then next_player MrAndyBernard st else MrAndyBernard
  | MrAndyBernard -> if st.losers.(1) then next_player MrScience st else MrScience

let get_playerai cname st =
  if st.ai1.name = cname then Some st.ai1
  else if st.ai2.name = cname then Some st.ai2
  else if st.ai3.name = cname then Some st.ai3
  else if st.ai4.name = cname then Some st.ai4
  else if st.ai5.name = cname then Some st.ai5
  else None

let unwrap_ai (ai : ai_player option) =
  match ai with
  | Some (x) -> x
  | _ -> failwith "Not an ai"

let all_characters = [|
  "missmartha"; "msscience"; "professoredmundezra"; "mrsginsberg";
  "colonelcornell";  "mrandybernard"
|]

let all_rooms = [|
  "duffield_atrium"; "olin_library"; "rpcc_billard_room"; "bailey_conservatory";
  "statler_ballroom"; "phillips_kitchen"; "keeton_dining_room"; "upson_lounge";
  "barton_hall";
|]

let suspect_guess = [|
  "missmartha_guess"; "msscience_guess"; "professoredmundezra_guess";
  "mrsginsberg_guess";  "colonelcornell_guess"; "mrandybernard_guess";
|]

let room_guess = [|
  "duffieldatrium_guess"; "olinlibrary_guess"; "rpccbillardroomroom_guess";
  "baileyconservatory_guess"; "statlerballroom_guess"; "phillipskitchen_guess";
  "keetondiningroom_guess"; "upsonlounge_guess"; "bartonhall_guess";
|]

let weapon_guess = [|
  "dairybarjug_guess"; "fuertestelescope_guess"; "revolver_guess";
  "architectureknife_guess"; "risleycandlestick_guess";  "rope_guess"
|]

let get_diff i =
  match i with
  | 0 -> Easy
  | 1 -> Medium
  | 2 -> Hard
  | _ -> Medium

let difficulties = [|"difficulty1"; "difficulty2"; "difficulty3"|]

let all_rooms = [|"duffield_atrium"; "olin_library"; "rpcc_billard_room";
                  "bailey_conservatory"; "barton_hall"; "statler_ballroom";
                  "upson_lounge"; "keeton_dining_room"; "phillips_kitchen"|]

let get_gui_suspect_card c =
  match c with
  | MissMartha -> "static/missmartha_card.png"
  | MrScience -> "static/msscience_card.png"
  | ProfessorEdmundEzra -> "static/professoredmundezra_card.png"
  | MrsGinsberg -> "static/mrsginsberg_card.png"
  | ColonelCornell -> "static/colonelcornell_card.png"
  | MrAndyBernard -> "static/mrandybernard_card.png"

let get_gui_room_card c =
  match c with
  | DuffAtrium -> "static/duffieldatrium_card.png"
  | OlinLibrary -> "static/olinlibrary_card.png"
  | RPCCBillardRoom -> "static/rpccbillardroom_card.png"
  | BaileyConservatory -> "static/baileyconservatory_card.png"
  | StatlerBallroom -> "static/statlerballroom_card.png"
  | PhillipsKitchen -> "static/phillipskitchen_card.png"
  | KeetonDiningRoom -> "static/keetondiningroom_card.png"
  | UpsonLounge -> "static/upsonlounge_card.png"
  | BartonHall -> "static/bartonhall_card.png"

let get_gui_weapon_card c =
  match c with
  | DairyBarJug -> "static/dairybarjug_card.png"
  | FuertesTelescope -> "static/fuertestelescope_card.png"
  | Revolver -> "static/revolver_card.png"
  | ArchitectureKnife -> "static/architectureknife_card.png"
  | RisleyCandleStick -> "static/risleycandlestick_card.png"
  | Rope -> "static/rope_card.png"

let get_xy_of_id to_find =
  let x_loc = ref (-1) in
  let y_loc = ref (-1) in
  Array.iteri (fun i x -> (Array.iteri (fun j y ->
      if (map_coordinates.(i).(j)=to_find)
      then (x_loc:= i; y_loc:=j)
      else ()) x)) map_coordinates;
  (!x_loc, !y_loc)

let get_coordinates_of_room to_find =
  let arr = ref [] in
  Array.iteri (fun i x -> (Array.iteri (fun j y ->
      if (map_coordinates.(i).(j)=to_find)
      then arr := (!arr)@[(i, j)]
      else ()) x)) map_coordinates;
  !arr

let filter_locations lst st=
  let filter_rooms = (List.filter
                        (fun x -> if (not (List.mem x all_room_tiles)) then true
                          else if ((List.mem x all_room_tiles) &&
                                   (List.mem x all_entrance_tiles)) then true
                          else false) lst) in
  let filter_bounds = (List.filter
                         (fun (x,y) -> if ((x<0) || (y<0) || (x>23) || (y>24))
                           then false else true) filter_rooms) in
  let filter_na = (List.filter
                     (fun (x,y) -> if (map_coordinates.(x).(y) = "na")
                       then false else true) filter_bounds) in
  let filter_current_loc = (List.filter
                              (fun (x,y) -> if (Array.mem (x,y) st.locations )
                                then false else true) filter_na ) in
  (* let filter_other_characters = (List.filter) *)
  filter_current_loc

let update_gui_valid_locations num loc st =
  match num, loc with
  | 1, (x,y) -> filter_locations [(x+1,y); (x-1,y); (x,y+1); (x,y-1)] st
  | 2, (x,y) -> filter_locations [(x+1,y); (x+2,y); (x-1,y); (x-2,y);
                                  (x-1,y-1); (x,y-1); (x+1,y-1); (x,y-2);
                                  (x,y+2); (x-1,y+1); (x,y+1); (x+1,y+1)] st
  | 3, (x,y)-> filter_locations [(x+1,y); (x+2,y); (x-1,y); (x-2,y);
                                 (x-1,y-1); (x,y-1); (x+1,y-1); (x,y-2);
                                 (x,y+2); (x-1,y+1); (x,y+1); (x+1,y+1);
                                 (x-3,y); (x-2,y-1); (x-2,y+1); (x-1,y-2);
                                 (x-1,y+2); (x,y-3); (x,y+3); (x+1,y-2);
                                 (x+1,y+2); (x+2,y-1); (x+2,y+1); (x+3,y)] st
  | 4, (x,y)-> filter_locations [(x+1,y); (x+2,y); (x-1,y); (x-2,y);
                                 (x-1,y-1); (x,y-1); (x+1,y-1); (x,y-2);
                                 (x,y+2); (x-1,y+1); (x,y+1); (x+1,y+1);
                                 (x-3,y); (x-2,y-1); (x-2,y+1); (x-1,y-2);
                                 (x-1,y+2); (x,y-3); (x,y+3); (x+1,y-2);
                                 (x+1,y+2); (x+2,y-1); (x+2,y+1); (x+3,y);
                                 (x-4,y); (x-3,y-1); (x-3,y+1); (x-2,y-2);
                                 (x-2,y+2); (x-1,y-3); (x-1,y+3); (x,y-4);
                                 (x,y+4); (x+1,y-3); (x+1,y+3); (x+2,y-2);
                                 (x+2,y-2); (x+3,y-1);(x+3,y+1); (x+4,y)] st
  | 5, (x,y) -> filter_locations [(x+1,y); (x+2,y); (x-1,y); (x-2,y);
                                  (x-1,y-1); (x,y-1); (x+1,y-1); (x,y-2);
                                  (x,y+2); (x-1,y+1); (x,y+1); (x+1,y+1);
                                  (x-3,y); (x-2,y-1); (x-2,y+1); (x-1,y-2);
                                  (x-1,y+2); (x,y-3); (x,y+3); (x+1,y-2);
                                  (x+1,y+2); (x+2,y-1); (x+2,y+1); (x+3,y);
                                  (x-4,y); (x-3,y-1); (x-3,y+1); (x-2,y-2);
                                  (x-2,y+2); (x-1,y-3); (x-1,y+3); (x,y-4);
                                  (x,y+4); (x+1,y-3); (x+1,y+3); (x+2,y-2);
                                  (x+2,y-2); (x+3,y-1);(x+3,y+1); (x+4,y);
                                  (x-5,y); (x-4,y-1); (x-4,y+1); (x-3,y-2);
                                  (x-3,y+2); (x-2,y-3); (x-2,y+3); (x-1,y-4);
                                  (x-1,y+4); (x,y-5); (x,y+5); (x+1,y-4);
                                  (x+1,y+4); (x+2,y-3); (x+2,y+3); (x+3,y-2);
                                  (x+3,y+2); (x+4,y-1); (x+4,y+1); (x+5,y)] st
  | 6, (x,y) -> filter_locations [(x+1,y); (x+2,y); (x-1,y); (x-2,y);
                                  (x-1,y-1); (x,y-1); (x+1,y-1); (x,y-2);
                                  (x,y+2); (x-1,y+1); (x,y+1); (x+1,y+1);
                                  (x-3,y); (x-2,y-1); (x-2,y+1); (x-1,y-2);
                                  (x-1,y+2); (x,y-3); (x,y+3); (x+1,y-2);
                                  (x+1,y+2); (x+2,y-1); (x+2,y+1); (x+3,y);
                                  (x-4,y); (x-3,y-1); (x-3,y+1); (x-2,y-2);
                                  (x-2,y+2); (x-1,y-3); (x-1,y+3); (x,y-4);
                                  (x,y+4); (x+1,y-3); (x+1,y+3); (x+2,y-2);
                                  (x+2,y-2); (x+3,y-1);(x+3,y+1); (x+4,y);
                                  (x-5,y); (x-4,y-1); (x-4,y+1); (x-3,y-2);
                                  (x-3,y+2); (x-2,y-3); (x-2,y+3); (x-1,y-4);
                                  (x-1,y+4); (x,y-5); (x,y+5); (x+1,y-4);
                                  (x+1,y+4); (x+2,y-3); (x+2,y+3); (x+3,y-2);
                                  (x+3,y+2); (x+4,y-1); (x+4,y+1); (x+5,y);
                                  (x-6,y); (x-5,y-1); (x-5,y+1); (x-4,y-2);
                                  (x-4,y+2); (x-3,y-3); (x-3,y+3); (x-2,y-4);
                                  (x-2,y+4); (x-1,y-5); (x-1,y+5); (x,y-6);
                                  (x,y+6); (x+1,y-5); (x+1,y+5); (x+2,y-4);
                                  (x+2,y+4); (x+3,y-3); (x+3,y+3); (x+4,y-2);
                                  (x+4,y+2); (x+5,y-1); (x+5,y+1); (x+6,y)] st
  | _, _ -> [loc] (* this should never happen *)

let in_a_room ch_name st =
  List.mem st.locations.(index ch_name) all_room_tiles

let get_room loc =
  let value = map_coordinates.(fst loc).(snd loc) in
  match value with
  | "duffield_atrium" -> index_to_room 0
  | "olin_library" -> index_to_room 1
  | "rpcc_billard_room" -> index_to_room 2
  | "bailey_conservatory" -> index_to_room 3
  | "statler_ballroom" -> index_to_room 4
  | "phillips_kitchen" -> index_to_room 5
  | "keeton_dining_room" -> index_to_room 6
  | "upson_lounge" -> index_to_room 7
  | "barton_hall" -> index_to_room 8
  | _ -> failwith "bad coordinate"

let act_tostring ac =
  match ac with
  | Roll -> "roll"
  | Passage -> "passage"
  | Move x -> "move"
  | Suggestion (x,y,z)-> "sugg"
  | Accusation (x,y,z) -> "acccu"
  | Share (x,y,z)-> "share"
