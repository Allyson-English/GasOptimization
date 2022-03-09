// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721Full_0.sol";
import "./INiftyRegistry_0.sol";
import "./BuilderMaster_0.sol";

contract NiftyBuilderInstance_0 is ERC721Full_0 {
    //MODIFIERS

    modifier onlyValidSender() {
        INiftyRegistry_0 nftg_registry = INiftyRegistry_0(
            niftyRegistryContract
        );
        bool is_valid = nftg_registry.isValidNiftySender(msg.sender);
        require(is_valid == true);
        _;
    }

    //CONSTANTS

    // how many nifties this contract is selling
    // used for metadat retrieval
    uint256 public numNiftiesCurrentlyInContract;

    //id of this contract for metadata server
    uint256 public contractId;

    //is permanently closed
    bool public isClosed = false;

    //baseURI for metadata server
    string public baseURI;

    //   //name of creator
    //   string public creatorName;

    string public nameOfCreator;

    // //nifty registry contract
    // address public niftyRegistryContract =
    //     0x6e53130dDfF21E3BC963Ee902005223b9A202106;

    // //master builder - ONLY DOES STATIC CALLS
    // address public masterBuilderContract =
    //     0x6EFB06cF568253a53C7511BD3c31AB28BecB0192;

    //registry and master builder contract, testing
    address public niftyRegistryContract;
    address public masterBuilderContract;

    using Counters_0 for Counters_0.Counter;

    //MAPPINGS

    //mappings for token Ids
    mapping(uint256 => Counters_0.Counter) public _numNiftyMinted;
    mapping(uint256 => uint256) public _niftyPrice;
    mapping(uint256 => string) public _niftyIPFSHashes;
    mapping(uint256 => bool) public _IPFSHashHasBeenSet;

    //EVENTS

    //purchase + creation events
    event NiftyPurchased(address _buyer, uint256 _amount, uint256 _tokenId);
    event NiftyCreated(address new_owner, uint256 _niftyType, uint256 _tokenId);

    //CONSTRUCTOR FUNCTION

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 contract_id,
        uint256 num_nifties,
        string memory base_uri,
        string memory name_of_creator,
        address _niftyRegistryContract,
        address _masterBuilderContract
    ) public ERC721Full_0(_name, _symbol) {
        //set local variables based on inputs
        contractId = contract_id;
        numNiftiesCurrentlyInContract = num_nifties;
        baseURI = base_uri;
        nameOfCreator = name_of_creator;
        niftyRegistryContract = _niftyRegistryContract;
        masterBuilderContract = _masterBuilderContract;

        //offset starts at 1 - there is no niftyType of 0
        //   for (uint i=0; i<(num_nifties); i++) {
        //       _numNiftyPermitted[i+1] = nifty_quantities[i];
        //   }
    }

    function setNiftyIPFSHash(uint256 niftyType, string memory ipfs_hash)
        public
        onlyValidSender
    {
        //can only be set once
        if (_IPFSHashHasBeenSet[niftyType] == true) {
            revert("Can only be set once");
        } else {
            _niftyIPFSHashes[niftyType] = ipfs_hash;
            _IPFSHashHasBeenSet[niftyType] = true;
        }
    }

    function closeContract() public onlyValidSender {
        //permanently close this open edition
        isClosed = true;
    }

    function giftNiftyOriginal(address collector_address, uint256 niftyType)
        public
        onlyValidSender
    {
        //master for static calls
        BuilderMaster_0 bm = BuilderMaster_0(masterBuilderContract);
        _numNiftyMinted[niftyType].increment();
        //check if this collection is closed
        if (isClosed == true) {
            revert("This contract is closed!");
        }
        //mint a nifty
        uint256 specificTokenId = _numNiftyMinted[niftyType].current();
        uint256 tokenId = bm.encodeTokenId(
            contractId,
            niftyType,
            specificTokenId
        );
        string memory tokenIdStr = bm.uint2str(tokenId);
        string memory tokenURI = bm.strConcat(baseURI, tokenIdStr);
        string memory ipfsHash = _niftyIPFSHashes[niftyType];

        //mint token
        _mint(collector_address, tokenId);
        _setTokenURI(tokenId, tokenURI);
        _setTokenIPFSHash(tokenId, ipfsHash);
        //do events
        emit NiftyCreated(collector_address, niftyType, tokenId);
    }
}
