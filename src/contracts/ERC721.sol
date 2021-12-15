// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title ERC-721 Non-Fungible Token Standard
/// @dev See https://eips.ethereum.org/EIPS/eip-721
contract ERC721 {
    /// @dev This emits when ownership of any NFT changes by any mechanism.
    ///  This event emits when NFTs are created (`from` == 0) and destroyed
    ///  (`to` == 0). Exception: during contract creation, any number of NFTs
    ///  may be created and assigned without emitting Transfer. At the time of
    ///  any transfer, the approved address for that NFT (if any) is reset to none.
    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 indexed _tokenId
    );

    /// Mapping from token id to the owner
    mapping(uint256 => address) private tokenOwner;

    /// Mapping from owner to number of owned tokens;
    mapping(address => uint256) private ownedTokensCount;

    /// Verify whether the token already exists (has been minted)
    function exists(uint256 tokenId) internal view returns (bool) {
        // Return truthiness if the token owner's address is not zero
        address owner = tokenOwner[tokenId];
        return owner != address(0);
    }

    /*
    Building out a minting function:
        a. NFT to point to an address.
        b. Keep track of token IDs.
        c. Keep track of token owners' addresses to token IDs.
        d. Keep track of how many tokens an owner address has.
        e. Create an event that emits a transfer log:
            contract address, where it is being minted to, the id.
    */

    /// Minting function
    function mint(address _to, uint256 _tokenId) internal {
        require(_to != address(0), "ERC721: Minting address must not be zero.");
        require(
            !exists(_tokenId),
            "ERC721: The token has already been minted."
        );

        tokenOwner[_tokenId] = _to;
        ownedTokensCount[_to] += 1;

        // Emit ERC721 Transfer event
        // Ref: https://eips.ethereum.org/EIPS/eip-721
        emit Transfer(address(0), _to, _tokenId);
    }
}
