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

@private
def _newFollow(_initiatorId: num256, _targetId: num256):

    assert _owns(msg.sender, _initiatorId)
    assert _initiatorId != _targetId) # make sure we're not following ourselves
    assert profiles[_initiatorId].following.find(_targetId) < 0 # make sure we're not refollowing someone
    profiles[_initiatorId].following.append(_targetId)
    profiles[_targetId].followers.append(_initiatorId);
    # ^^ ** Does this work?

    # And now for the follower counts
    profiles[_initiatorId].followingCount = len(profiles[_initiatorId].following)
    profiles[_targetId].followerCount = len(profiles[_targetId].followers)
    # ^^ ** Does this work?

    log.NewFollow(_initiatorId, _targetId)

@private
def _newUnfollow(_initiatorId: num256, _targetId: num256):

    assert _owns(msg.sender, _initiatorId)
    assert _initiatorId != _targetId) # make sure we're not following ourselves
    assert profiles[_initiatorId].following.find(_targetId) >= 0 # make sure we're not refollowing someone
    del profiles[_initiatorId].following[profiles[_initiatorId].following.find(_targetId)];
    del profiles[_targetId].followers[profiles[_targetId].followers.find(_initiatorId)];
    # ^^ ** Does this work?

    # And now for the follower counts
    profiles[_initiatorId].followingCount = len(profiles[_initiatorId].following)
    profiles[_targetId].followerCount = len(profiles[_targetId].followers)
    # ^^ ** Does this work?

    log.NewUnfollow(_initiatorId, _targetId)

@public
def bulkFollow(initiatorId: num256, multipleTargetIds: num256[]):

    for i in range(0, multipleTargetIds)
        _newFollow(initiatorId, multipleTargetIds[i])

@public
def bulkUnfollow(initiatorId: num256, multipleTargetIds: num256[]):

    for i in range(0, multipleTargetIds)
        _newUnfollow(initiatorId, multipleTargetIds[i])

@public
def changeName(newName: bytes, profileId: num256):

    assert _owns(msg.sender, profileId)
    assert _checkUniqueName(newName)
    profiles[profileId].name = newName
    log.NameChange(profileId, newName)

@public
def changeHandle(newHandle: bytes, profileId: num256):

    assert _owns(msg.sender, profileId)
    assert _checkUniqueHandle(newHandle)
    profiles[profileId].handle = newHandle
    log.HandleChange(profileId, newHandle)

@public
def editBio(newBio: bytes, profileId: num256):

    assert _owns(msg.sender, profileId)
    profiles[profileId].bio = newBio

@public
def changeKey(newPublicKey: bytes32, profileId: num256):

    assert _owns(msg.sender, profileId)
    profiles[profileId].publicKey = newPublicKey

@public
def editMetadata(metaKey: bytes, metaValue: bytes, profileId: num256, namespace: bytes):

    assert _owns(msg.sender, profileId)
    assert namespace != "" # Makes sure namespace isn't an empty string
    assert metaKey != "" # Makes sure metaKey isn't an empty string
    profiles[profileId].metadata[namespace + ":" + metaKey] = metaValue

@public
def editGlobalMetadata(metaKey: bytes, metaValue: bytes, profileId: num256):

    assert _owns(msg.sender, profileId)
    assert metaKey != "" # Makes sure metaKey isn't an empty string
    profiles[profileId].metadata["global:" + metaKey] = metaValue

@public
def removeMetadata(metaKey: bytes, profileId: num256, namespace: bytes):

    assert _owns(msg.sender, profileId)
    del profiles[profileId].metadata[namespace + ":" + metaKey]

@public
def editGlobalMetadata(metaKey: bytes, metaValue: bytes, profileId: num256):

    assert _owns(msg.sender, profileId)
    del profiles[profileId].metadata["global:" + metaKey]
