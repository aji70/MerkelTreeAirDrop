// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "solmate/utils/MerkleProofLib.sol";
import "lib/solmate/src/tokens/ERC1155.sol";

contract Merkle is ERC1155 {
    bytes32 root;

    constructor(bytes32 _root) {
        root = _root;
    }

    // Function to mint new tokens
    // function mint(address account, uint256 id, uint256 amount) external {
    //     _mint(account, id, amount, "");
    // }

    mapping(address => bool) public hasClaimed;

    function uri(
        uint256 id
    ) public view virtual override returns (string memory) {
        return "";
    }

    function claim(
        address _claimer,
        uint _amount,
        uint256 id,
        bytes32[] calldata _proof
    ) external returns (bool success) {
        require(!hasClaimed[_claimer], "already claimed");
        bytes32 leaf = keccak256(abi.encodePacked(_claimer, _amount, id));
        bool verificationStatus = MerkleProofLib.verify(_proof, root, leaf);
        require(verificationStatus, "not whitelisted");
        hasClaimed[_claimer] = true;
        _mint(_claimer, id, _amount, "");
        success = true;
    }
}
