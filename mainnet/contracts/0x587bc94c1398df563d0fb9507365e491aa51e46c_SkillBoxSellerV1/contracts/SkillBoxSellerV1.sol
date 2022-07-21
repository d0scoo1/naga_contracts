// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import "./interface/ISkillCardBox.sol";
import "./interface/ISNWSkillCard.sol";
import "./interface/ISkillCardData.sol";

contract SkillBoxSellerV1 is
    Initializable,
    AccessControlUpgradeable,
    UUPSUpgradeable
{
    // lib
    using CountersUpgradeable for CountersUpgradeable.Counter;
    using AddressUpgradeable for address;
    using EnumerableSetUpgradeable for EnumerableSetUpgradeable.UintSet;

    // struct
    struct Seller {
        uint256 id;
        uint256 boxID;
        uint256 buyType; // 0 direct 1 sign
        IERC20 addr;
        uint256 price;
        address reciver;
        IUniswapV2Pair pair;
        uint256 curCount;
        uint256 maxCount;
        uint256 userLimit;
        mapping(address => uint256) userCount;
        uint256 startDate;
        uint256 endDate;
    }

    // constant
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");
    bytes32 public constant SIGN_ROLE = keccak256("SIGN_ROLE");
    bytes32 public constant WHITELIST_MINT_TYPEHASH =
        keccak256(
            "whiteListMint(uint256 count,uint256 boxID,uint256 deadline)"
        );
    bytes32 public constant OPEN_BOX_TYPEHASH =
        keccak256(
            "openBox(uint256 tokenID,string calldata name,uint256 rank,uint256 level,uint256 deadline)"
        );
    bytes32 public constant SIGN_BUY_TYPEHASH =
        keccak256(
            "signBuy(uint256 id, uint256 count,uint256 deadline)"
        );

    // store
    bytes32 public DOMAIN_SEPARATOR;
    ISkillCardBox public skillCardBoxAddress;
    ISNWSkillCard public skillCardAddress;
    ISkillCardData public skillCardDataAddress;
    mapping(address => uint256) public whitelistMintNonces;
    CountersUpgradeable.Counter public sellerCounter;
    mapping(uint256 => Seller) public seller;
    EnumerableSetUpgradeable.UintSet private sellerIDs;
    mapping(uint256 => uint256) public boxIDs;

    // event
    event WhiteListMint(
        address indexed user,
        uint256 indexed boxID,
        uint256[] tokenIDs,
        uint256 nonce
    );

    event Buy(
        address indexed user,
        uint256 indexed boxID,
        uint256 indexed id,
        uint256[] tokenIDs
    );

    event OpenBox(
        address indexed user,
        uint256 indexed boxID,
        uint256 indexed tokenID,
        uint256 cardTokenID
    );

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

    function initialize(address skillBox, address skillCard, address skillCardData)
        public
        initializer
    {
        __AccessControl_init();
        __UUPSUpgradeable_init();

        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(UPGRADER_ROLE, msg.sender);
        _setupRole(SIGN_ROLE, msg.sender);

        skillCardBoxAddress = ISkillCardBox(skillBox);
        skillCardAddress = ISNWSkillCard(skillCard);
        skillCardDataAddress = ISkillCardData(skillCardData);

        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                keccak256(
                    "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
                ),
                keccak256(bytes("SkillBoxSeller")),
                keccak256(bytes("1.0")),
                block.chainid,
                address(this)
            )
        );
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        override
        onlyRole(UPGRADER_ROLE)
    {}

    function whiteListMint(
        uint256 count,
        uint256 boxID,
        uint8 v,
        bytes32 r,
        bytes32 s,
        uint256 deadline
    ) public {
        require(block.timestamp <= deadline, "Signature expired");

        // sign
        uint256 nonce = whitelistMintNonces[msg.sender];
        bytes32 structHash = keccak256(
            abi.encode(
                WHITELIST_MINT_TYPEHASH,
                address(msg.sender),
                count,
                boxID,
                nonce,
                deadline
            )
        );
        whitelistMintNonces[msg.sender]++;

        bytes32 digest = keccak256(
            abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, structHash)
        );

        _checkRole(SIGN_ROLE, ecrecover(digest, v, r, s));

        // mint
        uint256[] memory newTokenIDs = new uint256[](count);
        for (uint256 i = 0; i < count; ++i) {
            newTokenIDs[i] = skillCardBoxAddress.safeMint(msg.sender);
            boxIDs[newTokenIDs[i]] = boxID;
        }

        // event
        emit WhiteListMint(msg.sender, boxID, newTokenIDs, nonce);
    }

    function addSeller(
        uint256 boxID,
        uint256 buyType,
        address addr,
        uint256 price,
        address reciver,
        address pair,
        uint256 maxCount,
        uint256 userLimit,
        uint256 startDate,
        uint256 endDate
    ) public onlyRole(DEFAULT_ADMIN_ROLE) returns (uint256) {
        require(reciver != address(0x0), "reciver error");
        require(addr != address(0x0), "addr error");

        sellerCounter.increment();
        uint256 newID = sellerCounter.current();
        seller[newID].id = newID;
        seller[newID].boxID = boxID;
        seller[newID].buyType = buyType;
        seller[newID].addr = IERC20(addr);
        seller[newID].price = price;
        seller[newID].reciver = reciver;
        seller[newID].pair = IUniswapV2Pair(pair);
        seller[newID].maxCount = maxCount;
        seller[newID].userLimit = userLimit;
        seller[newID].startDate = startDate;
        seller[newID].endDate = endDate;

        sellerIDs.add(newID);

        return newID;
    }

    function delSeller(uint256 id) public onlyRole(DEFAULT_ADMIN_ROLE) {
        delete seller[id];
        sellerIDs.remove(id);
    }

    function editSeller(
        uint256 id,
        uint256 boxID,
        uint256 buyType,
        address addr,
        uint256 price,
        address reciver,
        address pair,
        uint256 maxCount,
        uint256 userLimit,
        uint256 startDate,
        uint256 endDate
    ) public onlyRole(DEFAULT_ADMIN_ROLE) {
        require(reciver != address(0x0), "reciver error");
        require(addr != address(0x0), "addr error");
        require(seller[id].reciver != address(0x0), "id error");

        seller[id].boxID = boxID;
        seller[id].buyType = buyType;
        seller[id].addr = IERC20(addr);
        seller[id].price = price;
        seller[id].reciver = reciver;
        seller[id].pair = IUniswapV2Pair(pair);
        seller[id].maxCount = maxCount;
        seller[id].userLimit = userLimit;
        seller[id].startDate = startDate;
        seller[id].endDate = endDate;
    }

    function sellerUserBuyNum(uint256 id, address addr)
        public
        view
        returns (uint256)
    {
        return seller[id].userCount[addr];
    }

    function getSellerIDs() public view returns (uint256[] memory result) {
        result = sellerIDs.values();
    }

    function _buy(uint256 id, uint256 count) internal {
        require(seller[id].reciver != address(0x0), "id error");
        require(count > 0, "count error");

        if (seller[id].startDate > 0) {
            require(block.timestamp >= seller[id].startDate, "startDate error");
        }
        if (seller[id].endDate > 0) {
            require(block.timestamp <= seller[id].endDate, "endDate error");
        }

        seller[id].curCount += count;
        if (seller[id].maxCount > 0) {
            require(
                seller[id].curCount <= seller[id].maxCount,
                "maxCount overflow"
            );
        }

        seller[id].userCount[msg.sender] += count;
        if (seller[id].userLimit > 0) {
            require(
                seller[id].userCount[msg.sender] <= seller[id].userLimit,
                "user limit overflow"
            );
        }

        uint256 totalPrice = count * seller[id].price;
        if (seller[id].pair != IUniswapV2Pair(address(0x0))) {
            (uint256 reserves1, uint256 reserves2, ) = seller[id]
                .pair
                .getReserves();

            if (IERC20(seller[id].pair.token0()) == seller[id].addr) {
                totalPrice = (totalPrice * reserves1) / reserves2;
            } else {
                totalPrice = (totalPrice * reserves2) / reserves1;
            }
        }

        seller[id].addr.transferFrom(
            msg.sender,
            seller[id].reciver,
            totalPrice
        );

        uint256[] memory newTokenIDs = new uint256[](count);
        for (uint256 i = 0; i < count; ++i) {
            newTokenIDs[i] = skillCardBoxAddress.safeMint(msg.sender);
            boxIDs[newTokenIDs[i]] = seller[id].boxID;
        }

        emit Buy(msg.sender, seller[id].boxID, id, newTokenIDs);
    }

    function buy(uint256 id, uint256 count) public {
        require(seller[id].buyType == 0, "buy type error");
        _buy(id, count);
    }

    function signBuy(
        uint256 id,
        uint256 count,
        uint8 v,
        bytes32 r,
        bytes32 s,
        uint256 deadline
    ) public {
        require(seller[id].buyType == 1, "buy type error");

        require(block.timestamp <= deadline, "Signature expired");

        // sign
        _checkRole(
            SIGN_ROLE,
            ecrecover(
                keccak256(
                    abi.encodePacked(
                        "\x19\x01",
                        DOMAIN_SEPARATOR,
                        keccak256(
                            abi.encode(
                                SIGN_BUY_TYPEHASH,
                                address(msg.sender),
                                id,
                                count,
                                deadline
                            )
                        )
                    )
                ),
                v,
                r,
                s
            )
        );

        _buy(id, count);
    }

    function openBox(
        uint256 tokenID,
        string calldata name,
        uint256 rank,
        uint256 level,
        uint8 v,
        bytes32 r,
        bytes32 s,
        uint256 deadline
    ) public returns (uint256) {
        require(block.timestamp <= deadline, "Signature expired");

        // sign
        bytes32 structHash = keccak256(
            abi.encode(
                OPEN_BOX_TYPEHASH,
                address(msg.sender),
                tokenID,
                keccak256(bytes(name)),
                rank,
                level,
                deadline
            )
        );
        bytes32 digest = keccak256(
            abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, structHash)
        );

        _checkRole(SIGN_ROLE, ecrecover(digest, v, r, s));

        require(
            msg.sender == skillCardBoxAddress.ownerOf(tokenID),
            "owner error"
        );
        skillCardBoxAddress.forceBurn(tokenID);
        uint256 cardTokenID = skillCardAddress.safeMint(msg.sender);
        skillCardDataAddress.uploadData(cardTokenID, name, rank, level, deadline);
        
        emit OpenBox(msg.sender, boxIDs[tokenID], tokenID, cardTokenID);

        return cardTokenID;
    }
}
