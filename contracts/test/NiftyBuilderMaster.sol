/**
 *Submitted for verification at Etherscan.io on 2020-02-01
 */

pragma solidity ^0.8.0;

// import "http://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol";
// import "http://github.com/OpenZeppelin/openzeppelin-solidity/contracts/drafts/Counters.sol";

contract NiftyBuilderMaster {
    //MODIFIERS

    modifier onlyOwner() {
        require((msg.sender) == contractOwner);
        _;
    }

    //CONSTANTS

    // how many nifties this contract is selling
    // used for metadat retrieval
    uint256 public numNiftiesCurrentlyInContract;

    //id of this contract for metadata server
    uint256 public contractId;

    address public contractOwner;
    address public tokenTransferProxy;

    //multipliers to construct token Ids
    uint256 topLevelMultiplier = 100000000;
    uint256 midLevelMultiplier = 10000;

    //MAPPINGS

    //ERC20s that can mube used to pay
    mapping(address => bool) public ERC20sApproved;
    mapping(address => uint256) public ERC20sDec;

    //CONSTRUCTOR FUNCTION

    constructor() public {}

    function changeTokenTransferProxy(address newTokenTransferProxy)
        public
        onlyOwner
    {
        tokenTransferProxy = newTokenTransferProxy;
    }

    function changeOwnerKey(address newOwner) public onlyOwner {
        contractOwner = newOwner;
    }

    //functions to retrieve info from token Ids
    function getContractId(uint256 tokenId) public view returns (uint256) {
        return (uint256(tokenId / topLevelMultiplier));
    }

    function getNiftyTypeId(uint256 tokenId) public view returns (uint256) {
        uint256 top_level = getContractId(tokenId);
        return
            uint256(
                (tokenId - (topLevelMultiplier * top_level)) /
                    midLevelMultiplier
            );
    }

    function getSpecificNiftyNum(uint256 tokenId)
        public
        view
        returns (uint256)
    {
        uint256 top_level = getContractId(tokenId);
        uint256 mid_level = getNiftyTypeId(tokenId);
        return
            uint256(
                tokenId -
                    (topLevelMultiplier * top_level) -
                    (mid_level * midLevelMultiplier)
            );
    }

    function encodeTokenId(
        uint256 contractIdCalc,
        uint256 niftyType,
        uint256 specificNiftyNum
    ) public view returns (uint256) {
        return ((contractIdCalc * topLevelMultiplier) +
            (niftyType * midLevelMultiplier) +
            specificNiftyNum);
    }

    // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_1.5.sol
    function strConcat(
        string memory _a,
        string memory _b,
        string memory _c,
        string memory _d,
        string memory _e
    ) public view returns (string memory) {
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        bytes memory _bc = bytes(_c);
        bytes memory _bd = bytes(_d);
        bytes memory _be = bytes(_e);
        string memory abcde = new string(
            _ba.length + _bb.length + _bc.length + _bd.length + _be.length
        );
        bytes memory babcde = bytes(abcde);
        uint256 k = 0;
        for (uint256 i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
        for (uint256 i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
        for (uint256 i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
        for (uint256 i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
        for (uint256 i = 0; i < _be.length; i++) babcde[k++] = _be[i];
        return string(babcde);
    }

    function strConcat(
        string memory _a,
        string memory _b,
        string memory _c,
        string memory _d
    ) public view returns (string memory) {
        return strConcat(_a, _b, _c, _d, "");
    }

    function strConcat(
        string memory _a,
        string memory _b,
        string memory _c
    ) public view returns (string memory) {
        return strConcat(_a, _b, _c, "", "");
    }

    function strConcat(string memory _a, string memory _b)
        public
        view
        returns (string memory)
    {
        return strConcat(_a, _b, "", "", "");
    }

    function uint2str(uint256 _i)
        public
        pure
        returns (string memory _uintAsString)
    {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }
}
