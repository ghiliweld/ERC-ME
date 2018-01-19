# ERCME contract rewritten in Viper

CONTROLLER: public(address) = 0xcfde; # The controller of the contract aka me ** must be changed

ProfileDestroyed: __log__({_owner: address, _profileId: num256})
NewFollow: __log__({_followingId: num256, _followedId: num256})
NewUnfollow: __log__({_unfollowingId: num256, _unfollowedId: num256})
NameChange: __log__({_profileId: num256, newName: bytes})
HandleChange: __log__({_profileId: num256, newHandle: bytes})

@private
@constant
def _checkUniqueName(_name: bytes) -> (bool):
    for i in range(0, len(profiles))
        if sha3(_name) == sha3(profiles[i].name)
            return False

    return True

@private
@constant
def _checkUniqueHandle(_handle: bytes) -> (bool):
    for i in range(0, len(profiles))
        if sha3(_handle) == sha3(profiles[i].handle)
            return False

    return True

@public
@payable
def createProfile(name: bytes, handle: bytes):

    assert name != ""
    assert handle != ""
    assert _checkUniqueName(name)
    assert _checkUniqueHandle(handle)

    CONTROLLER.transfer(msg.value)

    _mint(msg.sender, name, handle)

@public
def deleteProfile(profileId: num256):

    assert _owns(msg.sender, profileId)
    del profiles[profileId]
    log.ProfileDestroyed(msg.sender, profileId)
