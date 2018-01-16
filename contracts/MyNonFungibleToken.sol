pragma solidity 0.4.19;

import "./ERC721.sol";


contract MyNonFungibleToken is ERC721 {
  /*** CONSTANTS ***/

    string public constant NAME = "ERC-ME";
    string public constant SYMBOL = "ME";

    struct Profile {
        string name; // Must be unique
        string handle; // Must be unique
        string bio;
        string key; // stores a public key for our profile, still looking into it
        mapping (string => string) public metadata;
        uint32 followerCount;
        uint32 followingCount;
        uint[] public followers; // Tracks who is following this profile
        uint[] public following; // Tracks who this profile is following
        address createdBy;
        uint64 dateCreated;
    }

    Profile[] public profiles;

    mapping (uint256 => address) public profileIndexToOwner;
    mapping (address => uint8) public ownershipProfileCount;
    mapping (uint256 => address) public profileIndexToApproved; // Why is approval a thing, why is this important?

    event NewProfile(address owner, uint256 profileId);

    function _owns(address _claimant, uint256 _profileId) internal view returns (bool) {
        return profileIndexToOwner[_profileId] == _claimant;
    }

    function _approvedFor(address _claimant, uint256 _profileId) internal view returns (bool) {
        return profileIndexToApproved[_profileId] == _claimant;
    }

    function _approve(address _to, uint256 _profileId) internal {
        profileIndexToApproved[_profileId] = _to;

        Approval(profileIndexToOwner[_profileId], profileIndexToApproved[_profileId], _profileId);
    }

    function _transfer(address _from, address _to, uint256 _profileId) internal {
        ownershipProfileCount[_to]++;
        profileIndexToOwner[_profileId] = _to;

        if (_from != address(0)) {
            ownershipProfileCount[_from]--;
            delete profileIndexToApproved[_profileId];
        }

        TransferEvent(_from, _to, _profileId);
    }

    function _mint(address _creator, string _name, string _handle) internal returns (uint256 profileId) {
        Profile memory profile = Profile({
            name: _name,
            handle: _handle,
            followerCount: 0,
            followingCount: 0,
            createdBy: _creator,
            dateCreated: uint64(now)
        });
        profileId = profiles.push(profile) - 1;

        NewProfile(_creator, profileId);

        _transfer(0, _creator, profileId);
    }


    function totalSupply() public view returns (uint256) {
        return profiles.length;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return ownershipProfileCount[_owner];
    }

    function ownerOf(uint256 _profileId) external view returns (address owner) {
        owner = profileIndexToOwner[_profileId];

        require(owner != address(0));
    }

    function approve(address _to, uint256 _profileId) external {
        require(_owns(msg.sender, _profileId));

        _approve(_to, _profileId);
    }

    function transfer(address _to, uint256 _profileId) external {
        require(_to != address(0));
        require(_to != address(this));
        require(_owns(msg.sender, _profileId));

        _transfer(msg.sender, _to, _profileId);
    }

    function transferFrom(address _from, address _to, uint256 _profileId) external {
        require(_to != address(0));
        require(_to != address(this));
        require(_approvedFor(msg.sender, _profileId));
        require(_owns(_from, _profileId));

        _transfer(_from, _to, _profileId);
    }

    function profilesOfOwner(address _owner) external view returns (uint256[]) {
        uint256 balance = balanceOf(_owner);

        if (balance == 0) {
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](balance);
            uint256 maxprofileId = totalSupply();
            uint256 idx = 0;

            uint256 profileId;
            for (profileId = 1; profileId <= maxprofileId; profileId++) {
                if (profileIndexToOwner[profileId] == _owner) {
                    result[idx] = profileId;
                    idx++;
                }
            }
        }

        return result;
    }

    function getProfile(uint256 _profileId) external view returns (string name, string handle, string bio, string key,
        mapping metadata, uint32 followerCount, uint32 followingCount, uint[] followers,
        uint[] following, address createdBy, uint64 dateCreated) {
        // ^^ ** Is that how you return a mapping type?

        Profile memory profile = profiles[_profileId];
        name = profile.name;
        handle = profile.handle;
        bio = profile.bio;
        key = profile.key
        metadata = profile.metadata;
        followerCount = profile.followerCount;
        followingCount = profile.followingCount;
        followers = profile.followers;
        following = profile.following;
        createdBy = profile.createdBy;
        dateCreated = profile.dateCreated;
    }

    function getProfileName(uint256 _profileId) external view returns (string name) {

        Profile memory profile = profiles[_profileId];
        name = profile.name;
    }

    function getProfileHandle(uint256 _profileId) external view returns (string handle) {

        Profile memory profile = profiles[_profileId];
        handle = profile.handle;
    }

    function getProfileBio(uint256 _profileId) external view returns (string bio) {

        Profile memory profile = profiles[_profileId];
        bio = profile.bio;
    }

    function getAllProfileMetadata(uint256 _profileId) external view returns (mapping metadata) {
        //^^ ** Is that how you return a mapping type ?
        // returns the whole mapping
        Profile memory profile = profiles[_profileId];
        metadata = profile.metadata;
    }

    function getSpecificProfileMetadata(uint256 _profileId, string metaKey, string namespace) external view
    returns (string metaValue) {
        //^^ ** Is that how you return a mapping type ?
        // returns a specific element in the map
        // metaKey is the key (a string) we will be looking up. Ex: website
        //metaValue is the value that search will return. Ex: https://ghiliweld.github.io
        Profile memory profile = profiles[_profileId];
        metaValue = profile.metadata[namespace + ":" + metaKey];
    }

    function getProfileKey(uint256 _profileId) external view returns (string key) {

        Profile memory profile = profiles[_profileId];
        key = profile.key;
    }

    function getProfileFollowers(uint256 _profileId) external view returns (uint[] followers) {

        Profile memory profile = profiles[_profileId];
        followers = profile.followers;
    }

    function getProfileFollowerCount(uint256 _profileId) external view returns (uint32 followerCount) {

        Profile memory profile = profiles[_profileId];
        followerCount = profile.followerCount;
    }

    function getProfileFollowings(uint256 _profileId) external view returns (uint[] following) {

        Profile memory profile = profiles[_profileId];
        following = profile.following;
    }

    function getProfileFollowingCount(uint256 _profileId) external view returns (uint32 followingCount) {

        Profile memory profile = profiles[_profileId];
        followingCount = profile.followingCount;
    }

    function getProfileDateOfCreation(uint256 _profileId) external view returns (uint64 dateOfCreation) {

        Profile memory profile = profiles[_profileId];
        dateOfCreation = profile.dateCreated;
    }

    function getProfileCreator(uint256 _profileId) external view returns (address creator) {

        Profile memory profile = profiles[_profileId];
        creator = profile.createdBy;
    }
}
