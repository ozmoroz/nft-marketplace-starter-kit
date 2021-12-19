// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/IERC721Enumerable.sol";
import "./ERC721.sol";

/// @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
/// @dev See https://eips.ethereum.org/EIPS/eip-721
///  Note: the ERC-165 identifier for this interface is 0x780e9d63.
/* is ERC721 */
contract ERC721Enumerable is IERC721Enumerable, ERC721 {
    /// Array of all tokens
    uint256[] private allTokens;

    /// Mapping of tokenId to the position in allTokens array
    mapping(uint256 => uint256) private allTokensIndex;

    /// Mapping of owner to the list of all token IDs
    mapping(address => uint256[]) private ownedTokens;

    /// Mapping of a token ID to the index of the owner token list
    mapping(uint256 => uint256) private ownedTokensIndex;

    constructor() {
        registerInterface(
            bytes4(
                keccak256("totalSupply(bytes4)") ^
                    keccak256("tokenByIndex(bytes4)") ^
                    keccak256("tokenOfOwnerByIndex(bytes4)")
            )
        );
    }

    /// @notice Count NFTs tracked by this contract
    /// @return A count of valid NFTs tracked by this contract, where each one of
    ///  them has an assigned and queryable owner not equal to the zero address
    function totalSupply() public view override returns (uint256) {
        return allTokens.length;
    }

    /// @notice Enumerate valid NFTs
    /// @dev Throws if `_index` >= `totalSupply()`.
    /// @param _index A counter less than `totalSupply()`
    /// @return The token identifier for the `_index`th NFT,
    ///  (sort order not specified)
    function tokenByIndex(uint256 _index)
        external
        view
        override
        returns (uint256)
    {
        require(
            _index < totalSupply(),
            "Error: Global supply index out of bounds"
        );
        return allTokens[_index];
    }

    /// @notice Enumerate NFTs assigned to an owner
    /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
    ///  `_owner` is the zero address, representing invalid NFTs.
    /// @param _owner An address where we are interested in NFTs owned by them
    /// @param _index A counter less than `balanceOf(_owner)`
    /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
    ///   (sort order not specified)
    function tokenOfOwnerByIndex(address _owner, uint256 _index)
        external
        view
        override
        returns (uint256)
    {
        require(
            _index < balanceOf(_owner),
            "Error: The index of owned tokens is out of bounds"
        );
        return ownedTokens[_owner][_index];
    }

    /// Minting function. We override mint function from ERC721
    function mint(address _to, uint256 _tokenId)
        internal
        virtual
        override(ERC721)
    {
        super.mint(_to, _tokenId);
        // a. Add tokens to the owner.
        // b. Add tokens to the total supply.
        addTokenToAllTokenEnumeration(_tokenId);
        addTokensToOwnerEnumeration(_to, _tokenId);
    }

    /// Add the token to all tokens enumetation and allTokensIndex mapping
    function addTokenToAllTokenEnumeration(uint256 _tokenId) private {
        allTokensIndex[_tokenId] = allTokens.length;
        allTokens.push(_tokenId);
    }

    // Add the token to the list of tokens owned by the address
    function addTokensToOwnerEnumeration(address _to, uint256 _tokenId)
        private
    {
        // a. Add address and token ID to ownedTokens.
        // b. Set ownedTokensIndex tokenId to adress of ownedToken position.
        // c. We want to execute this function with minting.
        ownedTokensIndex[_tokenId] = ownedTokens[_to].length;
        ownedTokens[_to].push(_tokenId);
    }
}
