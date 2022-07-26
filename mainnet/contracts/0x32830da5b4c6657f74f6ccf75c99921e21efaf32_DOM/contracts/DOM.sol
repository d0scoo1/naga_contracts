
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Cloak 44
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
//                                                                                                  //
//                                                                                                  //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%##***+++++++**##%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@%#*+==---++**#####**=------=+*#%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@%*+==--===+#%%%*%##%##%%%*=----=-----+*%@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@#+==--=----*%%%%%%%*%#%%%%%%%%*---=-------==+#@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@%+=-======--=#%%%%%%%*%#%#+-::..:-+--=---=----====*%@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@#+============#%%#%%%%%%%%+:. .    .:=-=---=---==-=-=-+#@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@*=-===+========*%%#%%%%%%%%%=...     ..:=----==--==-==-==-=#@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@#==--===+=======+#%%%%%%%%%%#%=:.....  ...:-=-=-=--=---====---=%@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@+===============-##%%%%#%%%%%*#=---===:..-=----=----===-==-=-----+@@@@@@@@@@@@    //
//    @@@@@@@@@@#===========-=====-%%%%%#%%%%%%##+=++**=-.:+*+-------===--==-=-=----=%@@@@@@@@@@    //
//    @@@@@@@@@*==-=====+====-===-+%%%%%#%%%%%%%#*-++*+::.::-:---==--=----=--=-==-----#@@@@@@@@@    //
//    @@@@@@@@*-==-=====++========*%%%%%%%%%%%%%%%+...........-=-===-=-------=-=-------#@@@@@@@@    //
//    @@@@@@@*--=--=====+=-=======#%%%%%%%%%%#%%%%#... .......**====-=----=--=-=--------#@@@@@@@    //
//    @@@@@@#=--=--=======-=-=====%%%%%%%%%%%*%%%%*:. ....::.:##*====--==-=--=-==--------%@@@@@@    //
//    @@@@@@==--=-========-==-===*%%%%%%%%%#%#%%#%+:..  .=*+-=#*+==-=---==------===------=@@@@@@    //
//    @@@@@*=----====-===========#%#%%%%%%##%%%%#*-.. ..=*#*-###+==-----==------==--------#@@@@@    //
//    @@@@@-----=====-==========*%#%%%%%%##%%%%%#+-:....==+++%###=---=--==------=----------@@@@@    //
//    @@@@#--==-=====-=========*%%%%%%%%%#%%%%%%%*==-:::+==+#####=--==---=------=-----:----#@@@@    //
//    @@@@+=--=--====-====-===+%#%%%%%%%%%%%%%%%%#-:::=#########*=--------------=-----:----+@@@@    //
//    @@@@===-=--=-=======-==+%#%%%%%%%%%%%%%%#%%#-:::*%%%%%%#%##==-------=-----------:----=@@@@    //
//    @@@@==-==-==============%%%%%%%%%%%%%#%%*%%#:::-%%%%%%%%###*=--------------=-:--:-----@@@@    //
//    @@@@=====--===========-++%%%%%%%%%%%###*%%%+=::=%%%%%%####*%*=-------------=----:----=@@@@    //
//    @@@@+==-=-====-=======++*%%%%%#%%%%###%%%%#=--:+%%%%%%####*%#=------------------:----+@@@@    //
//    @@@@*======-=====+===+==#%%%##%%%%#%%%%%##%##**####%%%%######=----------:------::----*@@@@    //
//    @@@@%======-=====+===++#%%#%#%%%%#%%%%##%#**#***##*##%%%%####=-=--------:-------:----@@@@@    //
//    @@@@@+=====-=====+===+##%%%%%%%%%%%%%%#%#%###**##*+*#+%%######+=--------:-----------+@@@@@    //
//    @@@@@%====--=========#*#%%%%%%%%%%%%%*%%***#*###++*++*#%%######+=----------------:--%@@@@@    //
//    @@@@@@*===-======+===%#%%%%%%%%%%%%%**##%#+*+**++##*+**+*#####*#==-----------:-----*@@@@@@    //
//    @@@@@@@+=========+===%%%%%%#%%%%%%%%**=**###**#+-#*##+#++***##*#+------------:---:+@@@@@@@    //
//    @@@@@@@@+========+=+++%%%%%%%%%%%%**+=*#++++==*###+=#+##**#####**=---:-----------=@@@@@@@@    //
//    @@@@@@@@@+======+++++=#%%%%%%%%%%*#%%#%*=*==+=*+-**+#####++####*#=-----:-----:--+@@@@@@@@@    //
//    @@@@@@@@@@++==+=++=+=+%%%%#%%%%%%%%%%##%*++=+*=+#+++#=+##########*---:-:-------+@@@@@@@@@@    //
//    @@@@@@@@@@@#=++==+=++*%%%#%%%%%%%%%**#*#+++*+=+++=*++***########**+=---------=#@@@@@@@@@@@    //
//    @@@@@@@@@@@@@#++=++*+%@%%%%%%%%%%%+##%#*=*#+*+****++=*########*###+=+-------+@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@%*+++*#@@%@@%%%%%%%##*%#*%#%*+##+++#*###*##%####*##*#=+-----+%@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@%*++%@@@@@@@%%%%%%+###=++##*+=*#**+*++**############*--=+%@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@%*#@@@@@@@@%%*%%%%+*##***+%#+=+*#*++##*#%##########=*%@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@%%#*#%%%%%*%%%%#*=*#*=**++*+*+**########%@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%#+#%+#%%%%*=##*##*##+#+*###%%%@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%%%%%%%%%+#%**#-+*#%%#%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%%%%%+#%%#%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//                                                                                                  //
//                                                                                                  //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////


contract DOM is ERC721Creator {
    constructor() ERC721Creator("Cloak 44", "DOM") {}
}
