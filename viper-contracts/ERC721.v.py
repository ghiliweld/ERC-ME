# Viper Port of MyToken
# THIS CONTRACT HAS NOT BEEN AUDITED!
# ERC20 details at:
# https://theethereum.wiki/w/index.php/ERC20_Token_Standard
# https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md


# Events of the token.
Transfer: __log__({_from: indexed(address), _to: indexed(address), _value: num256})
Approval: __log__({_owner: indexed(address), _spender: indexed(address), _value: num256})
NewProfile: __log__({_owner: indexed(address), _profileId: num256})


# Variables of the token.
name = "ERC-ME"
symbol: "ME"
totalSupply: num
balances: num[address]
allowed: num[address][address]

Profile: {
    name: string, # Must be unique
    handle: string, # Must be unique
    bio: string,
    publicKey: string, # stores a public key for our profile, still looking into it
    metadata: string[string],
    followerCount: num256,
    followingCount: num256,
    followers: num256[], # Tracks who is following this profile
    following: num256[], # Tracks who this profile is following
    createdBy: adress,
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


# Send `_value` tokens to `_to` from your account
@public
def transfer(_to: address, _amount: num(num256)) -> bool:

    if self.balances[msg.sender] >= _amount and \
       self.balances[_to] + _amount >= self.balances[_to]:

        self.balances[msg.sender] -= _amount  # Subtract from the sender
        self.balances[_to] += _amount  # Add the same to the recipient
        log.Transfer(msg.sender, _to, as_num256(_amount))  # log transfer event.

        return True
    else:
        return False


# Transfer allowed tokens from a specific account to another.
@public
def transferFrom(_from: address, _to: address, _value: num(num256)) -> bool:

    if _value <= self.allowed[_from][msg.sender] and \
       _value <= self.balances[_from]:

        self.balances[_from] -= _value  # decrease balance of from address.
        self.allowed[_from][msg.sender] -= _value  # decrease allowance.
        self.balances[_to] += _value  # incease balance of to address.
        log.Transfer(_from, _to, as_num256(_value))  # log transfer event.

        return True
    else:
        return False


# Allow _spender to withdraw from your account, multiple times, up to the _value amount.
# If this function is called again it overwrites the current allowance with _value.
@public
def approve(_spender: address, _amount: num(num256)) -> bool:

    self.allowed[msg.sender][_spender] = _amount
    log.Approval(msg.sender, _spender, as_num256(_amount))

    return True


# Get the allowence an address has to spend anothers' token.
@public
def allowance(_owner: address, _spender: address) -> num256:

return as_num256(self.allowed[_owner][_spender])
