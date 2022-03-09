// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface BuilderMaster_0 {
    function getContractId(uint256 tokenId) external view returns (uint256);

    function getNiftyTypeId(uint256 tokenId) external view returns (uint256);

    function getSpecificNiftyNum(uint256 tokenId)
        external
        view
        returns (uint256);

    function encodeTokenId(
        uint256 contractId,
        uint256 niftyType,
        uint256 specificNiftyNum
    ) external view returns (uint256);

    function strConcat(
        string memory _a,
        string memory _b,
        string memory _c,
        string memory _d,
        string memory _e
    ) external view returns (string memory);

    function strConcat(
        string memory _a,
        string memory _b,
        string memory _c,
        string memory _d
    ) external view returns (string memory);

    function strConcat(
        string memory _a,
        string memory _b,
        string memory _c
    ) external view returns (string memory);

    function strConcat(string memory _a, string memory _b)
        external
        view
        returns (string memory);

    function uint2str(uint256 _i)
        external
        view
        returns (string memory _uintAsString);
}
