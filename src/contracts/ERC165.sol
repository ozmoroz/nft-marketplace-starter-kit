// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/IERC165.sol";

contract ERC165 is IERC165 {
    /// hash table to keep track of contract fingerpring data of byte function conversions
    mapping(bytes4 => bool) private supportedInterfaces;

    /// @notice Query if a contract implements an interface
    /// @param interfaceID The interface identifier, as specified in ERC-165
    /// @dev Interface identification is specified in ERC-165. This function
    ///  uses less than 30,000 gas.
    /// @return `true` if the contract implements `interfaceID` and
    ///  `interfaceID` is not 0xffffffff, `false` otherwise
    function supportsInterface(bytes4 interfaceID)
        external
        view
        override
        returns (bool)
    {
        return supportedInterfaces[interfaceID];
    }

    /// register the interface (comes from within)
    function registerInterface(bytes4 _interfaceId) internal {
        require(
            _interfaceId != bytes4(0xffffffff),
            "ERC165: Invalid interface."
        );
        supportedInterfaces[_interfaceId] = true;
    }

    constructor() {
        registerInterface(bytes4(keccak256("supportsInterface(bytes4)")));
    }
}
