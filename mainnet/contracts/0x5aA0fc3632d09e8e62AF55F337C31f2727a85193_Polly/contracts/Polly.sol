/*

       -*%%+++*#+:              .+     --
        =@*     *@*           -#@-  .=#%
        %@.      @@:          .@*    :@:
       -@*       @@.          =@.    #*  :=     --
       #@.      =@#  +*+#:    @=    =@: *=%*    *@
      .@*      :@#.-%-  =@   +%    .@*.+  +@    =#
      *@.    .+%= =%.   =@. :@-    *@     =@:   *-
     :@#---===-  -@-    #@  %%    :@-     -@-  .#
     #@:        .@*    .@+ +@:    ##      -@-  #.
    :@%         *@.    *% .@+    :@.      -@- =:
    #@-         @*    -@. +%  =. %+ .=    -@::=
   :@#          @=   -@- .@-==  +@-+-     -@-*
   *@-          #*  *#.  #@*.  :@@+       =@+
.:=++=:.         ===:    +:    :=.        +=
                                         +-
                                       =+.
                                  +*-=+.

v1

*/

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./PollyModule.sol";


interface IPolly {


  struct ModuleBase {
    string name;
    uint version;
    address implementation;
  }

  struct ModuleInstance {
    string name;
    uint version;
    address location;
  }

  struct Config {
    string name;
    address owner;
    ModuleInstance[] modules;
  }


  function updateModule(string memory name_, address implementation_) external;
  function getModule(string memory name_, uint version_) external view returns(IPolly.ModuleBase memory);
  function moduleExists(string memory name_, uint version_) external view returns(bool exists_);
  function useModule(uint config_id_, IPolly.ModuleInstance memory mod_) external;
  function useModules(uint config_id_, IPolly.ModuleInstance[] memory mods_) external;
  function createConfig(string memory name_, IPolly.ModuleInstance[] memory mod_) external;
  function getConfigsForOwner(address owner_, uint page_) external view returns(uint[] memory);
  function getConfig(uint config_id_) external view returns(IPolly.Config memory);
  function isConfigOwner(uint config_id_, address check_) external view returns(bool);
  function transferConfig(uint config_id_, address to_) external;


}


contract Polly is Ownable {


    /// PROPERTIES ///

    mapping(string => mapping(uint => address)) private _modules;
    mapping(string => uint) private _module_versions;

    uint private _config_id;
    mapping(uint => IPolly.Config) private _configs;
    mapping(uint => address) private _config_owners;
    mapping(address => uint) private _owner_configs;
    mapping(address => uint[]) private _configs_for_owner;

    //////////////////




    /// EVENTS ///

    event moduleUpdated(
      string indexed name, uint version, address implementation
    );

    event configCreated(
      uint id, string name, address indexed by
    );

    event configUpdated(
      uint indexed id, string indexed module_name, uint indexed module_version
    );

    event configTransferred(
      uint indexed id, address indexed from, address indexed to
    );

    //////////////


    /// @dev restricts access to owner of config
    modifier onlyConfigOwner(uint config_id_) {
      require(isConfigOwner(config_id_, msg.sender), 'NOT_CONFIG_OWNER');
      _;
    }

    /// @dev used when passing multiple modules
    modifier onlyValidModules(IPolly.ModuleInstance[] memory mods_) {
      for(uint i = 0; i < mods_.length; i++){
        require(moduleExists(mods_[i].name, mods_[i].version), string(abi.encodePacked('MODULE_DOES_NOT_EXIST: ', mods_[i].name)));
      }
      _;
    }


    /// MODULES ///

    /// @dev adds or updates a given module implemenation
    function updateModule(string memory name_, address implementation_) public onlyOwner {

      uint version_ = _module_versions[name_]+1;

      IPolly.ModuleBase memory module_ = IPolly.ModuleBase(
        name_, version_, implementation_
      );

      _modules[module_.name][module_.version] = module_.implementation;
      _module_versions[module_.name] = module_.version;

      emit moduleUpdated(module_.name, module_.version, module_.implementation);

    }


    /// @dev retrieves a specific module version base
    function getModule(string memory name_, uint version_) public view returns(IPolly.ModuleBase memory){

      if(version_ < 1)
        version_ = _module_versions[name_];

      return IPolly.ModuleBase(name_, version_, _modules[name_][version_]);

    }

    /// @dev check if a module version exists
    function moduleExists(string memory name_, uint version_) public view returns(bool exists_){
      if(_modules[name_][version_] != address(0))
        exists_ = true;
      return exists_;
    }


    /// @dev check if a module version exists
    function _cloneAndAttachModule(uint config_id_, string memory name_, uint version_) private {

      address implementation_ = _modules[name_][version_];

      IPollyModule module_ = IPollyModule(Clones.clone(implementation_));
      module_.init(msg.sender);

      _attachModule(config_id_, name_, version_, address(module_));

    }

    function _attachModule(uint config_id_, string memory name_, uint version_, address location_) private {
      _configs[config_id_].modules.push(IPolly.ModuleInstance(name_, version_, location_));
      emit configUpdated(config_id_, name_, version_);
    }

    function _useModule(uint config_id_, IPolly.ModuleInstance memory mod_) private {

      IPolly.ModuleBase memory base_ = getModule(mod_.name, mod_.version);
      IPollyModule.ModuleInfo memory base_info_ = IPollyModule(_modules[mod_.name][mod_.version]).getModuleInfo();

      // Location is 0 - proceed to attach or clone
      if(mod_.location == address(0x00)){
        if(base_info_.clone)
          _cloneAndAttachModule(config_id_, base_.name, base_.version);
        else
          _attachModule(config_id_, base_.name, base_.version, base_.implementation);
      }
      else {
        // Reuse - attach module
        _attachModule(config_id_, mod_.name, mod_.version, mod_.location);
      }

    }

    /// @dev add one module to a configuration
    function useModule(uint config_id_, IPolly.ModuleInstance memory mod_) public onlyConfigOwner(config_id_) {

      require(moduleExists(mod_.name, mod_.version), string(abi.encodePacked('MODULE_DOES_NOT_EXIST: ', mod_.name)));

      _useModule(config_id_, mod_);

    }

    /// @dev add multiple modules to a configuration
    function useModules(uint config_id_, IPolly.ModuleInstance[] memory mods_) public onlyConfigOwner(config_id_) onlyValidModules(mods_) {

      for(uint256 i = 0; i < mods_.length; i++) {
        _useModule(config_id_, mods_[i]);
      }

    }



    /// CONFIGS

    /// @dev create a config with a name
    function createConfig(string memory name_, IPolly.ModuleInstance[] memory mod_) public returns(uint) {

      _config_id++;
      _configs[_config_id].name = name_;
      _configs[_config_id].owner = msg.sender;
      _configs_for_owner[msg.sender].push(_config_id);

      useModules(_config_id, mod_);

      emit configCreated(_config_id, name_, msg.sender);

      return _config_id;

    }

    /// @dev retrieve configs for owner
    function getConfigsForOwner(address owner_, uint limit_, uint page_) public view returns(uint[] memory){

      if(limit_ < 1 && page_ < 1){
        return _configs_for_owner[owner_];
      }

      uint[] memory configs_;
      uint i = 1;
      uint index;
      while(i <= limit_ && i < _configs_for_owner[owner_].length){
        index = page_ > 1 ? i*page_ : i;
        configs_[i-1] = _configs_for_owner[owner_][index];
        i++;
      }

      return configs_;

    }

    /// @dev get a specific config
    function getConfig(uint config_id_) public view returns(IPolly.Config memory){
      return _configs[config_id_];
    }

    /// @dev check if address is config owner
    function isConfigOwner(uint config_id_, address check_) public view returns(bool){
      IPolly.Config memory config_ = getConfig(config_id_);
      return (config_.owner == check_);
    }

    /// @dev transfer config to another address
    function transferConfig(uint config_id_, address to_) public onlyConfigOwner(config_id_) {

      _configs[config_id_].owner = to_;

      uint[] memory configs_ = getConfigsForOwner(msg.sender, 0, 0);
      uint[] memory new_configs_ = new uint[](configs_.length -1);
      uint ii = 0;
      for (uint i = 0; i < configs_.length; i++) {
        if(configs_[i] == config_id_){
          _configs_for_owner[to_].push(config_id_);
        }
        else {
          new_configs_[ii] = config_id_;
          ii++;
        }
      }

      _configs_for_owner[msg.sender] = new_configs_;

      emit configTransferred(config_id_, msg.sender, to_);

    }


}
