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
