// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

library Variables {
    // Baisc contract variable declaration
    string public constant _name = "Safe Coliseum";
    string public constant _symbol = "SCOLT";
    uint8 public constant _decimals = 8;
    uint256 public constant _initial_total_supply = 105000000 * 10**_decimals;

    // Token distribution veriables
    uint256 public constant _pioneer_invester_supply = (12 * _initial_total_supply) / 100;
    uint256 public constant _ifo_supply = (21 * _initial_total_supply) / 100;
    uint256 public constant _pool_airdrop_supply = (3 * _initial_total_supply) / 100;
    uint256 public constant _director_supply_each = (5 * _initial_total_supply) / 100;
    uint256 public constant _marketing_expansion_supply = (19 * _initial_total_supply) / 100;
    uint256 public constant _development_expansion_supply = (6 * _initial_total_supply) / 100;
    uint256 public constant _liquidity_supply = (5 * _initial_total_supply) / 100;
    uint256 public constant _future_team_supply = (10 * _initial_total_supply) / 100;
    uint256 public constant _governance_supply = (4 * _initial_total_supply) / 100;
    uint256 public constant _investment_parter_supply = (10 * _initial_total_supply) / 100;

    // Transaction contribution AirDrop variable
    uint256 public constant _contribution_distribute_after = 700 * 10**_decimals;
    uint256 public constant _contribution_distribution_eligibility = 700 * 10**_decimals;
    
    uint256 public constant _profit_distribution_eligibility = 1000 * 10**_decimals;

    // Burning till total of 50% supply
    uint256 public constant _burning_till = _initial_total_supply / 2;

    // Whale defination
    uint256 public constant _whale_per = (_initial_total_supply / 100); // 1% of total tokans consider tobe whale

    // contribution structure defination, this will be in % ranging from 0 - 100
    uint256 public constant _normal_contribution_per = 2;
    uint256 public constant _whale_contribution_per = 5;

    // below is percentage, consider _normal_contribution_per as 100%
    uint256 public constant _normal_marketing_share = 27;
    uint256 public constant _normal_development_share = 7;
    uint256 public constant _normal_holder_share = 43;
    uint256 public constant _normal_burning_share = 23;

    // below is percentage, consider _whale_contribution_per as 100%
    uint256 public constant _whale_marketing_share = 32;
    uint256 public constant _whale_development_share = 10;
    uint256 public constant _whale_holder_share = 40;
    uint256 public constant _whale_burning_share = 18;

    // antidump variables
    uint256 public constant _max_sell_amount_whale = 5000 * 10**_decimals; // max for whale
    uint256 public constant _max_sell_amount_normal = 2000 * 10**_decimals; // max for non-whale
    uint256 public constant _max_concurrent_sale_day = 6;
    uint256 public constant _cooling_days = 3;
    uint256 public constant _max_sell_per_director_per_day = 10000 * 10**_decimals;
    uint256 public constant _investor_swap_lock_days = 180; // after 180 days will behave as normal purchase user.

    // Wallet specific declaration
    // UndefinedWallet : means 0 to check there is no wallet entry in Contract
    enum type_of_wallet {
        UndefinedWallet,
        GenesisWallet,
        DirectorWallet,
        MarketingWallet,
        DevelopmentWallet,
        LiquidityWallet,
        GovernanceWallet,
        GeneralWallet,
        FutureTeamWallet,
        PoolOrAirdropWallet,
        IfoWallet,
        UnsoldTokenWallet,
        DexPairWallet
    }

    struct _DateTime {
        uint16 year;
        uint8 month;
        uint8 day;
        uint8 hour;
        uint8 minute;
        uint8 second;
        uint8 weekday;
    }

    struct wallet_details {
        type_of_wallet wallet_type;
        uint256 balance;
        uint256 lastday_total_sell;
        uint256 concurrent_sale_day_count;
        _DateTime last_sale_date;
        _DateTime joining_date;
        bool contribution_apply;
        bool antiwhale_apply;
        bool anti_dump;
        bool is_investor;
    }

    // Chain To Chain Transfer Process Variables
    struct ctc_approval_details {
        bool has_value;
        string uctcid;
        uint256 allowed_till;
        bool used;
        bool burn_or_mint; // false = burn, true = mint
        uint256 amount;
    }

    struct distribution_variables {
        uint256 total_contributions;
        uint256 marketing_contributions;
        uint256 development_contributions;
        uint256 holder_contributions;
        uint256 burn_amount;
    }

    struct function_addresses {
        address owner;
        address sender;
        address this_address;
    }

    struct function_amounts {
        uint256 amount;
        uint256 pending_contribution_to_distribute;
        uint256 initial_total_supply;
        uint256 total_supply;
        uint256 burning_till_now;
    }

    struct function_bools {
        bool _sellers_check_recipient;
        bool _sellers_check_sender;
    }

    struct checkrules_additional_var {
        address sender;
        address recipient;
        uint256 amount;
        bool _sellers_check_recipient;
        bool _sellers_check_sender;
    }

    uint256 public constant _ctc_aproval_validation_timespan = 300; // In Seconds

    // SCOLT Specific Wallets
    address public constant _director_wallet_1 = 0x42B8Ba6D6bD7cD19e132aE5701F970Df0A6b96B1;
    address public constant _director_wallet_2 = 0x9CF71f45c110A4BD01a0Fc0ca2A2f4E9A5e48DF0;
    address public constant _marketing_wallet = 0x548F4817aDC48Df4Abe079c61E731c3ACC216331;
    address public constant _governance_wallet = 0x342B9C569cBaE2AF834dd13539633291A5a8d23B;
    address public constant _liquidity_wallet = 0x27AB3d2F9eB7274092Bf67c54cff1574eA3AFfF4;
    address public constant _pool_airdrop_wallet = 0x7aA854Bc1042df6b10F2a30981FC5DE0fDCF04D2;
    address public constant _future_team_wallet = 0x0Cd8Bd5a0B4DF8a861704c7da1f7D0eB63b2dDa6;
    address public constant _ifo_wallet = 0xffaFCD12D27DCF48a076C914b335B5c152d12609;
    address public constant _development_wallet = 0x8f0070EbC10E4586fC23fc37C6F1975F07f19867;
    address public constant _unsold_token_wallet = 0xC7008531330Ea8BBe55c6fc9b4bED018C1E0AF0e;

}
