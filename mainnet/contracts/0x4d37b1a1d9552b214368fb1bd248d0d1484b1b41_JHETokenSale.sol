pragma solidity ^0.5.0;

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0);
        uint256 c = a / b;

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

contract JHEToken {
    mapping(address => uint256) public balanceOf;

    function transfer(address _to, uint256 _value) public returns (bool success) {}
    function approve(address _spender, uint256 _value) public returns (bool success) {}
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}
}

contract JHETokenSale {
    using SafeMath for uint;

    address public owner;
    address payable public etherWallet;
    JHEToken public tokenContract;
    uint256 public tokenPrice;
    uint256 public tokensSold;
    uint256 public totalFeeAmount;

    _Fee[] public feeDistributions;   // array of _Fee struct

    struct _Fee {
        uint256 id;
        string name;
        address payable wallet;
        uint256 percent;
        bool active;
    }


    event Sell(address _buyer, uint256 _amount);

    constructor(JHEToken _tokenContract, uint256 _tokenPrice, address payable _etherWallet) public {
        owner = msg.sender;
        tokenContract = _tokenContract;
        tokenPrice = _tokenPrice;
        totalFeeAmount = 0;
        etherWallet = _etherWallet;
    }

    // Modifier
    modifier onlyOwner() {
        require(msg.sender == owner, "owner only");
        _;
    }
    modifier noBalance() {
        // require(totalFeeAmount == 0, "fee not null, transfer funds first");
        require(address(this).balance == 0, "balance not null, transfer funds first");
        _;
    }



    function multiply(uint x, uint y) internal pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x,'');
    }

    function buyTokens(uint256 _numberOfTokens) public payable {
        uint256 tokenTotalPrice = (multiply(_numberOfTokens, tokenPrice)).div(10**18);
        // calculate the total fee amount
        uint256 totalFeePercent = getTotalFeePercent ();
        uint256 _totalFeeAmount = tokenTotalPrice.mul(totalFeePercent).div(100000);  // FEE: 100000 = 100%
        totalFeeAmount = totalFeeAmount.add (_totalFeeAmount);

        require(msg.value >= tokenTotalPrice.add(_totalFeeAmount),'incorrect amount');
        require(tokenContract.balanceOf(address(this)) >= _numberOfTokens,'contract has not enough token');
        require(tokenContract.transfer(msg.sender, _numberOfTokens),'transfer error');

        // sebd ether
        uint256 ethAmount = msg.value;
        _transferPayments(ethAmount);

        tokensSold += _numberOfTokens;

        emit Sell(msg.sender, _numberOfTokens);
    }

    // Transfer ether payments
    function _transferPayments(uint256 ethAmount) internal {
        require(ethAmount > 0, "no ether recieved");

        // transfer owner's ether deducted from total Fee Amount
        uint256 _ownerFunds = ethAmount.sub(totalFeeAmount);
        etherWallet.transfer(_ownerFunds);

        // distribute fees
        uint256 feesCount = getFeeDistributionsCount();
        _Fee[] storage fees = feeDistributions;

        for (uint i = 0; i < feesCount; i++){
            if (fees[i].active){
                uint feeValue = _ownerFunds.mul(fees[i].percent).div(100000);  // FEE: 100000 = 100%
                fees[i].wallet.transfer(feeValue);
            }
        }

        // if eth rest: in case of fee deactivated...
        if (address(this).balance != 0){
            etherWallet.transfer(address(this).balance);
        }
        totalFeeAmount = 0;
    }


    function endSale() public onlyOwner{
        require(tokenContract.transfer(owner, tokenContract.balanceOf(address(this))),'transfer error');

        // UPDATE: Let's not destroy the contract here
        // Just transfer the balance to the owner
        // transferFunds();
    }

    // Transfer funds
    function transferFunds() public onlyOwner {
        // require(address(this).balance > 0, "no funds");

        uint256 totalFunds = address(this).balance;

        // transfer owner's ether deducted from total Fee Amount
        uint256 _ownerFunds = totalFunds.sub(totalFeeAmount);
        etherWallet.transfer(_ownerFunds);

        // distribute fees
        uint256 feesCount = getFeeDistributionsCount();
        _Fee[] storage fees = feeDistributions;

        for (uint i = 0; i < feesCount; i++){
            if (fees[i].active){
                uint feeValue = _ownerFunds.mul(fees[i].percent).div(100000);  // FEE: 100000 = 100%
                fees[i].wallet.transfer(feeValue);
            }
        }

        // if eth rest: in case of fee deactivated...
        if (address(this).balance != 0){
            etherWallet.transfer(address(this).balance);
        }
        totalFeeAmount = 0;
    }

    /*
    *       FEE: 
    *              1 = 0.001%
    *           1000 = 1%
    *         100000 = 100%
    */
    function setFeeDistributions(address payable _feeWallet, string memory _name, uint256 _percent) public  onlyOwner noBalance{
        require(_feeWallet != address(0), "address not valid");
        // emit FeePercentChanged(feePercent, _newFeePercent);

        _Fee[] storage fees = feeDistributions;
        // uint256 feesCount = fees.length;
        uint256 feesCount = getFeeDistributionsCount();

        bool feeExiste = false;

        uint totalFeePercent = getTotalFeePercent ();
        totalFeePercent = totalFeePercent.add(_percent);
        require(totalFeePercent <= 100000, "total fee cannot exceed 100");

        for (uint i = 0; i < feesCount; i++){
            if (fees[i].wallet == _feeWallet){
                fees[i].name    = _name;
                fees[i].percent = _percent;
                fees[i].active  = true;

                feeExiste = true;
                break;
            }
        }

        // fee not found => add as new fee
        if (!feeExiste){
            _Fee memory fee;

            fee.id = (feesCount + 1);
            fee.name = _name;
            fee.wallet = _feeWallet;
            fee.percent = _percent;
            fee.active = true;

            fees.push(fee);
        }
    }

    function getFeeDistributionsCount() public view returns(uint) {
        _Fee[] storage fees = feeDistributions;
        return fees.length;
    }

    function getTotalFeePercent () public view returns (uint){
        uint256 totalFeePercent = 0;
        uint256 feesCount = getFeeDistributionsCount();
        _Fee[] storage fees = feeDistributions;

        for (uint i = 0; i < feesCount; i++){
            if (fees[i].active){
                totalFeePercent = totalFeePercent.add(fees[i].percent);
            }
        }

        return totalFeePercent;
    }

    function deActivateFeeWallet(address _feeWallet) public onlyOwner {
        require(_feeWallet != address(0), "address not valid");
        // emit FeePercentChanged(feePercent, _newFeePercent);

        _Fee[] storage fees = feeDistributions;
        // uint256 feesCount = fees.length;
        uint256 feesCount = getFeeDistributionsCount();
        for (uint i = 0; i < feesCount; i++){
            if (fees[i].wallet == _feeWallet){
                fees[i].active = false;
                break;
            }
        }
    }

    // Transfer Owner
    function transferOwnership(address payable _newOwner) public onlyOwner {
        _transferOwnership(_newOwner);
    }
    function _transferOwnership(address payable _newOwner) internal {
        require(_newOwner != address(0), "address not valid");
        owner = _newOwner;
    }

    // Transfer ether wallet
    function transferEtherWallet(address payable _newEtherWallet) public onlyOwner {
        _transferEtherWallet(_newEtherWallet);
    }
    function _transferEtherWallet(address payable _newEtherWallet) internal {
        require(_newEtherWallet != address(0), "address not valid");
        etherWallet = _newEtherWallet;
    }

    // set token price
    function setTokenPrice(uint256 _tokenPrice) public onlyOwner {
        require(_tokenPrice != 0, "token price is null");
        tokenPrice = _tokenPrice;
    }

}