// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./NiftyBuilderInstance_1.sol";

contract BuilderShop_1 {
    address[] builderInstances;
    uint256 contractId = 0;

    //nifty registry is hard coded
    //address niftyRegistryContract = 0x6e53130dDfF21E3BC963Ee902005223b9A202106;

    address public niftyRegistryContract;
    address public masterBuilderAddress;

    constructor(address niftyRegistryAddress, address _masterBuilderAddress) {
        niftyRegistryContract = niftyRegistryAddress;
        masterBuilderAddress = _masterBuilderAddress;
    }

    modifier onlyValidSender() {
        INiftyRegistry_1 nftg_registry = INiftyRegistry_1(
            niftyRegistryContract
        );
        bool is_valid = nftg_registry.isValidNiftySender(msg.sender);
        require(is_valid == true);
        _;
    }

    mapping(address => bool) public BuilderShops;

    function isValidBuilderShop(address builder_shop)
        public
        view
        returns (bool isValid)
    {
        //public function, allowing anyone to check if a contract address is a valid nifty gateway contract
        return (BuilderShops[builder_shop]);
    }

    event BuilderInstanceCreated(
        address new_contract_address,
        uint256 contractId
    );

    function createNewBuilderInstance(
        string memory _name,
        string memory _symbol,
        uint256 num_nifties,
        string memory token_base_uri,
        string memory creator_name,
        address _niftyRegistryContract,
        address _masterBuilderContract
    ) public returns (NiftyBuilderInstance_1 tokenAddress) {
        // <- must replace this !!!
        //public onlyValidSender returns (NiftyBuilderInstance tokenAddress) {

        contractId = contractId + 1;
        niftyRegistryContract = _niftyRegistryContract;
        masterBuilderAddress = _masterBuilderContract;

        NiftyBuilderInstance_1 new_contract = new NiftyBuilderInstance_1(
            _name,
            _symbol,
            contractId,
            num_nifties,
            token_base_uri,
            creator_name,
            niftyRegistryContract,
            masterBuilderAddress
        );

        address externalId = address(new_contract);

        BuilderShops[externalId] = true;

        emit BuilderInstanceCreated(externalId, contractId);

        return (new_contract);
    }
}
