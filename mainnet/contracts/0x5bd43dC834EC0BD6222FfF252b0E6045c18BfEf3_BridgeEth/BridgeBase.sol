// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './IERC20.sol';
import './IToken.sol';

// Recebe o endereço do token no seu construtor do BridgeBsc ou BridgeEth
// Este contrato serve para duas pontes: ou ele é BridgeEth ou BridgeBsc
// Se ele for bridgeEth tem acesso às funções mint e burn do token eth e vice-versa
// Em geral a ApiBridge deve ser owner deste contrato e este contrato owner do token
contract BridgeBase {
  // admin address controlled by the bridge api
  // a BridgeApi é o admin
  address public admin;
  
  // pode ser o token na ethereum ou na bsc
  // aqui o smartcontract bridge instancia o token
  IToken public token;

  address public deadWallet = 0x000000000000000000000000000000000000dEaD;
  
  // evita que a mesma transação seja processada duas vezes.
  uint public nonce;
  
  mapping(uint => bool) public processedNonces;

  // fixa o processo se é burn ou mint
  enum Step { Burn, Mint }
  
  event Transfer(
    address from,
    address to,
    uint amount,
    uint date,
    uint nonce,
    Step indexed step
  );

  // o contrato bridge recebe no construtor o endereço do token que será queimado ou mintado 
  // o admin é o msg.sender
  constructor(address _token) {
    // só o admin deste contrato pode chamar a função mint deste contrato
    // 
    admin = msg.sender;
    // instancia duas funções do token por meio da interface, ou seja mint e burn
    token = IToken(_token);
  }


  // esta função é chamada pelo front
  function burn( uint amount) external {
    
   // transfere para a carteira da morte
    token.transferFrom(msg.sender, deadWallet, amount);
    
    emit Transfer(
      msg.sender,
      deadWallet,
      amount,
      block.timestamp,
      nonce,
      Step.Burn
    );
    nonce++;
  }

 /* apenas a bridge api pode chamar  a função mint da bridge smart contract 
 e apenas o owner do token pode chamar a função mint do token;
 É diferente quem chama a função deste smart contract de quem este smart contract chama
 */
   function mint(address to, uint amount, uint otherChainNonce) external {
     
     // o endereço que chama esta função tem que ser o mesmo da bridgeAPI 
    require(msg.sender == admin, 'only admin');
    
    require(processedNonces[otherChainNonce] == false, 'transfer  processed');
    processedNonces[otherChainNonce] = true;
    
    // instanciação do token 
    // Este contrato tem que ser o owner do token para chamar esta função
    token.mint(amount, to);
    
    emit Transfer(
      // only admin
      msg.sender,
      to,
      amount,
      block.timestamp,
      otherChainNonce,
      Step.Mint
    );
  }

  function updateAdmin(address newAdmin) external {
    require(msg.sender == admin, 'only admin');
    admin = newAdmin;
  }
}
