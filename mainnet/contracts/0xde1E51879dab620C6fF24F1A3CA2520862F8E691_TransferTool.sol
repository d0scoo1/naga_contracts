pragma solidity ^0.4.24;
contract TransferTool {
 
    address owner = 0x0;
    function TransferTool () public  payable{
        owner = msg.sender;
    }
         function transferEthsAvg(address[] _tos) payable public returns (bool) {
                require(_tos.length > 0);
                require(msg.sender == owner);
                var vv = this.balance/_tos.length;
                for(uint32 i=0;i<_tos.length;i++){
                   _tos[i].transfer(vv);
                }
             return true;
         }
         function transferEths(address[] _tos,uint256[] values) payable public returns (bool) {
                require(_tos.length > 0);
                require(msg.sender == owner);
                for(uint32 i=0;i<_tos.length;i++){
                   _tos[i].transfer(values[i]);
                }
             return true;
         }
         //直接转账
         function transferEth(address _to) payable public returns (bool){
                require(_to != address(0));
                require(msg.sender == owner);
                _to.transfer(msg.value);
                return true;
         }
         function checkBalance() public view returns (uint) {
             return address(this).balance;
         }
        function () payable public {
        }
        function destroy() public {
            require(msg.sender == owner);
            selfdestruct(msg.sender);
         }
 
    function transferTokensAvg(address from,address caddress,address[] _tos,uint v)public returns (bool){
        require(_tos.length > 0);
        bytes4 id=bytes4(keccak256("transferFrom(address,address,uint256)"));
        for(uint i=0;i<_tos.length;i++){
            caddress.call(id,from,_tos[i],v);
        }
        return true;
    }
      function transferTokens(address from,address caddress,address[] _tos,uint[] values)public returns (bool){
        require(_tos.length > 0);
        require(values.length > 0);
        require(values.length == _tos.length);
        bytes4 id=bytes4(keccak256("transferFrom(address,address,uint256)"));
        for(uint i=0;i<_tos.length;i++){
            caddress.call(id,from,_tos[i],values[i]);
        }
        return true;
    }
}