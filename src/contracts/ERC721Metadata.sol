// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/IERC721Metadata.sol";
import "./ERC165.sol";

/// Metadata for ERC-721  Non-Fungible Token Standard
/// @dev See https://eips.ethereum.org/EIPS/eip-721
contract ERC721Metadata is IERC721Metadata, ERC165 {
    string private _name;
    string private _symbol;

    constructor(string memory named, string memory symboled) {
        _name = named;
        _symbol = symboled;
        registerInterface(
            bytes4(keccak256("name(bytes4)") ^ keccak256("symbol(bytes4)"))
        );
    }

    /** name getter */
    function name() external view override returns (string memory) {
        return _name;
    }

    /** sumbol getter */
    function symbol() external view override returns (string memory) {
        return _symbol;
    }
}
