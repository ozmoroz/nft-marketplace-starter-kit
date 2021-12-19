// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC165.sol";

import "./interfaces/IERC721.sol";

/// @title ERC-721 Non-Fungible Token Standard
/// @dev See https://eips.ethereum.org/EIPS/eip-721
contract ERC721 is ERC165, IERC721 {
    /// Mapping from token id to the owner
    mapping(uint256 => address) private tokenOwner;

    /// Mapping from owner to number of owned tokens;
    mapping(address => uint256) private ownedTokensCount;

    /// Maping of tokens to approved addresses
    mapping(uint256 => address) private tokenApprovals;

    constructor() {
        registerInterface(
            bytes4(
                keccak256("balanceOf(bytes4)") ^
                    keccak256("ownerOf(bytes4)") ^
                    keccak256("function transferFrom(bytes4)")
            )
        );
    }

    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param _owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zero
    function balanceOf(address _owner) public view override returns (uint256) {
        require(_owner != address(0), "ERC721: Must be a valid address.");
        return ownedTokensCount[_owner];
    }

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint256 _tokenId) public view override returns (address) {
        address owner = tokenOwner[_tokenId];
        require(
            owner != address(0),
            "ERC721: Token owner must be a valid address."
        );
        return owner;
    }

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
    function mint(address _to, uint256 _tokenId) internal virtual {
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

    // this is not safe!
    function _transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) internal {
        require(
            _to != address(0),
            "Error - ERC721 Transfer to the zero address"
        );
        require(
            ownerOf(_tokenId) == _from,
            "Trying to transfer a token the address does not own!"
        );

        ownedTokensCount[_from]--;
        ownedTokensCount[_to]++;

        tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable {
        require(isApprovedOrOwner(msg.sender, _tokenId));
        _transferFrom(_from, _to, _tokenId);
    }

    /// @notice Change or reaffirm the approved address for an NFT
    /// @dev The zero address indicates there is no approved address.
    ///  Throws unless `msg.sender` is the current NFT owner, or an authorized
    ///  operator of the current owner.
    /// @param _approved The new approved NFT controller
    /// @param _tokenId The NFT to approve
    function approve(address _approved, uint256 _tokenId) external payable {
        // 1. require that the person approving is the owner.
        // 2. We are approving an address to a token (tokenId).
        // 3. Require that we can't approve sending tokens to ourselves (tokens of the owner to the current caller)
        // 4. Update the map of the approval addresses.

        address owner = ownerOf(_tokenId);
        require(_approved != owner, "Error: Approval to the current owner");
        require(
            msg.sender == owner,
            "Error: Message sender must be an owner of the token."
        );
        tokenApprovals[_tokenId] = _approved;
        emit Approval(owner, _approved, _tokenId);
    }

    // Is the address an owner or an approver of the token?
    function isApprovedOrOwner(address _spender, uint256 _tokenId)
        internal
        view
        returns (bool)
    {
        require(exists(_tokenId), "Error: Token does not exist.");
        address owner = ownerOf(_tokenId);
        return (_spender == owner || _spender == tokenApprovals[_tokenId]);
    }
}
