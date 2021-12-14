// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title ERC-721 Non-Fungible Token Standard
/// @dev See https://eips.ethereum.org/EIPS/eip-721
contract ERC721 {
    /*
    Building out a minting function:
        a. NFT to point to an address.
        b. Keep track of token IDs.
        c. Keep track of token owners' addresses to token IDs.
        d. Keep track of how many tokens an owner address has.
        e. Create an event that emits a transfer log:
            contract address, where it is being minted to, the id.
    */

    /// Mapping from token id to the owner
    mapping(uint256 => address) private _tokenOwner;

    /// Mapping from owner to number of owned tokens;
    mapping(address => uint256) private _ownedTokensCount;
}
