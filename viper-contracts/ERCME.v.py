# ERCME contract rewritten in Viper

address public constant CONTROLLER = 0xcfde; // The controller of the contract aka me ** must be changed

event NewFollow(uint256 followingId, uint256 followedId);
event NewUnfollow(uint256 unfollowingId, uint256 unfollowedId);
event NameChange(uint256 profileId, string newName);
event HandleChange(uint256 profileId, string newHandle);
