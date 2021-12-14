// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// Metadata for ERC-721  Non-Fungible Token Standard
/// @dev See https://eips.ethereum.org/EIPS/eip-721
contract ERC721Metadata {
    string private _name;
    string private _symbol;

    constructor(string memory named, string memory symboled) {
        _name = named;
        _symbol = symboled;
    }

    /** name getter */
    function name() external view returns (string memory) {
        return _name;
    }

    /** sumbol getter */
    function symbol() external view returns (string memory) {
        return _symbol;
    }
}
