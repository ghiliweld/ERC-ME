# The Profile (In-Depth)

Here's what our `Profile` `struct` looks like (see it @ MyNonFungibleToken.sol):
```
struct Profile {
        string name; // Must be unique
        string handle; // Must be unique
        string bio;
        string publicKey; // stores a public key for our profile, still looking into it
        mapping (string => string) public metadata;
        uint32 followerCount;
        uint32 followingCount;
        uint[] public followers; // Tracks who is following this profile
        uint[] public following; // Tracks who this profile is following
        address createdBy;
        uint64 dateCreated;
}
```
### The `name` string
The `name` property is pretty self-explanatory, it's the name of your `Profile`.
I'm currently looking into limiting which characters can be used for the `name` property (alphabetical characters only), but I might just allow people to use any characters they want (like @, #, $, ^ or even ~).

See all `name` related functions here(page not created yet).

### The `handle` string
The `handle` property is pretty self-explanatory, it's the handle of your `Profile` (think Twitter handle, your @ username).
I'm currently looking into limiting which characters can be used for the `handle` property (alphabetical characters only), but I might just allow people to use any characters they want (like @, #, $, ^ or even ~).

See all `handle` related functions here(page not created yet).

### The `bio` string
The `bio` property is pretty self-explanatory, it's your `Profile`'s bio.

See all `bio` related functions here(page not created yet).

### The `publicKey` string
The `publicKey` property is a string that can hold your public key in case you want to share it. It defaults to an empty string upon creation but can later be modified. I'm still looking into this should be incorporated thus this property is still subject to removal.

See all `publicKey` related functions here(page not created yet).

### The `metadata` mapping
The `metadata` property is a string to string mapping that can hold all kinds of miscellaneous information that can be accessed by Dapps. The `namespace` and `metaKey` make the key of this mapping and the `metaValue` is the value the key returns. The default `namespace` that is meant for use in any Dapp is the `global` namespace, but you can have metadata specific to a certain Dapp thanks to the `namespace` feature.

Here's an example of what that would look like:
```
metadata["namespace:metaKey"] = "metaValue";
metadata["global:website"] = "mywebsite.com";
metadata["global:location"] = "Montreal";
metadata["some game:guild name"] = "Da Best Guild";
```

See all `metadata` related functions here(page not created yet).

### The `followerCount` & `followingCount` uint32s
The `followerCount` and `followingCount` are `uint32`s that track how many followers you have and how many people you're following.

See all `followerCount` and `followingCount` related functions here(page not created yet).

### The `followers` & `following` arrays
The `followers` and `following` are `uint` arrays that track who exactly is following you and how you're following. `uint` is used since the profiles are tracked through their `profileId` and not their `name`.

See all `followers` and `following` related functions here(page not created yet).

### The `createdBy` address
The `createdBy` property stores the address of whoever created a `profile` (it might not necessarily be who currently owns the profile).

`createdBy` never changes therefore there are no functions for it.

### The `dateCreated` uint64
The `dateCreated` property stores a timestamp of when a `profile` was created on the blockchain.

`dateCreated` never changes therefore there are no functions for it.

## Suggestions?
If you have any suggestions for other properties we could add to the `Profile` struct feel free to leave an issue in this repository with the **feature request** label and I'll take a look at it.
