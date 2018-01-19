# Viper Port of MyToken
# THIS CONTRACT HAS NOT BEEN AUDITED!
# ERC20 details at:
# https://theethereum.wiki/w/index.php/ERC20_Token_Standard
# https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md


# Events of the token.
Transfer: __log__({_from: indexed(address), _to: indexed(address), _profileId: num256})
Approval: __log__({_owner: indexed(address), _approved: indexed(address), _profileId: num256})
NewProfile: __log__({_owner: indexed(address), _profileId: num256})


# Variables of the token.
name = "ERC-ME"
symbol: "ME"
totalSupply: num
balances: num[address]
allowed: num[address][address]

Profile: {
    name: bytes, # Must be unique
    handle: bytes, # Must be unique
    bio: bytes,
    publicKey: bytes, # stores a public key for our profile, still looking into it
    metadata: bytes[bytes],
    followerCount: num256,
    followingCount: num256,
    followers: num256[], # Tracks who is following this profile
    following: num256[], # Tracks who this profile is following
    createdBy: address,
    dateCreated: timestamp,
}

profiles: public(Profile[]) # An array of profiles tied to a profileIds (array index). Is this how it's done?
totalSupply = public(len(profiles))

profileIndexToOwner: public(address[num256])
ownershipProfileCount: public(num256[adress])
profileIndexToApproved: public(address[num256]) # Still don't know why approved is a thing...

# THE FUNCTIONS

# What is the profile balance of a particular account?
@public
@constant
def balanceOf(_owner: address) -> num256:

    return as_num256(ownershipProfileCount[_owner])


# What profile is this address the owner of?
@public
@constant
def ownerOf(_profileId: num256) -> adress:

    owner = profileIndexToOwner[_profileId]
    return owner
    require(owner != address(0))


# Return total supply of token.
@public
@constant
def totalSupply() -> num256:

    return as_num256(totalSupply)


@private
@constant
def _owns(_claimant: address, _profileId: num256) -> bool:

    return (profileIndexToOwner[_profileId] == _claimant)

@private
@constant
def _approvedFor(_claimant: address, _profileId: num256) -> bool:

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
def profilesOfOwner(_owner: address) -> num256[]:

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
