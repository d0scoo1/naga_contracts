// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

interface IBEP20 {

    function totalSupply() external view returns (uint256);

    function decimals() external view returns (uint8);

    function symbol() external view returns (string memory);

    function name() external view returns (string memory);

    function getOwner() external view returns (address);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Burn(address indexed burner, uint256 value);

    event Mint(address indexed minter, uint256 value);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    function allowance(address owner, address spender) external view returns (uint256);

    // Custom Event for making log entry for contract
    event ContributionAirDropUpdate(
        uint256 _total_beneficiary_count,
        uint256 _distributed_amount,
        uint256 _total_eligible_circulation,
        uint256 _timestamp
    );
    event ContributionAddedToContributionDistributionVariable(uint256 contribution);

    event PublicAirDrop(
        uint256 _total_amount,
        uint256 _number_of_reciepent,
        uint256 _timestamp
    );

    event ProfitAirDrop(
        uint256 _total_beneficiary_count,
        uint256 _distributed_amount,
        uint256 _total_eligible_circulation,
        uint256 _timestamp
    );

    event ContributionDeductionAndBurningLog(
        uint256 _marketing_contribution,
        uint256 _development_contribution,
        uint256 _holder_contribution,
        uint256 _burn_amount
    );

}
