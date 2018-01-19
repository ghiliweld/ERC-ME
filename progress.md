# ERC-ME Progress
Ghilia Weldesselasie -- <a href='mailto:ghiliaweld@gmail.com'>ghiliaweld@gmail.com</a>

---
**11/01/2018**
- Wrote initial proposal(README.md) for ERC-ME

**12/01/2018**
- Started working on ERC-ME smart contracts.
- The contracts are separated in three: ERC721.sol, MyNonFungibleToken.sol and ERCME.sol.
- The first two are copied from [this repository](https://github.com/m0t0k1ch1/ERC721-token-sample), I'll be auditing them later.
- The last one (ERCME.sol) contains my own custom implementation needed for the ERC-ME platform.

**13/01/2018**
- Completed the three contracts to the best of my ability.
- Will be awaiting more feature ideas I could implement, otherwise my work is done and all that's left is auditing.

**14/01/2018**
- I've decided that I've progressed enough on this project to move it to it's own repo (this one!).
- I made a crucial mistake! I didn't add a way to track who follows who. Therefore, all that was being tracked was how many followers a person had but not who exactly was following them.
- I've kinda fixed it for now but I'm still having problems with the newUnfollow method. Will fix at a later date.
- 2 minutes before midnight, turns out I had a lot more to fix. I just finished doing so and hopefully there's no other bugs.

**15/01/2018**
- The fixes I made yesterday were at the loss of deferred updating but I have since then found a solution by introducing new functions called bulkFollow and bulkUnfollow.
- I've added new `view` functions to return a profile's properties and new function in ERCME.sol for the new properties.
- I've started taking suggestions via GitHub Issues. S/o to @momothereal and @CaudilloFranco.
- I replaced `ownedBy` with `createdBy` since I figured having a property for who the owner is when we already have a mapping that does that would be redundant. Knowing who created a profile could be useful however so that's why I didn't completely erase it and changed it instead.
- I replaced `bornOn` with `dateCreated` since that's clearer apparently.
- At the moment I'm currently looking into adding more features like `bio` and `key`(public key) and `metadata` properties to our `Profile` struct.
- `metadata` is lowkey a breakthrough. I hadn't considered storing string data in a mapping till @momothereal suggested it. I'm creating the functions for it right now.
- All done for today. I think I'm finally close to future-proofing this contract.

**17/01/2018**
- I created a wiki for the project. Check it out [here](https://github.com/ghiliweld/ERC-ME/wiki).

**18/01/2018**
- I recently decided to learn [Viper]() so to practice I'll be rewriting my contracts in Viper.
