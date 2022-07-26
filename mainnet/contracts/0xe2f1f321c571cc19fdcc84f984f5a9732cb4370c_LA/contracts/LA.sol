
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: OMOLAYO AGBAJE
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                //
//                                                                                                                                //
//       .:-=****+**#####**#**+++****+=-=+++++=+****#########%###%%%%%%%#*#***##*%%%#%%#%######*#******%%####%%@@@@               //
//    ::.           .:-=+**+=++*####*+****++***+=---==++++*****######%%#%%%%##%%%@%#####****%@%%#*####%%%####**%##%%##*##%%@%@    //
//    .:.          .::==+*+---=*####******++==+==-=+==+++*****######%%%%%%%%%%#%%%%#####***#%%%*++*###%%%#%####@%%@%%#*%%%@%%%    //
//                 :::-+**+===++***##***+=--:-===+**+++++***#####%%%%%%%%%%%%%%%%%#++**+****##*++*####%%##%###%@@@@@%%#%%%%%%%    //
//                .:::=+****+++-=*###***=-::::=+++**++==+**###%#%%%%%%%%%%%%#%%%%#*--==++***##****#*#%%%%%##%@@@@@@@%%@@@%%%%%    //
//                .::-=+*****++-=*####**=---:-=++**+=---=*#%%%%%%%%%%@%%%%%%%%@%%%#=-=+++*####***#%#%@@@@@%#%@@@@@@@%#%@@@@@%%    //
//                ..:--=++**+*+=+**#***+------=+**+=--:-=*%%%%%%%%%@%@@%%@%%@@@@@@%*-+****######*#%@@@@@@@%%%@@@@@@%%#%%%@@%%%    //
//                ..--==+=+****+*##****+--=====++*+=---=+#%%####%%%%%@%@@@@@%%%@@@@%++#*++*##%%%%%%@@@@@@%%@%%@@@@@%%%%%%%@%%%    //
//                 .::--==+****+*##****++++++++*+++=====+#*++=+++**%#%%@%@@@@@@@@@@@*=*++++*###%%%%@@@@@@%%%%%@@@@@%%%%@@@@@%%    //
//                 .:::-=-+***++**#**#***++++****+++++===-=========++**#%@@@@@@@@@@@#+*+++*##*#%##%@@@@@@%#%%%@%%@%#%%@@@@@@@%    //
//                 ..::-=--+*+=-=++=+##**+++*++***++++============+++++*#%@@@@@@@@@@%#*++*########%@@@@@%%#%%%@%%@%#%%@@%@@@@@    //
//                 ....:-==+*+-::-=-+##**++**++***+++============++++++*%%@@@@@@@@@@%#++****++***#%@@@@%%##%%%%@@@@%#%%%%%@@@@    //
//                    .:=++***+-:=++*##*+++++==++*+++=--========+++++**#%%%@@@@@@@@@#+=+****++*++#@@@@%%#*#%%%%@@@%%%%%%%%%@@@    //
//                     :-=+****+-==+*#**++++=---=++++=-=-=======++++***##%%%@@@@@@@@++++***+**++*%@@@@%%%##%@@@%%@@%%%%%%%%@@%    //
//                     :--=+++++--=+****++++=----==++===========++++***#%%%%%@@@@@@@=+**#*++***##%@@%%%%%%%@@@@@@@@@@@%%%%%%%@    //
//    ..     ......   ..::-=+++=---=+******++-:--======-======++==++***##%%%%%@@@@@%+*###*++**#%%%%%%%%%%@@@@@@@@@@@@@@@%@%%%@    //
//    ..................::-===+=-:-=++*##***+-:---====+++++++**++++++**###%%%%@@@@@###%%*++*####%%%%%%%%%@@@@@@@@%%@@@@@@@%%%%    //
//    ::::::::::::::::::::-==--=---=++*##*+++-:-----==+%%#**#%%%%%####*####%%%%@@@@%#*##*+*#%%#*%%%%%%%%@@@@@@%@%%%%@%@@@@@@%%    //
//    ::::::::::::::::::::---::-=-=++**#*++=+=-----===+##%#*#%@@%%%%%#######%%%@@@@%***#***#%%##%%%%%%%@@@@@@@%%%%%%%%@@%%%%%%    //
//    ..:::::::::::::::::::::::-====++**+=====--:-======+**=*#%##**#########%%%##%%#**##*+*#%%%%%%%%%%@@@@@@@@%%%%%%%@@%%%%#%%    //
//    .:::::::::::::::::::::::::-----=++=----::::-======+%#-*##*#%%%#+***##%%%##%@%#**#****#%%%%%%%##%@@@@@%@@%%%%%%%@@%#####%    //
//    ::::::::::::::::::::::::::-=----==-::-:::::----===+#-=+**++**+==+**##%%%%%%%%*+**#%%%#%%%%%%##%@@@@@@@@@%#%%%%%%%%%%%##%    //
//    ::::::::::::::::::::::::::-=--:---:.:::..:-----==-==-==++====--=+*##%%%%%@%#%***#%%%%#%%%%%###%%%@@%%%%%##%%%%#%##%%%*#%    //
//    ::::::::::::::::::::::::::----:--::..::.:---------=--==++=--===+*##%%%%%#%%##*#%%%%%%%%%%#####%%%%%#*#%%%#%%#**###%@%*#%    //
//    :::::::::::::::::::::::::::---::::.....::::--=--:=----=**=--=++*###%%%%%%#####%%%%%%%%%@%##****##%%+=+%%%%%%*+*##*#%@%%%    //
//    :::::::::::::::::::::::::::::---::.....::-:::-=-:-=+*++*#=-==+**##%%%%%%@*#*#*#%%%%%%%%%@%#*+++++#%=:-*#%%%*==*#*===#@@%    //
//    ::::::::::::::::::::::::::::::-:::....::--:::-==-:+*%##%*===++*###%%%%%#*####*####%%%%*+##*+++++=+=::-==#%#-:-+++=::-%@%    //
//    ::::::::::::::::::::::::::::::::::..::::---:::--::-+++*++==++**###%%%%%**%##*##**##%%%++*+===+*+=-:::--:=++-:--=+=:::+@@    //
//    ::::::::::::::::::::-:::::::::::::.::::::-::::--::-==+++==++**###%%%%%%#*%#**##***##%%#**+=--=**+-:::--:----:-----::-*%@    //
//    ::::::::::::::::::---::::::::::::::::::::::::::-::=+=+=++++**###%%%%%%%%+%*####*+**#%%#***+=-=*#*=:::-::-:::.:----:-+*%@    //
//    :::::::::::::::::-----::::::::::::::::---:::::::::+***##***####%%%%%%%%%%%*#%##*++*#%##*##+--=+**+:::-:-:.::.:-----+##%@    //
//    :::::::::::::::::-----::::::::::::::::----::::::..-==+***#####%%%%%%%%@=+%*####**+*#######=---==*+-::--::.:..:--+**#%%%%    //
//    ::::::::::::--:::------::::::::::::::::--::::::..:+******##%%%%%%%%%%@@-:#*###**++=+####*+----=-:--::--::.:..::=##%%%%%%    //
//    -:::-:::::::--:------=--::----::::::::::::::..::::=###**##%%%%%%%%%@@@%+=***#*+==-:-+**+=-::--::::-::--:::...::=*##%%%%%    //
//    -::--:::::::-::-----==--::----:::::::.::::.....:--=+++**###%%%%%@@@@@@%+:*****+--:.:=+=-::::--...:==::-:::::::-==+*#%##%    //
//    -:::::::::-----===-==----:::::::::::...:::.....:---+==+*###%%@@@@@@@@%%*++=------..:-==-:::-=:.::-=*-:==:::---:-=+*#%###    //
//    ----::::::::::--==-----::::::::::::....:::.....:--=****##%%@@@@@@@@%%%%%#%=::::-:..::-==-::-:..:-==+=:++--:--::-=+**%#**    //
//    ----::::::::::::--:::::::::::....:......:......:--=###%%%%@@@@@@@@%%%%%*:+%::::-:::::-=+=-:::..:-==+**+-----:::-++++**=+    //
//    ===-----::::::::-::::::::::::..............:..::---=#%%###%@@@@%%%%%%%%*-#%*=:::::::--=++=:.:..::-=+*=::==--:---++===--+    //
//    ===----=-::::---:::::::--::::::.........:::::..:----==-+*#%%@@%%%%%##%%+:%%##-:::::-==+++=:.:..::--=*-:-=---==-=*+=--:-+    //
//    ===-====-:----==-::::-:-::::::::::::::::::::...:---===++*##%@%%%%##%%%%*+%%#**+=-:-==+==+=:.::-----=*+==-:-+*==+*+=--:--    //
//    +==++++=--===+++=------:::.....::::.:.........-==---==@+**#%%%%%##%%%%%#%%#******+-=++--++::-=-::::-+*#=::-**==+*=---::-    //
//    +=++*+++==++*++=------:::...................:==----===%+**##%%%#####%%%##%#***+****+==:-+*+=-=-:-::---**-:-*+=++*+=-----    //
//    =-+++=-==+++====-----:::...................-===-==-===*****#########%%%##%**++++++***+::+*+==++=-::--:=**-=+++****+==---    //
//    -----::--------------::.......       ...:=-====---====******#######%%%%#%**+++====++**=-+*==+++=-::--:-=*+++++++*#**=--=    //
//    ::::::::::::::::::::::::........      .-==========-==-******###*#%%#%##*#*++========+****+--=+=--::--:-=***==+*+*###*+==    //
//    .::::::::::::::.....................  -=======-==+===:*++**###*##%####*#*++===========+*#+-:-=---::--:-=*#+===*+**#####*    //
//    :....................................:========-======+%++++**#*###***###++=============+*#=-----:::----=*#+=++++=+*#%%##    //
//    ::::.................................----==-==-+==-===#+++++++*#**++*##+++=======++++++++*#=-:--:::-=--=+#*+*+++==*##%#*    //
//    --:::::::::::.......................---==========-====#+=++++++++++++*****+++++++++++++++++#+-:---:-=--=+#******++*###*+    //
//    -:::::::::::::::::::::..............-================-+*==++++++++++++#*****++===++++++++++*#*:--:--==-=+###**#***####*=    //
//    :::::::::::::::::::::::.............=================++*====+=+++=++##**++===++=++=++++++=++*#*=:---====+##*=+******#*+=    //
//    ::::::::::::::::::::::::...........-=++================+=======+====#+====++++=++==++++++==++*##+---=+==+*#*-=++++*+*+==    //
//    :::::::::::::::::::::::............++++++==============*+=========*#*=======+==========++===++*##+==+++++*#*====+**+++=-    //
//    :::::::::::::::::..................++*+++==============-*+=======-##+==================+++++++**##-=+***##%*==++*#*+++=-    //
//    :::::::::::::::....................*****++==============+-====:=#%*+=========+========++++++++**##*:=*#+*#*---=+*##***++    //
//    :::::::::::........................*****++++=============+=-+**#*+===================+++++++++**###-=*-:+#-::::-=++++***    //
//    ::::::::::....:::..................******++++=======++++=++*#++===============+====+++++++++++**####+-::#=:.::::---=+**+    //
//    :.....::..:::::::..................***#**++++++====++++++++++=+===============+==++++++++++*****####=:.-#-..::::===+***+    //
//    ...........::::....................**##**+++++++===+++++++++++=============++++++++++++*+******######::=#-..:..:=****##*    //
//    ..::...............................+###**++++++++=++=++++++++==============+++++++++**********######%*+**-..:..:=****#**    //
//    ::.....................:...........:###**+++++++=+==+++++++++=============++++++++*********#########%#===:.....:=*******    //
//    --:::::::::::........::::..........:###**++++++++++=+=+++++++============++++++********###############::.......:-***+***    //
//    ==++++++==+++-:....................:*##***++++++++++++++++++++===========++++*******##################-.........:**++***    //
//    ++**++++=++**+--:::::...............=##***++++++++++++++++++++===========++++****####################%=::::.....:++++***    //
//    ***+===+++++=+=--------::::.........:##%***++++++++++++***+++===========++++****#####################%+::::::::::----===    //
//    +=======++====+===---------::::::...:*##****++++++++++*****+++=======+++++++***####%%%###############%#::::::::::::::::-    //
//    =--==-===================-------::::-*###****++++++++******++++======++=++++***###%%%%%%#%##%########%%:::::::::::::::::    //
//    -------=====+=====-=======----------=*###*****++++++*******+++++===+==+++++***###%%%%%%%%%%%%#######%%%=-:::::-----:::::    //
//    -------======================-=-----+*###**************#***++++++=+++++++++**###%%%%%%%%%%%%%%######%%%%===========-----    //
//    ==--================-=======--====-=+**##**##********###****++++++++++++++***###%%%%@@%%%%%%%%%####%%%%%*+++++++++++++++    //
//    =======================+==----======+**###*#############****+++++++++++++***###%%%@@@@@%%%%%%%%%##%%%%%%#+++++++++++++++    //
//    ==========-==============---========+*###############%#******+++++++++++***###%%%%@@@@@@@%%%%%%%%%%%%%%%%=-----===+++++*    //
//    =++==-========++======-----=========+*##############%##*******++++++++****###%%%%@@@@@@@@@%%%%%%%%%%%%%%%*-:::-------==+    //
//    =+===---=========++==---==++=========*#####%%%%%%#####**********++++*****###%%%%%@@@@@@@@@@%%%%%%%%%%%%%%%=---+===--:---    //
//    -===----===++=++++=++=====+==========+######%#%%%###*******************####%%%%%@@@@@@@@@@@%%%%%%%%%%%##%%*---==+++==---    //
//    -------====+++++++=+++==========+===--######%*####**++++****###******####%%%%%%@@@@@@@@@%%%%%%%%%%%######%#=----+***+===    //
//    --------=++++++++==++========++++==---*#####%******++++++****##########%%%%%%%@@@@@@@@*#%%%%%%%%%%%######%%*+===========    //
//    ==-==---==+++++++=-=+==++====++==-----+#####%******+++*+**+**##########%%%%%%@@@@@@@@#==%%%%%%%%%%########%*+======+++++    //
//    ========+++++++=====++++=++=+====-==--+#####%*******+*********##%%%%%##%%%%@@@@@@@@@@*-=%%%%%%%%%#########%#++++++++++*+    //
//    ===+++++**++*+++++++++=-======+++=====+#%%#%%*****************##%%%%%%%%@@@@@@%@@@@@@---#%%%%%%%%#########%#=+++++++++++    //
//    =++*******++++++++*+++=-===+++++=======*%%%%%***************#####%%%%%@@@@@%%%%%%@@@%---#%%%%%%%%########%%%====++++++**    //
//    ++******++**++++++++++++====+===========#%%%%**************#######%%%%%%%%%%%%%%%@@@=---*%%%%%%###########%%++====++****    //
//    *+******++++=+++++++**+++========+=-==-=#%#%%***************#########%%%%%%%%%%%%@@@----+%%%%%%%#########%%%**+=+==+++++    //
//    ******++++++++++++*++*+++=++==++==--=--=*##%%*****************#########%%%%%%%%%%%@%--=++%%%%%%%#########%%%*+++++++++++    //
//    +*****++++=++++++++++=+++++++=====--====+###%********##**********#######%%%%%%%%%%@*-==+=#%%%%%#%#######%%%%#+++*****+*+    //
//    ++++++++++***+++*++=+=++++++==---=--=====*##%**#**####**********#######%%%%%%%%%%%@*===+++%%%%%########%%%%%#***********    //
//    *********+*+++++++=+==+++++====--======+=+###**#########********######%%%%%%%%%%%%@*=+++++%%%%%%#######%%%%%%*#*********    //
//    **#*+***+=+=++++++*++=+=========+==++++===###***#########*****##########%%%%%%%%%%@*++=++=#%%%%%%%%#%%%%%%%%%*******##**    //
//    ##*******+++*++***++**++++++==+*+===+++===+##****############*##########%%%%%%%%%%%*++++==*%%%%%%%%%%%%%%%%%%******#####    //
//    #*********+**+****+****+*+++=+++====+=====+*#******######################%%%%%%%%%%+=+++==+%%%%%%%%%%%%%%%%%%***##*#####    //
//    *#****+******++**+****+**++==+++====-=++===+*******####################%%%%%%%%%%%%++++++=+#%%%%%%%%%%%%%%%%%*****######    //
//    #####***+*******#*++*++++======+++=+=+++====-***#####################%#%%%%%%%%%%@%+=+++=+++%%%%%%%%%%%%%%%%%###*#*#*###    //
//    ##***##*##*********+**++=++++***+++=+++++====*##################%%%%%%%%%%%%%%%%%%%-===+++++#%%%%%%%%%%%%%%%%####*######    //
//    ###****#********++******+******++++++++++=---*#################%%%%%%%%%%%%%%%%%%%#=====+*++*%%%%%%%%%%%%%%%%###########    //
//    ###**##**+********+*******++++++++++++++=----*#################%%%%%%%%%%####%%%%%*++++++++++#%%%%%%%%%%%%%@%####**#%%%%    //
//    ##**#####*#******++****+++++++++*++++++===---*#################%%%%%%%%######%%%%%+++++=++**##%%%%%%%%%%%%%%%####*#####%    //
//    ############**#***#***++*++***++*+=*+==+---=-#######%%#########%%%%%%########%%%%%*==++**=++**%%%%%%%%%%%%%%%##########%    //
//    ############***********+***+++++*++==--++--==######%%%########%%%%%%%########%%%%@*==++***++*#%%%%%%%%%%%%%@@%###%###%%#    //
//    ##########***##******++=++**+****++++-=+==--=####%%%%%%######%%%%%%%%########%%%%@%++*******##%%%%%%%%%%%%%@@%##%##%%%%%    //
//    ###***###***##**#**+*+***+++++***++*=-+==-==+######%%%%####%%%%%%%%%%#######%%%%%@@%%%#***###%%%%%%%%%%%%%%@@%%%%%%%%%%%    //
//    #**##########**#************===**++=-=====+++######%%%%###%%%%%%%%%%%######%%%%%%%@@@%%%%##%%%%%%%%%%%%%%%%@@%##%%%%%%%#    //
//    ###%####**#####****###****++*++**++++=+======######%%%%##%%%%%%%%%%%%%%%%%%%%%%%%@@@@@%##%%%%%%%%%%%%%%%%%%@@%%%#%%%%%%%    //
//    %%%###***#########*###**#***#*+*+++-===++++++######%%%%###%%%%%%%%%%%%%%%%%%%%%%%@@@@%%%%%%%%%%%%%%%%%%%%%@@@#%%%%%%%%%%    //
//    %%%%###***%%###*##*###*********+++++-+*++*#***######%#####%%%%%%%%%%%%%%%%%%%%%%%@@@%%%%%%%%%#%%%%%%%%%%%%@@@#%%%%%%%@%%    //
//    %%%%##%##*#%###*#*******##****+++++++++++*****##%%%%%#%###%%%%%%%%%%%%%%%%%%%%%%%@@@@@%%%%%%%%%%%%%%%%%%%%@@@%%%##%%%%%%    //
//    %%%####*#*#####*##*#*####***+*+*##*=+*+****++###%%%%%%%###%%%%%%%%%###%%%%%%%%%%@@@@@@@%%%%%%%%%%%%%%%%%%%@@@%#%%#%%@%%%    //
//    %%%%%%%%%###%#######**##**##**+=*++=+**++*+***##%%%%%%%##%%%%%%%%%%%%%%%%%%%%%%@@@@@@@@@%%%%%%%%%%%%%%%%%%@@%##%%%%%%%%%    //
//                                                                                                                                //
//                                                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract LA is ERC721Creator {
    constructor() ERC721Creator("OMOLAYO AGBAJE", "LA") {}
}
