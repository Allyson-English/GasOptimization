// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface INiftyRegistry_0 {
    function isValidNiftySender(address sending_key)
        external
        view
        returns (bool);

    function isOwner(address owner_key) external view returns (bool);
}
