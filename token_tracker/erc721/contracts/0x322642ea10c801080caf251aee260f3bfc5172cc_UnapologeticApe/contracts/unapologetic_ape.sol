    // SPDX-License-Identifier: MIT

    pragma solidity ^0.8.11;

    import "erc721a/contracts/ERC721A.sol";
    import "@openzeppelin/contracts/access/Ownable.sol";
    import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
    import "@openzeppelin/contracts/utils/Strings.sol";
    import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

    contract UnapologeticApe is Ownable, ERC721A, ReentrancyGuard {
        string public notRevealedUri;   
        string public baseExtension = ".json";
        
        uint256 public immutable MAX_SUPPLY = 5000;
        uint256 public PRICE = 0.08 ether;
        uint256 public PRESALE_PRICE = 0.06 ether;
        uint256 public maxPresale = 2500;
        uint256 public maxPublic = 2500;
        uint256 public _preSaleListCounter;
        uint256 public _publicCounter;
        uint256 public _reserveCounter;
        uint256 public _airdropCounter;

        bool public _isActive = false;
        bool public _presaleActive = false;
        bool public _revealed = false;

        mapping(address => bool) public allowList;

        // merkle root
        bytes32 public preSaleRoot;

        constructor(
            string memory name,
            string memory symbol,
            string memory _notRevealedUri
        )
            ERC721A(name, symbol)
        {
            setNotRevealedURI(_notRevealedUri);
        }

        function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
        {
            require(
                _exists(tokenId),
                "ERC721AMetadata: URI query for nonexistent token"
            );

            if(_revealed == false) {
                return notRevealedUri;
            }

            string memory currentBaseURI = _baseURI();
            return bytes(currentBaseURI).length > 0
            ? string(abi.encodePacked(currentBaseURI, Strings.toString(tokenId), baseExtension))
            : "";
        }

        function setActive(bool isActive) public onlyOwner {
            _isActive = isActive;
        }

        function presaleActive(bool isActive) public onlyOwner {
            _presaleActive = isActive;
        }

        function setMaxPresale(uint256 _maxPresale) public onlyOwner {
            maxPresale = _maxPresale;
        }

        function setMaxPublic(uint256 _maxPublic) public onlyOwner {
            maxPublic = _maxPublic;
        }

        function setCost(uint256 _newCost) public onlyOwner {
            PRICE = _newCost;
        }

        function setPresaleMintPrice(uint256 _newCost) public onlyOwner {
            PRESALE_PRICE = _newCost;
        }

        function setPreSaleRoot(bytes32 _merkleRoot) public onlyOwner {
            preSaleRoot = _merkleRoot;
        }

        function reserveMint(uint256 quantity) public onlyOwner {
            require(
                totalSupply() + quantity <= MAX_SUPPLY,
                "would exceed max supply"
            );
            _safeMint(msg.sender, quantity);
            _reserveCounter = _reserveCounter + quantity;
        }

        function airDrop(address to, uint256 quantity) public onlyOwner{
            require(
                totalSupply() + quantity <= MAX_SUPPLY,
                "would exceed max supply"
            );
            require(quantity > 0, "need to mint at least 1 NFT");
            _safeMint(to, quantity);
            _airdropCounter = _airdropCounter + quantity;
        }

        // metadata URI
        string private _baseTokenURI;

        function setBaseURI(string calldata baseURI) public onlyOwner {
            _baseTokenURI = baseURI;
        }

        function _baseURI() internal view virtual override returns (string memory) {
            return _baseTokenURI;
        }

        function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
            notRevealedUri = _notRevealedURI;
        }

        function reveal(bool _state) public onlyOwner {
            _revealed = _state;
        }

        function mintPreSaleTokens(uint8 quantity, bytes32[] calldata _merkleProof)
            public
            payable
            nonReentrant
        {
            require(_presaleActive, "Pre sale is not active");
            require(
                _preSaleListCounter + quantity <= maxPresale,
                "Exceeded max available to purchase"
            );
            require(quantity > 0, "Must mint more than 0 tokens");
            require(
                totalSupply() + quantity <= MAX_SUPPLY,
                "Purchase would exceed max supply of Tokens"
            );
            require(PRESALE_PRICE * quantity == msg.value, "Incorrect funds");

            // check proof & mint
            bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
            require(
                MerkleProof.verify(_merkleProof, preSaleRoot, leaf) ||
                    allowList[msg.sender],
                "Invalid signature/ Address not whitelisted"
            );
            _safeMint(msg.sender, quantity);
            _preSaleListCounter = _preSaleListCounter + quantity;
        }

        function addToPreSaleOverflow(address[] calldata addresses)
            external
            onlyOwner
        {
            for (uint256 i = 0; i < addresses.length; i++) {
                allowList[addresses[i]] = true;
            }
        }

        // public mint
        function publicSaleMint(uint256 quantity)
            public
            payable
            nonReentrant
        {
            require(quantity > 0, "Must mint more than 0 tokens");
            require(_isActive, "public sale has not begun yet");
            require(PRICE * quantity == msg.value, "Incorrect funds");
            require(_publicCounter + quantity <= maxPublic, "reached max supply");

            _safeMint(msg.sender, quantity);
            _publicCounter = _publicCounter + quantity;
        }

        function getBalance() public view returns (uint256) {
            return address(this).balance;
        }

        //withdraw to owner wallet
        function withdraw() public payable onlyOwner nonReentrant {
            uint256 balance = address(this).balance;
            require(balance > 0, "No ether left to withdraw");
            payable(msg.sender).transfer(balance);
        }
    }