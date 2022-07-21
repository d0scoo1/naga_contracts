import { ERC20 } from "solmate/mixins/ERC4626.sol";

interface IArbVault {
    function maturity() external view returns(uint256);
    function asset() external view returns(ERC20);
}