open OUnit2
open Enemy_ai
open Player
open Controller
open Types

let sus1 = {
  characters =  [(MissMartha, 100.0/.6.0); (MrScience, 100.0/.6.0);
                 (ProfessorEdmundEzra, 100.0/.6.0); (MrsGinsberg, 100.0/.6.0);
                 (ColonelCornell, 100.0/.6.0); (MrAndyBernard, 100.0/.6.0)];
  weapons =     [(DairyBarJug, 100.0/.6.0); (FuertesTelescope, 100.0/.6.0);
                 (Revolver, 100.0/.6.0); (ArchitectureKnife, 100.0/.6.0);
                 (RisleyCandleStick, 100.0/.6.0); (Rope, 100.0/.6.0)];
  rooms =       [(DuffAtrium, 100.0/.9.0); (OlinLibrary, 100.0/.9.0);
                 (RPCCBillardRoom, 100.0/.9.0); (BaileyConservatory, 100.0/.9.0);
                 (StatlerBallroom, 100.0/.9.0); (PhillipsKitchen, 100.0/.9.0);
                 (KeetonDiningRoom,100.0/.9.0); (UpsonLounge, 100.0/.9.0);
                 (BartonHall, 100.0/.9.0)]
}

let sus2 = {
  characters =  [(MrScience, 100.0/.5.0); (ProfessorEdmundEzra, 100.0/.5.0);
                 (MrsGinsberg, 100.0/.5.0); (ColonelCornell, 100.0/.5.0);
                 (MrAndyBernard, 100.0/.5.0)];
  weapons =     [(DairyBarJug, 100.0/.6.0); (FuertesTelescope, 100.0/.6.0 );
                 (Revolver, 100.0/.6.0); (ArchitectureKnife, 100.0/.6.0);
                 (RisleyCandleStick, 100.0/.6.0); (Rope, 100.0/.6.0)];
  rooms =       [(DuffAtrium, 100.0/.9.0); (OlinLibrary, 100.0/.9.0);
                 (RPCCBillardRoom, 100.0/.9.0); (BaileyConservatory, 100.0/.9.0);
                 (StatlerBallroom, 100.0/.9.0); (PhillipsKitchen, 100.0/.9.0);
                 (KeetonDiningRoom, 100.0/.9.0);(UpsonLounge, 100.0/.9.0);
                 (BartonHall, 100.0/.9.0)]
}

let sus3 = {
  characters = [(ProfessorEdmundEzra, 100.0/.4.0); (MrsGinsberg, 100.0/.4.0);
                (ColonelCornell, 100.0/.4.0); (MrAndyBernard, 100.0/.4.0)];
  weapons =    [(DairyBarJug, 100.0/.6.0); (FuertesTelescope, 100.0/.6.0);
                (Revolver, 100.0/.6.0); (ArchitectureKnife, 100.0/.6.0);
                (RisleyCandleStick, 100.0/.6.0); (Rope, 100.0/.6.0)];
  rooms =      [(DuffAtrium, 100.0/.9.0); (OlinLibrary, 100.0/.9.0);
                (RPCCBillardRoom, 100.0/.9.0); (BaileyConservatory, 100.0/.9.0);
                (StatlerBallroom, 100.0/.9.0); (PhillipsKitchen, 100.0/.9.0);
                (KeetonDiningRoom, 100.0/.9.0); (UpsonLounge, 100.0/.9.0);
                (BartonHall, 100.0/.9.0)]
}

let sus4 = {
  characters = [(ProfessorEdmundEzra, 100.0/.4.0); (MrsGinsberg, 100.0/.4.0);
                (ColonelCornell, 100.0/.4.0); (MrAndyBernard, 100.0/.4.0)];
  weapons =    [(FuertesTelescope, 100.0/.5.0); (Revolver, 100.0/.5.0);
                (ArchitectureKnife, 100.0/.5.0); (RisleyCandleStick, 100.0/.5.0);
                (Rope, 100.0/.5.0)];
  rooms =      [(DuffAtrium, 100.0/.9.0); (OlinLibrary, 100.0/.9.0);
                (RPCCBillardRoom, 100.0/.9.0); (BaileyConservatory, 100.0/.9.0);
                (StatlerBallroom, 100.0/.9.0); (PhillipsKitchen, 100.0/.9.0);
                (KeetonDiningRoom, 100.0/.9.0); (UpsonLounge, 100.0/.9.0);
                (BartonHall, 100.0/.9.0)]
}

let sus5 = {
  characters = [(ProfessorEdmundEzra, 100.0/.4.0); (MrsGinsberg, 100.0/.4.0);
                (ColonelCornell, 100.0/.4.0); (MrAndyBernard, 100.0/.4.0)];
  weapons =    [(FuertesTelescope, 100.0/.5.0); (Revolver, 100.0/.5.0);
                (ArchitectureKnife, 100.0/.5.0); (RisleyCandleStick, 100.0/.5.0);
                (Rope, 100.0/.5.0)];
  rooms =      [(DuffAtrium ,100.0/.8.0); (OlinLibrary, 100.0/.8.0);
                (RPCCBillardRoom,100.0/.8.0); (BaileyConservatory, 100.0/.8.0);
                (PhillipsKitchen, 100.0/.8.0); (KeetonDiningRoom, 100.0/.8.0);
                (UpsonLounge, 100.0/.8.0); (BartonHall, 100.0/.8.0)]
}

let sus6 = {
  characters = [(ProfessorEdmundEzra, 100.0/.4.0); (MrsGinsberg, 100.0/.4.0);
                (ColonelCornell, 100.0/.4.0); (MrAndyBernard, 100.0/.4.0)];
  weapons =    [(FuertesTelescope, 100.0/.5.0 ); (Revolver, 100.0/.5.0);
                (ArchitectureKnife, 100.0/.5.0); (RisleyCandleStick, 100.0/.5.0);
                (Rope, 100.0/.5.0)];
  rooms =      [(DuffAtrium, 100.0/.8.0); (OlinLibrary, 100.0/.8.0);
                (RPCCBillardRoom,100.0/.8.0); (BaileyConservatory, 100.0/.8.0);
                (PhillipsKitchen, 100.0/.8.0); (KeetonDiningRoom, 100.0/.8.0);
                (UpsonLounge, 100.0/.8.0); (BartonHall, 100.0/.8.0)]
}

let sus7 = {
  characters = [(ProfessorEdmundEzra, 100.0/.4.0); (MrsGinsberg, 100.0/.4.0);
                (ColonelCornell, 100.0/.4.0); (MrAndyBernard, 100.0/.4.0)];
  weapons =    [(ArchitectureKnife, 100.0/.2.0); (RisleyCandleStick, 100.0/.2.0)];
  rooms =      [(DuffAtrium, 100.0/.8.0); (OlinLibrary, 100.0/.8.0);
                (RPCCBillardRoom, 100.0/.8.0); (BaileyConservatory, 100.0/.8.0);
                (PhillipsKitchen, 100.0/.8.0); (KeetonDiningRoom, 100.0/.8.0);
                (UpsonLounge, 100.0/.8.0); (BartonHall, 100.0/.8.0)]
}

let sus8 = {
  characters = [(ProfessorEdmundEzra, 100.0/.4.0); (MrsGinsberg, 100.0/.4.0);
                (ColonelCornell, 100.0/.4.0); (MrAndyBernard, 100.0/.4.0)];
  weapons =    [(ArchitectureKnife,100.0)];
  rooms =      [(DuffAtrium, 100.0/.8.0); (OlinLibrary, 100.0/.8.0);
                (RPCCBillardRoom, 100.0/.8.0); (BaileyConservatory, 100.0/.8.0);
                (PhillipsKitchen, 100.0/.8.0); (KeetonDiningRoom, 100.0/.8.0);
                (UpsonLounge, 100.0/.8.0);(BartonHall, 100.0/.8.0)]
}

let sus9 = {
  characters =  [(MrScience, 100.0/.5.0); (ProfessorEdmundEzra, 100.0/.5.0);
                 (MrsGinsberg, 100.0/.5.0); (ColonelCornell, 100.0/.5.0);
                 (MrAndyBernard, 100.0/.5.0)];
  weapons =     [(DairyBarJug, 100.0/.3.0);
                 (ArchitectureKnife, 100.0/.3.0);
                 (RisleyCandleStick, 100.0/.3.0); ];
  rooms =       [(DuffAtrium, 100.0/.9.0); (OlinLibrary, 100.0/.9.0);
                 (RPCCBillardRoom, 100.0/.9.0); (BaileyConservatory, 100.0/.9.0);
                 (StatlerBallroom, 100.0/.9.0); (PhillipsKitchen, 100.0/.9.0);
                 (KeetonDiningRoom, 100.0/.9.0);(UpsonLounge, 100.0/.9.0);
                 (BartonHall, 100.0/.9.0)]
}

let sus10 = {
  characters = [(ProfessorEdmundEzra, 100.0/.4.0); (MrsGinsberg, 100.0/.4.0);
                (ColonelCornell, 100.0/.4.0); (MrAndyBernard, 100.0/.4.0)];
  weapons =    [(FuertesTelescope, 100.0/.4.0 ); (Revolver, 100.0/.4.0);
                (ArchitectureKnife, 100.0/.4.0);
                (Rope, 100.0/.4.0)];
  rooms =      [(DuffAtrium, 100.0/.8.0); (OlinLibrary, 100.0/.8.0);
                (RPCCBillardRoom,100.0/.8.0); (BaileyConservatory, 100.0/.8.0);
                (PhillipsKitchen, 100.0/.8.0); (KeetonDiningRoom, 100.0/.8.0);
                (UpsonLounge, 100.0/.8.0); (BartonHall, 100.0/.8.0)]
}

let st1 = init_state MissMartha Easy

let st_losers = {
  st1 with losers = [|true; false; false; false; false; false|]
}

let suspect_list1 = {
  characters = [(ProfessorEdmundEzra, 33.3333333333333357);
                (MrsGinsberg, 33.3333333333333357);
                (ColonelCornell, 33.3333333333333357)];
  weapons =    [(Revolver, 100.)];
  rooms =      [(OlinLibrary, 50.); (KeetonDiningRoom, 50.)]
}

let suspect_list2 = {
  characters = [(ProfessorEdmundEzra, 33.3333333333333357);
                (MrsGinsberg, 33.3333333333333357);
                (ColonelCornell, 33.3333333333333357)];
  weapons =    [(Revolver, 100.)];
  rooms =      [(OlinLibrary, 50.); (KeetonDiningRoom, 50.)]
}

let ai0 = {
    name = MrAndyBernard;
    difficulty = Easy;
    cards = [Room RPCCBillardRoom; Weapon DairyBarJug; Room PhillipsKitchen];
    suspect_list = suspect_list1;
    visited_locations = [];
  }
let ai1 = {
  name = MrScience;
  difficulty = Easy;
  cards = [Room BaileyConservatory; Room UpsonLounge; Character MissMartha];
  suspect_list = suspect_list1;
  visited_locations = [];
  }
let ai2 = {
  name = ProfessorEdmundEzra;
  difficulty = Easy;
  cards = [Room StatlerBallroom; Weapon ArchitectureKnife; Room DuffAtrium];
  suspect_list = suspect_list1;
  visited_locations = [];
  }

let st2 = {
  pl1 = {
    name = MissMartha;
    cards = [Character ColonelCornell; Character ProfessorEdmundEzra; Room OlinLibrary]
  };
  ai1 = ai0;
  ai2 = ai1;
  ai3 = ai2;
  ai4 ={
    name = MrsGinsberg;
    difficulty = Easy;
    cards = [Character MrAndyBernard; Room BartonHall; Weapon RisleyCandleStick];
    suspect_list = suspect_list1;
    visited_locations = [];
  };
  ai5 = {
    name = ColonelCornell;
    difficulty = Easy;
    cards = [Weapon Rope; Character MrScience; Weapon FuertesTelescope];
    suspect_list = suspect_list1;
    visited_locations = [];
  };
  current_roll = -1;
  current_action = (MissMartha, Roll);
  locations = [|(1, 6); (17, 1); (24, 8); (15, 25); (10, 25); (1, 19)|];
  win_combination ={
    character = Character MrsGinsberg;
    room = Room KeetonDiningRoom;
    weapon = Weapon Revolver
  };
  shared_info = None;
  losers = [|false; false; false; false; false; false|];
  winner = -1;
  output_text = (MissMartha, "Welcome to Clue!");
  card_to_show = None; invalid_move = 0;
  weapon_locations = [|(-1, -1); (-1, -1); (-1, -1); (-1, -1); (-1, -1); (-1, -1)|]
  }
let st3 = (player_roll MissMartha 5 st2)
let st4 = (update_state MissMartha (Move(5,0)) st3 )
let st5 = (Enemy_ai.move (unwrap_ai (get_playerai MrAndyBernard st4)) 2 st3)

let new_st0 = {st2 with shared_info = Some (Weapon(DairyBarJug))}
let new_st1 = {st2 with shared_info = Some (Room(StatlerBallroom))}

let init_reco = {
  characters =  [(MissMartha, 100.0/.6.0); (MrScience, 100.0/.6.0);
                 (ProfessorEdmundEzra, 100.0/.6.0); (MrsGinsberg, 100.0/.6.0);
                 (ColonelCornell, 100.0/.6.0); (MrAndyBernard, 100.0/.6.0)];
  weapons =     [(DairyBarJug, 100.0/.6.0); (FuertesTelescope, 100.0/.6.0);
                 (Revolver, 100.0/.6.0); (ArchitectureKnife, 100.0/.6.0);
                 (RisleyCandleStick, 100.0/.6.0); (Rope, 100.0/.6.0)];
  rooms =       [(DuffAtrium, 100.0/.9.0); (OlinLibrary, 100.0/.9.0);
                 (RPCCBillardRoom, 100.0/.9.0); (BaileyConservatory, 100.0/.9.0);
                 (StatlerBallroom, 100.0/.9.0); (PhillipsKitchen, 100.0/.9.0);
                 (KeetonDiningRoom,100.0/.9.0); (UpsonLounge, 100.0/.9.0);
                 (BartonHall, 100.0/.9.0)]
  }

let gu0 = {
  weapon = DairyBarJug;
  suspect = ProfessorEdmundEzra;
  room = KeetonDiningRoom;
  }
let gu1 = {
  weapon = DairyBarJug;
  suspect = ProfessorEdmundEzra;
  room = StatlerBallroom;
  }
let gu2 = {
  weapon = ArchitectureKnife;
  suspect = ProfessorEdmundEzra;
  room = StatlerBallroom;
  }

let loc1 = [|(6, 6); (17, 1); (24, 8); (15, 25); (10, 25); (1, 19)|]
let loc2 = [|(6, 6); (17, 1); (24, 8); (15, 25); (10, 25); (1, 17)|]

let ai0_cards = [Room RPCCBillardRoom; Weapon DairyBarJug; Room PhillipsKitchen]
let ai1_cards = [Room BaileyConservatory; Room UpsonLounge; Character MissMartha]
let ai2_cards = [Room StatlerBallroom; Weapon ArchitectureKnife; Room DuffAtrium]
let ai3_cards = [Character MrAndyBernard; Room BartonHall; Weapon RisleyCandleStick]
let ai4_cards = [Weapon Rope; Character MrScience; Weapon FuertesTelescope]
let pl1_cards = [Character ColonelCornell; Character ProfessorEdmundEzra; Room OlinLibrary]

let new_info0 = {
  characters =  [(MissMartha, 100.0/.6.0); (MrScience, 100.0/.6.0);
                 (ProfessorEdmundEzra, 100.0/.6.0); (MrsGinsberg, 100.0/.6.0);
                 (ColonelCornell, 100.0/.6.0); (MrAndyBernard, 100.0/.6.0)];
  weapons =     [(FuertesTelescope, 100.0/.5.0);
                 (Revolver, 100.0/.5.0); (ArchitectureKnife, 100.0/.5.0);
                 (RisleyCandleStick, 100.0/.5.0); (Rope, 100.0/.5.0)];
  rooms =       [(DuffAtrium, 100.0/.7.0); (OlinLibrary, 100.0/.7.0);
                 (BaileyConservatory, 100.0/.7.0); (StatlerBallroom, 100.0/.7.0);
                 (KeetonDiningRoom,100.0/.7.0); (UpsonLounge, 100.0/.7.0);
                 (BartonHall, 100.0/.7.0)]
  }

let new_info1 = {
  characters =  [(MrScience, 100.0/.5.0);
                 (ProfessorEdmundEzra, 100.0/.5.0); (MrsGinsberg, 100.0/.5.0);
                 (ColonelCornell, 100.0/.5.0); (MrAndyBernard, 100.0/.5.0)];
  weapons =     [(DairyBarJug, 100.0/.6.0); (FuertesTelescope, 100.0/.6.0);
                 (Revolver, 100.0/.6.0); (ArchitectureKnife, 100.0/.6.0);
                 (RisleyCandleStick, 100.0/.6.0); (Rope, 100.0/.6.0)];
  rooms =       [(DuffAtrium, 100.0/.7.0); (OlinLibrary, 100.0/.7.0);
                 (RPCCBillardRoom, 100.0/.7.0);
                 (StatlerBallroom, 100.0/.7.0); (PhillipsKitchen, 100.0/.7.0);
                 (KeetonDiningRoom,100.0/.7.0); (BartonHall, 100.0/.7.0)]
  }

let new_info2 = {
  characters =  [(MissMartha, 100.0/.6.0); (MrScience, 100.0/.6.0);
                 (ProfessorEdmundEzra, 100.0/.6.0); (MrsGinsberg, 100.0/.6.0);
                 (ColonelCornell, 100.0/.6.0); (MrAndyBernard, 100.0/.6.0)];
  weapons =     [(DairyBarJug, 100.0/.5.0); (FuertesTelescope, 100.0/.5.0);
                 (Revolver, 100.0/.5.0);
                 (RisleyCandleStick, 100.0/.5.0); (Rope, 100.0/.5.0)];
  rooms =       [(OlinLibrary, 100.0/.7.0);
                 (RPCCBillardRoom, 100.0/.7.0); (BaileyConservatory, 100.0/.7.0);
                 (PhillipsKitchen, 100.0/.7.0);
                 (KeetonDiningRoom,100.0/.7.0); (UpsonLounge, 100.0/.7.0);
                 (BartonHall, 100.0/.7.0)]
  }

let new_info3 = {
  characters =  [(MissMartha, 100.0/.5.0); (MrScience, 100.0/.5.0);
                 (ProfessorEdmundEzra, 100.0/.5.0); (MrsGinsberg, 100.0/.5.0);
                 (ColonelCornell, 100.0/.5.0); ];
  weapons =     [(DairyBarJug, 100.0/.5.0); (FuertesTelescope, 100.0/.5.0);
                 (Revolver, 100.0/.5.0); (ArchitectureKnife, 100.0/.5.0);
                 (Rope, 100.0/.5.0)];
  rooms =       [(DuffAtrium, 100.0/.8.0); (OlinLibrary, 100.0/.8.0);
                 (RPCCBillardRoom, 100.0/.8.0); (BaileyConservatory, 100.0/.8.0);
                 (StatlerBallroom, 100.0/.8.0); (PhillipsKitchen, 100.0/.8.0);
                 (KeetonDiningRoom,100.0/.8.0); (UpsonLounge, 100.0/.8.0);]
  }

let new_info4 = {
  characters =  [(MissMartha, 100.0/.5.0);
                 (ProfessorEdmundEzra, 100.0/.5.0); (MrsGinsberg, 100.0/.5.0);
                 (ColonelCornell, 100.0/.5.0); (MrAndyBernard, 100.0/.5.0)];
  weapons =     [(DairyBarJug, 100.0/.4.0);
                 (Revolver, 100.0/.4.0); (ArchitectureKnife, 100.0/.4.0);
                 (RisleyCandleStick, 100.0/.4.0);];
  rooms =       [(DuffAtrium, 100.0/.9.0); (OlinLibrary, 100.0/.9.0);
                 (RPCCBillardRoom, 100.0/.9.0); (BaileyConservatory, 100.0/.9.0);
                 (StatlerBallroom, 100.0/.9.0); (PhillipsKitchen, 100.0/.9.0);
                 (KeetonDiningRoom,100.0/.9.0); (UpsonLounge, 100.0/.9.0);
                 (BartonHall, 100.0/.9.0)]
}

let types_tests = [
  "index0" >:: (fun _ -> assert_equal 1 (index MrScience));
  "index1" >:: (fun _ -> assert_equal 2 (index ProfessorEdmundEzra));
  "index2" >:: (fun _ -> assert_equal 3 (index MrsGinsberg));
  "index3" >:: (fun _ -> assert_equal 4 (index ColonelCornell));
  "index4" >:: (fun _ -> assert_equal 5 (index MrAndyBernard));
  "index5" >:: (fun _ -> assert_equal 0 (index MissMartha));

  "index_ch0" >:: (fun _ -> assert_equal MissMartha (index_to_ch 0));
  "index_ch1" >:: (fun _ -> assert_equal MrScience (index_to_ch 1));
  "index_ch2" >:: (fun _ -> assert_equal MrsGinsberg (index_to_ch 3));
  "index_ch3" >:: (fun _ -> assert_equal ColonelCornell (index_to_ch 4));
  "index_ch4" >:: (fun _ -> assert_equal MrAndyBernard (index_to_ch 5));
  "index_ch5" >:: (fun _ -> assert_equal ProfessorEdmundEzra (index_to_ch 2));

  "index_room0" >:: (fun _ -> assert_equal DuffAtrium (index_to_room 0));
  "index_room1" >:: (fun _ -> assert_equal OlinLibrary (index_to_room 1));
  "index_room2" >:: (fun _ -> assert_equal RPCCBillardRoom (index_to_room 2));
  "index_room3" >:: (fun _ -> assert_equal BaileyConservatory (index_to_room 3));
  "index_room4" >:: (fun _ -> assert_equal StatlerBallroom (index_to_room 4));
  "index_room5" >:: (fun _ -> assert_equal PhillipsKitchen (index_to_room 5));
  "index_room6" >:: (fun _ -> assert_equal KeetonDiningRoom (index_to_room 6));
  "index_room7" >:: (fun _ -> assert_equal UpsonLounge (index_to_room 7));
  "index_room8" >:: (fun _ -> assert_equal BartonHall (index_to_room 8));

  "index_weapon0" >:: (fun _ -> assert_equal DairyBarJug (index_to_weapon 0));
  "index_weapon1" >:: (fun _ -> assert_equal FuertesTelescope (index_to_weapon 1));
  "index_weapon2" >:: (fun _ -> assert_equal Revolver (index_to_weapon 2));
  "index_weapon3" >:: (fun _ -> assert_equal ArchitectureKnife (index_to_weapon 3));
  "index_weapon4" >:: (fun _ -> assert_equal RisleyCandleStick (index_to_weapon 4));
  "index_weapon5" >:: (fun _ -> assert_equal Rope (index_to_weapon 5));

  "start_loc0" >:: (fun _ -> assert_equal (23,7) (start_location ColonelCornell));
  "start_loc1" >:: (fun _ -> assert_equal (16,0) (start_location MissMartha));
  "start_loc2" >:: (fun _ -> assert_equal (9,24) (start_location MrAndyBernard));
  "start_loc3" >:: (fun _ -> assert_equal (0,18) (start_location MrScience));
  "start_loc4" >:: (fun _ -> assert_equal (0,5) (start_location ProfessorEdmundEzra));
  "start_loc5" >:: (fun _ -> assert_equal (14,24) (start_location MrsGinsberg));

  "room_test0" >:: (fun _ -> assert_equal true (is_a_room "rpcc_billard_room"));
  "room_test1" >:: (fun _ -> assert_equal false (is_a_room "rppc_billard_room"));

  "char_string0"  >:: (fun _ -> assert_equal "Miss Martha" (ch_name_tostring MissMartha));
  "char_string1"  >:: (fun _ -> assert_equal "Mr. Science" (ch_name_tostring MrScience));
  "char_string2"  >:: (fun _ -> assert_equal "Professor Edmund Ezra" (ch_name_tostring ProfessorEdmundEzra));
  "char_string3"  >:: (fun _ -> assert_equal "Mrs. Ginsberg" (ch_name_tostring MrsGinsberg));
  "char_string4"  >:: (fun _ -> assert_equal "Colonel Cornell" (ch_name_tostring ColonelCornell));
  "char_string5"  >:: (fun _ -> assert_equal "Mr. Andy Bernard" (ch_name_tostring MrAndyBernard));

  "char_string0"  >:: (fun _ -> assert_equal "Duffield Atrium" (room_name_tostring DuffAtrium));
  "char_string1"  >:: (fun _ -> assert_equal "Olin Library" (room_name_tostring OlinLibrary));
  "char_string2"  >:: (fun _ -> assert_equal "RPCC Billiard Room" (room_name_tostring RPCCBillardRoom));
  "char_string3"  >:: (fun _ -> assert_equal "Bailey Conservatory" (room_name_tostring BaileyConservatory));
  "char_string4"  >:: (fun _ -> assert_equal "Statler Ballroom" (room_name_tostring StatlerBallroom));
  "char_string5"  >:: (fun _ -> assert_equal "Phillips Kitchen" (room_name_tostring PhillipsKitchen));
  "char_string6"  >:: (fun _ -> assert_equal "Keeton Dining Room" (room_name_tostring KeetonDiningRoom));
  "char_string7"  >:: (fun _ -> assert_equal "Upson Lounge" (room_name_tostring UpsonLounge));
  "char_string8"  >:: (fun _ -> assert_equal "Barton Hall" (room_name_tostring BartonHall));

  "next_player0" >:: (fun _ -> assert_equal ProfessorEdmundEzra (next_player MrScience st1));
  "next_player1" >:: (fun _ -> assert_equal MrsGinsberg (next_player ProfessorEdmundEzra st1));
  "next_player2" >:: (fun _ -> assert_equal ColonelCornell (next_player MrsGinsberg st1));
  "next_player3" >:: (fun _ -> assert_equal MissMartha (next_player ColonelCornell st1));
  "next_player4" >:: (fun _ -> assert_equal MrAndyBernard (next_player MissMartha st1));
  "next_player5" >:: (fun _ -> assert_equal MrScience (next_player MrAndyBernard st1));
  "next_player6" >:: (fun _ -> assert_equal MrAndyBernard (next_player ColonelCornell st_losers));
  "next_player6" >:: (fun _ -> assert_equal MrScience (next_player MrAndyBernard st_losers));

  "get_player0"  >:: (fun _ -> assert_equal None (get_playerai MissMartha st1));
  "get_player1"  >:: (fun _ -> assert_equal (Some(ai0)) (get_playerai MrAndyBernard st2));
  "get_player2"  >:: (fun _ -> assert_equal (Some(ai1)) (get_playerai MrScience st2));
  "get_player3"  >:: (fun _ -> assert_equal (Some(ai2)) (get_playerai ProfessorEdmundEzra st2));


  "filter_loc0" >:: (fun _ -> assert_equal [] (filter_locations [(0,0)] st1));

  "update_gui0" >:: (fun _ -> assert_equal [(0,0)] (update_gui_valid_locations 7 (0,0) st1));
  "update_gui0" >:: (fun _ -> assert_equal [] (update_gui_valid_locations 1 (0,0) st1));
  "player_is_user" >:: (fun _ -> assert_equal true (player_is_user MissMartha st2) );
]

let controller_tests = [
  "next_player_init0" >:: (fun _ -> assert_equal ProfessorEdmundEzra (next_player_init MrScience));
  "next_player_init1" >:: (fun _ -> assert_equal MrsGinsberg (next_player_init ProfessorEdmundEzra));
  "next_player_init2" >:: (fun _ -> assert_equal ColonelCornell (next_player_init MrsGinsberg));
  "next_player_init3" >:: (fun _ -> assert_equal MissMartha (next_player_init ColonelCornell));
  "next_player_init4" >:: (fun _ -> assert_equal MrAndyBernard (next_player_init MissMartha));
  "next_player_init5" >:: (fun _ -> assert_equal MrScience (next_player_init MrAndyBernard));

  "apply_func0" >:: (fun _ -> assert_equal 1 (apply_function 0 (~-) 1));
  "apply_func1" >:: (fun _ -> assert_equal (-1) (apply_function 1 (~-) 1));
  "apply_func2" >:: (fun _ -> assert_equal 1 (apply_function 4 (~-) 1));

  "player_user0" >:: (fun _ -> assert_equal true (player_is_user MissMartha st1));
  "player_user1" >:: (fun _ -> assert_equal false (player_is_user MrAndyBernard st1));
]

let enemy_tests = [
  "init_sus0" >:: (fun _ -> assert_equal new_info0 (init_suspect_list ai0_cards init_reco));
  "init_sus1" >:: (fun _ -> assert_equal new_info1 (init_suspect_list ai1_cards init_reco));
  "init_sus2" >:: (fun _ -> assert_equal new_info2 (init_suspect_list ai2_cards init_reco));
  "init_sus3" >:: (fun _ -> assert_equal new_info3 (init_suspect_list ai3_cards init_reco));
  "init_sus4" >:: (fun _ -> assert_equal new_info4 (init_suspect_list ai4_cards init_reco));

  "sus1" >:: (fun _ -> assert_equal sus2 (prob_shift (Character(MissMartha)) sus1));
  "sus2" >:: (fun _ -> assert_equal sus3 (prob_shift (Character(MrScience)) sus2));
  "sus3" >:: (fun _ -> assert_equal sus4 (prob_shift (Weapon(DairyBarJug)) sus3));
  "sus4" >:: (fun _ -> assert_equal sus5 (prob_shift (Room(StatlerBallroom)) sus4));
  "init_suspect_list2" >:: (fun _ -> assert_equal sus7
        (init_suspect_list [Weapon(FuertesTelescope);Weapon(Revolver);Weapon(Rope)] sus5));
  "sus5" >:: (fun _ -> assert_equal sus10 (prob_shift (Weapon(RisleyCandleStick)) sus6));

  "share_info0" >:: (fun _ -> assert_equal new_st0 (enemy_share_information ai0 gu0 st2));
  "share_info2" >:: (fun _ -> assert_equal new_st1 (enemy_share_information ai2 gu2 st2));

]

let game_simule = [
  "first_roll" >:: (fun _ -> assert_equal 5 ((player_roll MissMartha 5 st2).current_roll));
  "character_index" >:: (fun _ -> assert_equal 0 (index MissMartha));
  "next_player" >:: (fun _ -> assert_equal MrAndyBernard (next_player MissMartha st4));
  "ai_1_cards" >:: (fun _ -> assert_equal ai0_cards ((st3.ai1.cards)));
  "ai_2_cards" >:: (fun _ -> assert_equal ai1_cards ((st3.ai2.cards)));
  "ai_3_cards" >:: (fun _ -> assert_equal ai2_cards ((st3.ai3.cards)));
  "ai_4_cards" >:: (fun _ -> assert_equal ai3_cards ((st3.ai4.cards)));
  "ai_5_cards" >:: (fun _ -> assert_equal ai4_cards ((st3.ai5.cards)));
  "pl1_cards" >:: (fun _ -> assert_equal pl1_cards ((st3.pl1.cards)));
  "ai1_suspect_list" >:: (fun _ -> assert_equal suspect_list1 ((st3.ai1.suspect_list)));
]

let suite =
  "Final Project Test Suite"
  >::: types_tests @ controller_tests @ enemy_tests @ game_simule

let _ = run_test_tt_main suite
