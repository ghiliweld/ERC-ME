# Viper Port of ERC721.sol and MyNonFungibleToken.sol
# THIS CONTRACT HAS NOT BEEN AUDITED!


# Events of the token.
Transfer: __log__({_from: indexed(address), _to: indexed(address), _profileId: num256})
Approval: __log__({_owner: indexed(address), _approved: indexed(address), _profileId: num256})
NewProfile: __log__({_owner: indexed(address), _profileId: num256})


# Variables of the token.
name = "ERC-ME"
symbol = "ME"
totalSupply: num
balances: num[address]
allowed: num[address][address]

Profile: public({
    name: bytes, # Must be unique
    handle: bytes, # Must be unique
    bio: bytes32,
    publicKey: bytes32, # stores a public key for our profile, still looking into it
    metadata: bytes[bytes32],
    followerCount: num256,
    followingCount: num256,
    followers: num256[], # Tracks who is following this profile
    following: num256[], # Tracks who this profile is following
    createdBy: address,
    dateCreated: timestamp,
})

profiles: public(Profile[]) # An array of profiles tied to a profileIds (array index). Is this how it's done?

profileIndexToOwner: public(address[num256])
ownershipProfileCount: public(num256[adress])
profileIndexToApproved: public(address[num256]) # Still don't know why approved is a thing...

# THE FUNCTIONS

# What is the profile balance of a particular account?
@public
@constant
def balanceOf(_owner: address) -> (num256):

    return as_num256(ownershipProfileCount[_owner])


# What profile is this address the owner of?
@public
@constant
def ownerOf(_profileId: num256) -> (address):

    owner = profileIndexToOwner[_profileId]
    assert owner != address(0)
    return owner

# Return total supply of token.
@public
@constant
def totalSupply() -> (num256):

    return as_num256(len(profiles))


@private
@constant
def _owns(_claimant: address, _profileId: num256) -> (bool):

    return (profileIndexToOwner[_profileId] == _claimant)

@private
@constant
def _approvedFor(_claimant: address, _profileId: num256) -> (bool):

    return (profileIndexToApproved[_profileId] == _claimant)

@private
def _approve(_to: address, _profileId: num256):

    profileIndexToApproved[_profileId] = _to
    log.Approval(profileIndexToOwner[_profileId], profileIndexToApproved[_profileId], _profileId)

@public
def approve(_to: address, _profileId: num256):

    assert _owns(msg.sender, _profileId)
    _approve(_to, _profileId)

# Send `_value` tokens to `_to` from your account
@private
def _transfer( _from: address, _to: address, _profileId: num256):

    ownershipProfileCount[_to] += 1
    profileIndexToOwner[_profileId] = _to
    if _from != address(0):
        ownershipProfileCount[_from] -= 1
        delete profileIndexToApproved[_profileId]

    log.Transfer(_from, _to, _profileId)

@public
def transfer(_to: address, _profileId: num256):

    assert _to != address(0)
    assert _to != msg.sender
    assert _owns(msg.sender, _profileId))

    _transfer(msg.sender, _to, _profileId)

# Transfer allowed tokens from a specific account to another.
@public
def transferFrom(_to: address, _profileId: num256):

    assert _to != address(0)
    assert _to != msg.sender
    assert _approvedFor(msg.sender, _profileId)
    assert _owns(msg.sender, _profileId))

    _transfer(msg.sender, _to, _profileId)

@private
def _mint(_creator: address, _name: bytes, _handle: bytes):

    profile: Profile
    profile.name = _name
    profile.handle = _handle
    profile.followerCount = 0
    profile.followingCount = 0
    profile.createdBy = _creator
    profile.dateCreated = block.timestamp

    profileId: num = profiles.append(profile) - 1;

    log.NewProfile(_creator, _profileId)
    _transfer(0, _creator, profileId)

@public
@constant
def profilesOfOwner(_owner: address) -> (num256[]):

    balance: num256 = balanceOf(_owner)

    if balance == 0
        return num256[0]
    else:
        result: num256[balance]
        uint256 maxprofileId = totalSupply()
        idx: num256 = 0

        profileId: num256
        for profileId in range(0, maxprofileId)
            if profileIndexToOwner[profileId] == _owner:
                result[idx] = profileId
                idx += 1

    return result

@public
@constant
def getProfile(_profileId: num256) -> (name: bytes, handle: bytes, bio: bytes32, publiKey: bytes32,
metadata: bytes[bytes32], followerCount: num256, followingCount: num256, followers: num256[],
following num256[], createdBy: address, dateCreated: timestamp):

    profile: Profile = profiles[_profileId]
    name: bytes = profile.name
    handle: bytes = profile.handle
    bio: bytes32 = profile.bio
    publicKey: bytes32 = profile.publicKey
    metadata: bytes[bytes32] = profile.metadata
    followerCount: num256 = profile.followerCount
    followingCount: num256 = profile.followingCount
    followers: num256[] = profile.followers
    following: num256[] = profile.following
    createdBy: adress = profile.createdBy
    dateCreated: timestamp = profile.dateCreated

@public
@constant
def getProfileName(_profileId: num256) -> (name: bytes):

    profile: Profile = profiles[_profileId]
    name: bytes = profile.name

@public
@constant
def getProfileHandle(_profileId: num256) -> (handle: bytes):

    profile: Profile = profiles[_profileId]
    handle: bytes = profile.handle

@public
@constant
def getProfileBio(_profileId: num256) -> (bio: bytes32):

    profile: Profile = profiles[_profileId]
    bio: bytes32 = profile.bio

@public
@constant
def getProfilePublicKey(_profileId: num256) -> (publiKey: bytes32):

    profile: Profile = profiles[_profileId]
    publiKey: bytes32 = profile.publiKey

@public
@constant
def getAllProfileMetadata(_profileId: num256) -> (metadata: bytes[bytes32]):

    profile: Profile = profiles[profileId]
    metadata: bytes[bytes32] = profile.metadata

@public
@constant
def getSpecificProfileMetadata(_profileId: num256, _namespace: bytes, _metaKey: bytes ) -> (metaValue: bytes):

    profile: Profile = profiles[_profileId]
    metaValue: bytes = profile.metadata[_namespace + ":" + _metaKey]

@public
@constant
def getProfileFollowerCount(_profileId: num256) -> (followerCount: num256):

    profile: Profile = profiles[_profileId]
    followerCount: num256 = profile.followerCount

@public
@constant
def getProfileFollowers(_profileId: num256) -> (followers: num256[]):

    profile: Profile = profiles[_profileId]
    followers: num256[] = profile.followers

@public
@constant
def getProfileFollowingCount(_profileId: num256) -> (followingCount: num256):

    profile: Profile = profiles[_profileId]
    followingCount: num256 = profile.followingCount

@public
@constant
def getProfileFollowings(_profileId: num256) -> (following: num256[]):

    profile: Profile = profiles[_profileId]
    following: num256[] = profile.following

@public
@constant
def getProfileCreator(_profileId: num256) -> (creator: address):

    profile: Profile = profiles[_profileId]
    creator: address = profile.createdBy

@public
@constant
def getProfileDateOfCreation(_profileId: num256) -> (dateOfCreation: timestamp):

    profile: Profile = profiles[_profileId]
    dateOfCreation: timestamp = profile.dateCreated
