// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Controller is Ownable {

  mapping(address =>bool) public isAdmin;
  mapping(address =>bool) public isRegistrar;
  mapping(address =>bool) public isOracle;
  mapping(address =>bool) public isValidator;
  address[] public validators;
  address[] public admins;
  address[] public oracles;
  address[] public registrars;
 
  event AdminAdded(address indexed admin);
  event AdminRemoved(address indexed admin);
  event RegistrarAdded(address indexed registrar);
  event RegistrarRemoved(address indexed registrar);
  event OracleAdded(address indexed oracle);
  event OracleRemoved(address indexed oracle);
  event ValidatorAdded(address indexed validator);
  event ValidatorRemoved(address indexed validator);


  modifier onlyAdmin() {
        require(isAdmin[_msgSender()] || owner() == _msgSender(), "U_A");
        _;
    }
    

   constructor() {
        // isAdmin[_msgSender()] = true;
        addAdmin(_msgSender() , true);
    }


  function addAdmin(address _admin , bool add) public onlyOwner {
      if (add) {
          require(!isAdmin[_admin] , "already an admin");
          emit AdminAdded(_admin);
          admins.push(_admin);
      } else {
          require(isAdmin[_admin] , "not an admin");
          uint256 adminLength = admins.length;
          for (uint256 index; index < adminLength ; index++) {
            if (admins[index] == _admin) {
               admins[index] = admins[adminLength - 1];
               admins.pop();
            }
          }
          emit AdminRemoved(_admin);
      }
      isAdmin[_admin] = add;
    }


  function addRegistrar(address _registrar , bool add) external onlyAdmin {
      if (add) {
          require(!isRegistrar[_registrar] , "already a Registrer");
          emit RegistrarAdded(_registrar);
          registrars.push(_registrar);
       } else {
           uint256 registrarLength = registrars.length;
            require(isRegistrar[_registrar] , "not a Registrer");
            for (uint256 index; index < registrarLength; index++) {
                if (registrars[index] == _registrar) {
                registrars[index] = registrars[registrarLength - 1];
                registrars.pop();
                }
            }
            emit RegistrarRemoved(_registrar);
        }
        isRegistrar[_registrar] = add;
    } 


    function addOracle(address _oracle , bool add) external onlyAdmin {
        if (add) {
            require(!isOracle[_oracle] , "already an oracle");
            emit OracleAdded(_oracle);
            oracles.push(_oracle);
        } else {
        require(isOracle[_oracle] , "not an oracle");
        uint256 oracleLength = oracles.length;
          for (uint256 index; index < oracleLength ; index++) {
            if (oracles[index] == _oracle) {
                oracles[index] = oracles[oracleLength - 1];
                oracles.pop();
            }
         }
         emit OracleRemoved(_oracle);
        }
        isOracle[_oracle] = add;
    }  
    
    
   function addValidator(address _validator , bool add) external onlyAdmin {
        if (add) {
            require(!isValidator[_validator] , "already a Validator");
            emit ValidatorAdded(_validator);
            validators.push(_validator);
        } else {
            require(isValidator[_validator] , "not a Validator");
            uint256 validatorLength = validators.length;
            for (uint256 index; index < validatorLength ; index++) {
                if (validators[index] == _validator) {
                    validators[index] = validators[validatorLength - 1];
                    validators.pop();
                }
            }
            emit ValidatorRemoved(_validator);
        }
        isValidator[_validator] = add;
   } 


  function validatorsCount() public  view returns (uint256){
      return validators.length;
  }


  function oraclesCount() public  view returns (uint256){
      return oracles.length;
  }


  function adminsCount() public  view returns (uint256){
      return admins.length;
  }


  function registrarsCount() public  view returns (uint256){
      return registrars.length;
  }
}
