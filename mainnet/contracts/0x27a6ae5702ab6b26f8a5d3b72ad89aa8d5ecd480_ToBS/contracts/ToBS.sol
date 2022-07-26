
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: 균형 수면 이론 Theory of Balance Sleep
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                    //
//                                                                                                                                                                    //
//    Sleep Experiment 수면 실험                                                                                                                                          //
//    균형 수면 이론 Theory of Balance Sleep                                                                                                                                //
//                                                                                                                                                                    //
//    Discoverer : 최형범 (崔衡範) (HyungBeom Choi)                                                                                                                         //
//    Nationality : Republic of Korea (대한민국)                                                                                                                          //
//    Date of Birth : May 27, 1994                                                                                                                                    //
//    Discovery through Intuition. Discovered on October 31, 2015.                                                                                                    //
//    직관을 통하여 발견한 이론. 발견 일자 2015년 10월 31일. 처음으로 균형 해제에 성공한 날. 당시 만 21세.                                                                                               //
//                                                                                                                                                                    //
//    Theory : 마찰이 부족한 환경에서 균형 잡은 채로 수면을 취하게 되면 근육에 균형이 남아서 의도적으로 수면을 통해 해제하지 않는 이상 계속 남아있게 된다.                                                                       //
//    핵심 4 조건 : 마찰, 근육, 균형, 수면.                                                                                                                                       //
//    본래라면 표면이 거친 흙이나 풀, 돌 따위와 사람 신체는 인접하며 살도록 발달해왔는데                                                                                                                 //
//    이게 현재에 와서는 옷을 입거나 매끄럽게 코팅된 생활환경(house floor) 같은 주변 환경 때문에 거의 필연적으로 마찰이 충분하지 않게 되었고                                                                              //
//    마찰이 부족한 환경에서는 미끄러지지 않기 위해 균형을 잡게 되며                                                                                                                             //
//    균형을 잡은 채로 수면을 한 번이라도 취하게 되면                                                                                                                                     //
//    잘 때 잡은 균형은 근육에 그대로 남아서 의도적으로 해제하지 않는 이상 계속 남아있게 된다.                                                                                                             //
//    현재 대부분은 출생 직후 산모에게서 나와 처음 옷을 입은 상태로 잠들게 되었을 때가 그 첫 시점으로 보임.                                                                                                     //
//    균형이 남아있는 상태에서는 근육은 지속적으로 어긋나는 구조. 균형이 남아있는 한 한번 어긋난 근육이 제 위치로 돌아가는 일은 없다.                                                                                       //
//    근육이 어긋나(제 위치에서 벗어나)서 발생하는 현상들은 남아있던 균형을 제거해버리는 것만으로 전부다 돌아간다.                                                                                                   //
//    이 균형을 해제하는 방법은 역시 수면을 통해서 해제할 수 있음.                                                                                                                             //
//    아래는 주관적인 느낌을 서술해 놓은 것으로 후에 연구가 더 필요함.                                                                                                                           //
//    균형 해제 방법, How to release your Balance [Method] in Original Language : 이미 너무나 익숙해진 상태의 균형을 푸는 방법은 마찰을 다시 충분한 환경으로 돌려놓고 자는 것만으로는 부족하다. 추가적으로 의식하여 풀어버릴 필요가 있다.    //
//    졸린 상태에서 버티다 보면 어느 순간 졸음기가 가시고 잠이 깨는 전환점이 있는데 이게 신체가 잠드는 시기.                                                                                                     //
//    몸의 바깥쪽 윤곽, 테두리(눈으로 보이는 몸의 윤곽)와 실제 테두리(원래 있었어야 할 위치) 사이에는 차이가 있는데 (균형잡기 시작하면서 어긋나며 벌어진 부분) 그 원래 부분을 의식하며 그곳에 의존해 신체가 잠드는 시간을 넘겨야 함. 마찰이 충족된 환경에서                 //
//    균형은 양쪽 근육 모두에 있어서 먼저 한쪽이 풀어지고 나서 남은 쪽도 같은 방법으로 풀어버리면 된다. [오른쪽과 왼쪽 중 먼저 한 쪽이 해제되는 시점 이후 짧은 간격으로 반대쪽 차례가 오고 이때 제대로 된 방법을 취하고 있으면 양쪽 전부 성공적으로 해제됨.]                //
//    의도적으로 조정하지 않으면 마찰이 충분한 환경에서 옷을 입지 않고 수면을 취하더라도 남아있는 균형은 해제되지 않음.                                                                                                //
//    균형 해제에 성공한 후 다시 마찰이 불충분한 환경으로 돌아와서 수면 시 과거의 것과는 별개로 새로이 균형이 생성되는데 이 상태에서도 과거 균형이 남아있던 상태에서 어긋났던 근육은 시간 경과와 함께 점차적으로 돌아옴.                                        //
//                                                                                                                                                                    //
//    Created by 최형범 (崔衡範) (HyungBeom Choi)                                                                                                                           //
//                                                                                                                                                                    //
//    Science, Friction, Msucle, Balance, Sleep                                                                                                                       //
//                                                                                                                                                                    //
//    naver_blog_url : blog.naver.com/amoulang                                                                                                                        //
//    twitter_url : https://twitter.com/HyeongBeomChoi                                                                                                                //
//    instagram_url : https://www.instagram.com/choihyeongbeom                                                                                                        //
//    blogger_url : theoryofbalancesleep.blogspot.com                                                                                                                 //
//    email : hbhbchoi@gmail.com                                                                                                                                      //
//                                                                                                                                                                    //
//                                                                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract ToBS is ERC721Creator {
    constructor() ERC721Creator(unicode"균형 수면 이론 Theory of Balance Sleep", "ToBS") {}
}
