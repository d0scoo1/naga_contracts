// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// import {IOwnable} from "./thirdweb/IOwnable.sol";
import {Ownable} from "openzeppelin-contracts/access/Ownable.sol";
import {ERC721A} from "ERC721A/ERC721A.sol";

abstract contract BatchReveal is ERC721A, Ownable {
    bytes32 public provenanceHash;
    /// @dev URI used for pre-reveals and fully-revealed mints
    string public defaultURI;
    Reveal[] public reveals;
    bool fullyRevealed;

    struct Reveal {
        uint256 maxId;
        string uri;
    }

    event ProvenanceHashUpdated(
        bytes32 indexed oldProvenanceHash,
        bytes32 indexed newProvenanceHash
    );

    constructor(string memory _defaultURI, bytes32 _provenanceHash) {
        defaultURI = _defaultURI;
        _setProvenanceHash(_provenanceHash);
    }

    /**
     * @dev reveal a batch of tokens by including a maxId (exclusive) and a
     * URI all tokens starting at previous Reveal's maxId
     */
    function addReveal(uint256 maxId, string memory uri) public onlyOwner {
        Reveal memory reveal = Reveal(maxId, uri);
        reveals.push(reveal);
    }

    ///@dev if necessary, update Reveal struct stored at index
    function updateReveal(
        uint256 index,
        uint256 maxId,
        string memory uri
    ) public onlyOwner {
        Reveal memory newReveal = Reveal(maxId, uri);
        reveals[index] = newReveal;
    }

    ///@dev update defaultURI
    function setDefaultURI(string memory finalURI) public onlyOwner {
        _setDefaultURI(finalURI);
    }

    function _setDefaultURI(string memory finalURI) internal {
        defaultURI = finalURI;
    }

    ///@dev permanently use the defaultURI, which should be updated to final URI
    function setFullyRevealed(string memory finalURI) public onlyOwner {
        fullyRevealed = true;
        delete reveals;
        _setDefaultURI(finalURI);
    }

    /// @dev set provenance hash for this contract, emitting an event containing the old
    /// and new hashes. Allows provenance hash to be updated before mint-out while still
    /// allowing for a trail of hashes to prove fairness.
    function setProvenanceHash(bytes32 _newProvenanceHash) public onlyOwner {
        _setProvenanceHash(_newProvenanceHash);
    }

    function _setProvenanceHash(bytes32 _newProvenanceHash) internal {
        bytes32 oldProvenanceHash = provenanceHash;
        provenanceHash = _newProvenanceHash;
        emit ProvenanceHashUpdated(oldProvenanceHash, _newProvenanceHash);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return defaultURI;
    }

    function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
        // if not fully revealed, grab URI of first Reveal that covers token ID
        if (!fullyRevealed) {
            uint256 length = reveals.length;
            for (uint256 i = 0; i < length; i++) {
                Reveal memory reveal = reveals[i];
                // reveal.maxId is exclusive of tokenId
                if (_tokenId < reveal.maxId) {
                    return string.concat(reveal.uri, _toString(_tokenId));
                }
            }
        }
        // if fully revealed, concat tokenId to defaultURI; otherwise, return defaultURI as-is
        return fullyRevealed ? super.tokenURI(_tokenId) : defaultURI;
    }
}
