// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "../contracts/HRChain.sol";

contract TestHRChain {
    HRChain hrChain = HRChain(DeployedAddresses.HRChain());

    // The id of the user that will be used for testing
    uint expectedUserId = 1;

    // The expected owner of the user is this contract
    address expectedOwner = address(this);

    // Testing the addUser() function
    function testUserCanAddUser() public {
        uint returnedId = hrChain.addUser(expectedUserId);
        Assert.equal(returnedId, expectedUserId, "Adding of the expected user should match what is returned.");
    }

    // Testing retrieval of a single user's owner
    function testGetOwnerAddressByUserId() public {
        address owner = hrChain.owners(expectedUserId);
        Assert.equal(owner, expectedOwner, "Owner of the expected user should be this contract");
    }

    // Testing retrieval of all user owners
    function testGetOwnerAddressByUserIdInArray() public {
        // Store owners in memory rather than contract's storage
        address[] memory owners = hrChain.getOwners();
        Assert.equal(owners[expectedUserId], expectedOwner, "Owner of the expected user should be this contract");
    }
}