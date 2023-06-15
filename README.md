# ZK
============

## Table of Contents

  * [Definitions](#definitions)
  * [Goals](#goals)
  * [Examples](#examples)
  * [Prerequisite Knowledge](#know)
  * [Build](#build)
  * [Use Cases](#use-cases)
  * [Real-World Usage](#real)
  * [References](#references)

### Definitions <a id="definitions"></a>

* SNARK - succinct proof that certain statement is true
    * (aka Succinct Non-Interactive Arguments of Knowledge)

### Goals <a id="goals"></a>

* Goal 
    * Short proof (only a few kB size)
    * Fast proof verification (in a few ms)

### Examples <a id="examples"></a>

* SNARK 
    * Examples
        * I know what a message m is
        * I want to proof to verifier that I know m by using a SNARK
        * I will use a SNARK to generate a proof `SHA256(m) = 0`
        * I will use the proof with message m and satisfy the property to verify that I know m

* zk-SNARK
    * Example
        * As per SNARK, however:
            * I don't want to reveal m to a verifier
            * I will use the proof with message m to satisfies the property to verify that I know m without revealing why the message m satisfies it or what the message m is 

### Prerequisite Knowledge <a id="know"></a>

#### Arithmetic Circuits

* Arithmetic Circuits with Prime numbers
    * Given a prime number `p > 2`
    * With a "Prime" Finite Field, set `F = { 0, ..., p - 1 }`
    * Use addition, multiplication modulo p operations
    * Define an Arithmetic Circuits on top of the Field
        * Where Arithmetic Circuits `C: Fn -> F` are DAGs (Directed Acyclic Graphs) where internal nodes (gates) that are labelled with an arithmetic operation (e.g. `+, -, *`), and inputs are the input labels and the constant of 1 (e.g. `1, x1, ..., xn`) as shown [here](https://youtu.be/h-94UhJLeck?t=451). Evaluation of the Arithmetic Circuit defines a n-variate polynomial with an evaluation recipe (e.g. `x1 * (x1 + x1 + 1) * (x2 - 1)`)
        * Where size of the Arithmetic Circuits equals the amount of gates `|C| = # gates levels in C`

* Arithmetic Circuits with Hashing
    * `Chash(h, m): outputs 0 iff SHA256(m) = h, else /= 0`
        * Where `h` (hash value), `m` (hash input `m`)
        * Implementation: `Chash(h, m): (h - SHA256(m)), |Chash| ~= 20K gates`

* Verification Circuit of a Signature
    * `Csig(pk, m, s): outputs 0 if s is valid ECDSA signature on m with respect to pk`
        * Where `pk` (public key), `m` (message), `s` (signature)

#### Argument Systems (for NP-problems)

##### What is an Argument System

* Arithmetic Circuit is Public
    * `C(x, w) -> F`
        * Where `C` is circuit
        * Where `x` (input) is public statement in `Fn`
        * Where `w` (input) is secret Witness in `Fm`
        * Where `F` is output element in Finite Field
        * note: Inputs `x` and `w` could be tuples or multiple elements
    * Prover
        * Inputs know `x` and `w`
        * Goal is to convince Verifier `V` there exists a Witness `Ǝw` of `C(x, w) = 0` by interacting until Accept/Reject statement
    * Verifier
        * Inputs known `x`
        * Does not know the Witness

##### Types of Argument Systems

### Build <a id="build"></a>

### Use Cases <a id="use-cases"></a>

* Private Tx (not reveal sender or amount)
* Solvency (chain provide private proof of solvency without revealing internal operations, anyone may verify proof is correct)
* Compliance (only reveal tx that are over US$10k to try to keep user data private)
* Taxes (proof that shows the amount of tax we submitted is consistent with the amount of tx we performed on-chain so not necessary to reveal finances to third-parties)
* Scalability (rollup systems where multiple tx processed in a batch then generate a proof that all tx are valid with only the proof posted on the blockchain, and verifiers on-chain only need to verify that the proof itself is correct, not all the individual tx)

TODO - https://youtu.be/h-94UhJLeck?t=604

### Real-World Usage <a id="real"></a>

* Blockchains with ZK Tx
    * Ethereum
        * Tornado Cash
    * Zcash
    * Iron Fish
    * Webb

    * Note: Anyone may verify that rules are being followed if public

* DApps with ZK
    * Aleo (run app, verify run correct, but with private code, private data, private interactors)
    * EZKL

## References <a id="references"></a>

* https://www.youtube.com/watch?v=h-94UhJLeck

* ZK Multiplier
    * https://medium.com/@yujiangtham/writing-a-zero-knowledge-dapp-fd7f936e2d43
    * https://github.com/ytham/zk_example_dapp

* ZK Battlezips
    * https://github.com/BattleZips/BattleZips-Circom

* ZK REPL
    * https://bounties.gitcoin.co/grants/5121/zkrepl-an-online-playground-for-zero-knowledge-cir

* Circom 2 Docs
    * https://docs.circom.io

* ZK Coin Flip
    * https://github.com/jstoxrocky/zksnarks_example#what-sort-of-applications-does-zksnarks-have

* ZK SNARK Poker
    * https://github.com/glamperd/snark-example/blob/master/poker/poker.sol

* ZK Dice
    * https://ethereum.stackexchange.com/questions/41660/is-it-possible-to-build-a-simple-dice-rolling-game-on-ethereum-with-solidity

* Randomness
    * https://revelry.co/insights/blockchain/critical-randao-vulnerability/
    * https://yos.io/2018/10/20/smart-contract-vulnerabilities-and-how-to-mitigate-them/#mitigation-bad-randomness
    * https://github.com/randao/randao
    * https://www.bookstack.cn/read/ethereumbook-en/spilt.8.c2a6b48ca6e1e33c.md

* Unsorted
    * https://blog.trailofbits.com/2020/12/14/reverie-an-optimized-zero-knowledge-proof-system/
    * https://dev.to/heymarkkop/zku-week-1-introduction-to-zkp-h5
    * https://github.com/iden3/distanceProver
    * https://github.com/vplasencia/circom-snarkjs-scripts
    * https://github.com/Darlington02/circom-next-starter
    * https://github.com/glamperd/snarkjs-react
    * https://github.com/scipr-lab/libsnark
    * https://crypto.stackexchange.com/questions/66037/what-is-the-role-of-a-circuit-in-zk-snarks
    * https://medium.com/coinmonks/zk-poker-a-simple-zk-snark-circuit-8ec8d0c5ee52
    * https://medium.com/@yujiangtham/writing-a-zero-knowledge-dapp-fd7f936e2d43
    * https://killari.medium.com/implementing-zero-knowledge-lotterys-circom-circuits-part-2-2-59a2f976cd24
    * https://consensys.net/blog/developers/introduction-to-zk-snarks/
    * https://blog.cr.yp.to/20140205-entropy.html
    * https://mixbytes.io/blog/zksnarks-circom-and-go-practice-part-2#rec589652084
