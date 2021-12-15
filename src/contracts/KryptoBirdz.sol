// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721Connector.sol";

contract KryptoBird is ERC721Connector {
    // Array to store our NFTs
    string[] public kryptoBirdz;

    mapping(string => bool) isKryptoBirdExist;

    function mint(string memory _kryptoBird) public {
        require(
            !isKryptoBirdExist[_kryptoBird],
            "Error: KryptoBird already exists"
        );

        kryptoBirdz.push(_kryptoBird);
        uint256 id = kryptoBirdz.length - 1;
        super.mint(msg.sender, id);

        // Mark this KryptoBird as already minted
        isKryptoBirdExist[_kryptoBird] = true;
    }

    constructor() ERC721Connector("KryptoBird", "KBIRDZ") {}
}
