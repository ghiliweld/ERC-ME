pragma solidity 0.4.19;

// If the code breaks then revert back to version f28db1d

import "./MyNonFungibleToken.sol";


contract ERCME is MyNonFungibleToken {

    address public constant CONTROLLER = 0xcfde; // The controller of the contract aka me ** must be changed

    event NewFollow(uint256 followingId, uint256 followedId);
    event NewUnfollow(uint256 unfollowingId, uint256 unfollowedId);
    event NameChange(uint256 profileId, string newName);
    event HandleChange(uint256 profileId, string newHandle);

    function _checkUniqueName(string _name) internal view returns(bool) {
        // Loops through our profiles array to check if the name we want to use is already taken
        for (uint i = 0; i <= profiles.length; i++) {
            if (keccak256(_name) == keccak256(profiles[i].name)) {
                return false;
            }
        }
        return true;
    }

    function _checkUniqueHandle(string _handle) internal view returns(bool) {
        // Loops through our profiles array to check if the handle we want to use is already taken
        for (uint i = 0; i <= profiles.length; i++) {
            if (keccak256(_handle) == keccak256(profiles[i].handle)) {
                return false;
            }
        }
        return true;
    }

    /* Profiles are free to create (except for the gas fee),
    but I want to be able to accept donations to the contract.
    Meaning that if someone choose to send some ETH my way, I want to be able to accept it.
    ** Is it possible to accept payments but for it not to be a mandatory part of the operation?
    i.e. Will the createProfile function still run if ETH is not sent to it ? */

    function createProfile(string name, string handle) external payable {
        require(_checkUniqueName(name));
        require(_checkUniqueHandle(handle));

        // Donation logic // If somebody decides to send a donation along with the function,
        // let the function accept and send it to my address.
        CONTROLLER.transfer(msg.value);

        // Mint the profile
        _mint(msg.sender, name, handle);
    }

    function _newFollow(uint256 _initiatorId, uint256 _targetId) internal {
        /* Triggered when somebody follows another person
        followIncrease is used when deferred updating is enabled
        A following is added to the initiator and a follower is added to the target */

        require(_owns(msg.sender, _initiatorId));
        require(_initiatorId == _targetId); // make sure we're not following ourselves
        require(profiles[_initiatorId].following.indexOf(_targetId) < 0); // make sure we're not refollowing someone
        profiles[_initiatorId].following.push(_targetId);
        profiles[_targetId].followers.push(_initiatorId);
        // ^^ ** Does this work?

        // And now for the follower counts
        profiles[_initiatorId].followingCount = profiles[_initiatorId].following.length;
        profiles[_targetId].followerCount = profiles[_targetId].followers.length;
        // ^^ ** Does this work?
        NewFollow(_initiatorId, _targetId);
    }

    function _newUnfollow(uint256 _initiatorId, uint256 _targetId) internal {
        /* Triggered when somebody unfollows another person
        A following is substracted from the initiator and a follower is substracted from the target */

        require(_owns(msg.sender, _initiatorId));
        require(_initiatorId != _targetId); // make sure we're not unfollowing ourselves
        require(profiles[_initiatorId].following.indexOf(_targetId) >= 0);
        // make sure we're not unfollowing someone we weren't following in the first place
        delete profiles[_initiatorId].following[profiles[_initiatorId].following.indexOf(_targetId)];
        delete profiles[_targetId].followers[profiles[_targetId].followers.indexOf(_initiatorId)];
        // ^^ ** Does this work?

        // And now for the follower counts
        profiles[_initiatorId].followingCount = profiles[_initiatorId].following.length;
        profiles[_targetId].followerCount = profiles[_targetId].followers.length;
        // ^^ ** Does this work?
        NewUnfollow(_initiatorId, _targetId);
    }
    // The 2 functions below will take care of deferred/bulk updating
    // The bulk functions will be the ones called even in the case of a single following
    // since newFollow/newUnfollow have been made internal.
    function bulkFollow(uint initiatorId, uint[] multipleTargetIds) external {
        for (uint8 i = 0; i <= multipleTargetIds.length; i++) {
            _newFollow(initiatorId, multipleTargetIds[i]);
        }
    }

    function bulkUnfollow(uint initiatorId, uint[] multipleTargetIds) external {
        for (uint8 i = 0; i <= multipleTargetIds.length; i++) {
            _newUnfollow(initiatorId, multipleTargetIds[i]);
        }
    }

    function changeName(string newName, uint256 profileId) external {
        require(_owns(msg.sender, profileId));
        require(_checkUniqueName(newName));
        profiles[profileId].name = newName;
        NameChange(profileId, newName);
    }

    function changeHandle(string newHandle, uint256 profileId) external {
        require(_owns(msg.sender, profileId));
        require(_checkUniqueHandle(newHandle));
        profiles[profileId].handle = newHandle;
        HandleChange(profileId, newHandle);
    }

    function editBio(string newBio, uint256 profileId) external {
        require(_owns(msg.sender, profileId));
        profiles[profileId].bio = newBio;
    }

    function changeKey(string newPublicKey, uint256 profileId) external {
        require(_owns(msg.sender, profileId));
        profiles[profileId].publicKey = newPublicKey;
    }

    function editMetadata(string metaKey, string metaValue, uint256 profileId, string namespace) external {
        require(_owns(msg.sender, profileId));
        // The code below works for both editing an existing key/value pair
        // and for creating a new pair as well
        // namespace is the app from which this metadata comes from. Ex: Social Dapp
        // ** Do default parameters work in Solidity?
        // metaKey is the key (a string) we will be looking up. Ex: website
        //metaValue is the value that search will return. Ex: https://ghiliweld.github.io
        // profiles[profileId].metadata["Social Dapp:website"] = "https://ghiliweld.github.io"
        profiles[profileId].metadata[namespace + ":" + metaKey] = metaValue;
    }
    // editGlobalMetadata and removeGlobalMetadata are subject to removal
    /* I'm deciding between makings seperate functions for global metadata or
    making global a standard the in the docs specification unless the Dapp needs to be specified.*/
    function editGlobalMetadata(string metaKey, string metaValue, uint256 profileId) external {
        require(_owns(msg.sender, profileId));
        profiles[profileId].metadata["global:" + metaKey] = metaValue;
    }

    function removeMetadata(string metaKey, uint256 profileId, string namespace) external {
        require(_owns(msg.sender, profileId));
        // The code below will delete a key/value pair from the metadata mapping
        delete profiles[profileId].metadata[namespace + ":" + metaKey];
        // ^^ ** Does delete work like this?
    }

    function removeGlobalMetadata(string metaKey, uint256 profileId) external {
        require(_owns(msg.sender, profileId));
        delete profiles[profileId].metadata["global:" + metaKey];
    }

}
