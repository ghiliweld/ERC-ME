# MyNonFungibleToken contract rewritten in Viper

Profile: {
    name: string, # Must be unique
    handle: string, # Must be unique
    bio: string,
    public_key: string, # stores a public key for our profile, still looking into it
    metadata: string[string],
    follower_count: num256,
    following_count: num256,
    followers: num256[], # Tracks who is following this profile
    following: num256[], # Tracks who this profile is following
    created_by: adress,
    date_created: timestamp,
}
