# ZK
============

## Table of Contents

  * [Definitions](#definitions)
  * [Goals](#goals)
  * [History](#history)
  * [Prerequisite Knowledge](#know)
  * [Build](#build)
  * [Examples](#examples)
  * [Use Cases](#use-cases)
  * [Real-World Usage](#real)
  * [Developer Experience](#devex)
  * [References](#references)

### Definitions <a id="definitions"></a>

* Zero Knowledge Proof (ZKP)
    * Definition
        * proof there exists or that we know something, plus a zero knowledge aspect, so the verifier of the proof only gains one piece of information, whether the proof is valid or invalid
    * Actors
        * Creator (may be combined with Prover)
        * Prover
        * Verifier
    
* SNARK - succinct proof that certain statement is true
    * (aka Succinct Non-Interactive Arguments of Knowledge)
    * Examples
        * I know what a message m is
        * I want to proof to verifier that I know m by using a SNARK
        * I will use a SNARK to generate a proof `SHA256(m) = 0`
        * I will use the proof with message m and satisfy the property to verify that I know m

* Cairo - CPU build from AIRs

* ZK Rollup (Ethereum Scalability)
    * ZK Rollup scaling by 4x increases theoretical max TPS to over 1000
    * Future DApps on L2
    * ZK Rollup solutions have:
        * Tx execution on L2
        * Proof or tx data on L1
        * Rollup smart contract on L1 that enforces correct tx execution on L2 using tx data on L1
        * L1 main chain holds funds and commitments of L2 side chains
        * L2 side chains hold state and perform execution
        * Proof is required, either Fraud Proof (Optimistic) or Validity Proof (ZK)
        * Operations required to stake a bond in rollup contract to incentivise them to Verify and execute tx correctly

#### Types of ZK System

* zk-SNARK
    * About: small proofs, initial setup required, not quantum resistant
    * Abbreviation: Succinct Non-Interactive Arguments of Knowledge
    * Example
        * As per SNARK, however:
            * I don't want to reveal m to a verifier
            * I will use the proof with message m to satisfies the property to verify that I know m without revealing why the message m satisfies it or what the message m is 

* zk-STARK
    * About: larger proofs, simpler to implement, resistant to quantum computer attacks, developed by Starkware and used on Starknet
    * Abbreviation: Scalable Transparent Arguments of Knowledge
    * Example
        * Computation set of steps
        * Transform computation into set of Polynomials
            * Algebraic Intermediate Representation (AIR)
        * Proof (Stark Proof) proves that sequence of steps or trace was done correctly
        * Multiple AIRs pulled toghether to provide arbitrary computation in Cairo software

#### Properties of ZKP

All ZKP must satisfy the following properties (Goldwasser, Micali, Rackoff):

* Completeness - Prover should be able to eventually convince Verifier with high probability if run enough times if Prover is being truthful.
* Soundness - Prover can only convince if they are being truthful since high probability of being able to detect lying
* Zero-Knowledge(ness) - Verifier doesn't learn anything revealed by Prover except whether the statement is true or not

### Goals <a id="goals"></a>

* Goal 
    * Short proof (only a few kB size)
    * Fast proof verification (in a few ms)

#### Statement Types to Prove

* Statement about "facts" - provide a fact is true or not.
    * e.g. prove a specific graph has a three-colouring, or some number `n` is in some set of numbers
* Statements about my "personal knowledge" (Proof of Knowledge) - prove relies on what info the Prover actually knows.
    * e.g. know three-colouring of a graph, know factorisation of `n`

* Reference: https://blog.cryptographyengineering.com/2017/01/21/zero-knowledge-proofs-an-illustrated-primer-part-2/

#### Proof

* Proof of computation that may have taken a year to compute
    * Proof of the results of the computation being correct
    * Verifier provided with results of computation and requested to check the proof (but may be able to check very quickly, only take 1 second)
        * Note: no need to run the computation again for a year to check it

### History of ZKP <a id="history"></a>

* Pre-1980's - ZK research focussed on proof system soundness, prior to papers by Goldwasser
    * Case where malicious Prover tries to 'trick' a Verifier into believing false statement

* 1980's - ZK research investigated Verifiers that could not be trusted instead. See papers by Goldwasser, Micali, Rackoff

#### Features

* Transparency
* Computational Efficiency
* Post-Quantum Secure
* Future-Proofing
* Short-Proofs

#### Symmetric Cryptography

* 1976
    * Aurora
    * STARK
    * libSTARK
    * genSTARK
    * Fractal
    * Ligero
    * Hodor
    * ZKBoo
    * Succ. Aurora
    * Open ZKP

#### Asymmetric Cryptography

* 1980s-2000s
    * Halo
    * BulletProof

* 2000-2017
    * Marlin Sapling
    * SLONK
    * Groth16
    * SONIC
    * PLONK
    * Pinocchio

* 2017-2019
    * Supersonic

### Prerequisite Knowledge <a id="know"></a>

##### Numbers

* Sets
    * `Z` Set of all Integers `Z = {..., -4, -3, -2, -1, 0, 1, 2, 3, 4, ...}`
        * e.g. `(Z, +)` is a group `G` if it satisfies CAIN properties
    * `Z^+` Set of all Positive Integers only 
    * `Z^-` Set of all Negative Integers only 
    * `Q` Set of all Rational Numbers `Q = {...1, 3/2, 2, 22/7, ...}`
    * `R` Set of all Real Numbers `R = { 2, -4, 613, π, √2), ...}`
    * `N` Set of all Natural Numbers
    * `W` Set of all Whole Numbers
    * `C` Set of all Complex Numbers

* Fields
    * Generic Field `F`
    * Finite Field - field with finite set of elements, used in ZKPs
        * All Finite Fields have a Generator
    * Field Order - number of elements in the field set
        * Finite Field Order - must be either prime (Prime Field) or the power of a prime (Extension Field)
    * Field Examples
        * `F` Field (finite) `F`
            * e.g. set of integers with operations `+` and `*`
            * e.g. real numbers under operations `+` and `*`
            * e.g. set of integers mod a prime number `p` with operations `+` and `*`
        * `K` Field (of real or complex numbers) `K`
        * `Zp^*` Field (finite, of integers mod prime `p` with multiplicative inverses) `Zp^*`
            * aka `GFp^*` (Galois Field)
            * e.g. https://asecuritysite.com/encryption/finite
    * Field Operations
        * Field Axioms are required to be satisfied, where `a,b,c` are elements of the field `F`
            * Associativity (Additive and Multiplicative) `a + (b + c) = (a + b) + c` and `a•(b•c) = (a•b)•c`
            * Commutativity (Additive and Multiplicative) `a + b = b + a` and `a•b = b•a`
            * Identity (Additive and Multiplicative) - exists two different elements `0` and `1` in `F` such that `a + 0 = a` and `a•1 = a`
            * Inverses (Additive) - for every `a` in `F`, exists an element in `F` denoted `-a` called "additive inverse" of `a`, where `a + (-a) = 0`
            * Inverses (Multiplicative) - for every `a != 0` in `F`, exists an element in `F` denoted by `a^-1` called "multiplicative inverse" of `a`, where `a•a^-1 = 1`
            * Distributivity of multiplication over addition `a•(b+c) = (a•b) + (a•c)`
    * Field Elements are >=0 and < Field Order
        * Simple Field `{0,1,...,p-1}`, where `p` is prime

* Generator
    * Finite Fields all have a Generator
    * Cyclic is a Group that has a Generator Element
        * e.g. Start at a Point (Element) then repeatedly apply the Group Operation with Generator as argument a number of times you will cycle through the whole group and end in the same place you started at.
        * e.g. in an Analog Clock it is a Cyclic Group with elements `1-12` and the Generator numbers are `1`, `5`, `7`, `11`, but they come in Pairs, so where `1` is a Generator, then `-1` is also a Generator, so `-1`, `-5`, `-7`, `-11` are also its Generators. Identity element is `12`, so `-5 = 7`
        * Note: In Infinite Groups that are Cyclic, any element must be writable as a multiple of the Generator 

    * Generates all elements in the set by taking the exponent of the generator, so given a generator `g`, by running `g^0`,`g^1`,`g^2` eventually we get all Group elements
    * Finite Field of Order `q` has all its `q` elements of the Finite Field as Roots Polynomial `X^q - X`
    * Example
        * Given
            * Set of Integers
            * Prime `p = 5`
        * Get Group `Z5^* = {0,1,2,3,4}` where `+` and `*` operations carried out `modulo 5`
        * `Z5^*` is Cyclic and has two Generators `2` and `3`
            * `2^1=2`,`2^2=4`,`2^3=3`,`2^4=1`
            * `3^1=3`, `3^2=4`, `3^3=2`, `3^4=1`


* Modular Arithmetic
    * `x mod y = r`, where `r` is the positive remainder when `x` is divided by `y`
    * Reference: Modulo Arithmetic https://www.khanacademy.org/computing/computer-science/cryptography/modarithmetic/a/what-is-modular-arithmetic

* Group Theory
    * Group - collection of objects of same kind without repetitions. it is a simple example of an Algebraic Structure that associates a Set with one or more Operations and some Properties 
        * e.g. set of all English words starting with letter 'a' and call it Group `A`
    * Group `G` denoted by `{G,•}` is a set of elements `{a,b,c,...}` plus a binary (dot) operation `•` and if it satisfies the CAIN properties
        * C - Closure - `a•b` is in group `G` for all `a,b` in group `G` (i.e. `a,b ∈ G`, then `(a•b) ∈ G`)
            * If do operation on two elements in a group, the result will also be in the group
        * A - Associative - `(a•b)•c = a•(b•c)` holds for all `a,b,c ∈ G`
        * I - Identity - `a•e = e•a = a` holds if there exists an Identity element `e` in group `G` for every element `a` in group `G` (i.e. `a,e ∈ G`)
            * e.g. where `0` is the neutral element, a == 0, `0+x = x+0 = 0`
        * N - Inverse - `a•a' = a'•a = e` holds for all `a,a' ∈ G` where `e` is the Identity element for each `a` in group `G` there exists an Inverse element `a'` in group `G` (where `a'` is denoted `a^-1` if the operation `•` is denoted `+`). e.g. `7+(-7)=0`
    
    * Finite Group - where there is a largest number, to limit amount of elements that exist
        * e.g. Group `(B,+)` with Set `B = {0,1}` and operation `+`

    * Abelian Group - If a group `G` satisfies the `CAIN` properties, and also satisfies the following property
        * C - Commutative - `(a•b) = (b•a)` for all `a,b ∈ G`

* Group Homomorphisms
    * Homomorphism - map `f : A → B` between elements of two algebraic structures or Groups A, B of same type or same structure that preserves the operations of the structures, such that `f(x•y) = f(x)•f(y)`. 
    * If do mapping before dot operation, we get same answer as when we do dot operation before doing the mapping. Relevant to SNARK theory
    * See https://coders-errand.com/zk-snarks-and-their-algebraic-structure/

##### Polynomials

* Polynomial - single math object expression built from constants and variables by means of addition, multiplication, and exponentiation to a non-negative integer power that may contain an unbounded amount of info (i.e. list of integers). Single equation between polynomials may represent an unbounded number of equations between numbers.
    * e.g. `3x^2 + 4x + 3`, where coefficients are `3` and `4`
    * e.g. Given equation `A(x) + B(x) = C(x)`, where `A`,`B`, `C` are each Polynomials of variable `x`. If assertion Relationship is true that the equation holds then the following is also true when evaluating the equation at Point `x = 0`, etc
        * `A(0) + B(0) = C(0)`
        * `A(1) + B(1) = C(1)`
        * `A(2) + B(2) = C(2)`
        * `A(3) + B(3) = C(3)`
    * Note Multi-variat Polynomials may have `y` values too

* Use Case
    * e.g.
        * Given a computation
        * Represent it as Encoded information in a Polynomial with various terms (ZKPs may have a lot of information with millions of terms)
        * Form relationships from Polynomials
        * Equations generated from the Polynomials

###### Polynomial Arithmetic

https://www.youtube.com/watch?v=MBw86Z-s5HY

* Roots
    * For a Point variable `x` in a Field `K`, and with Coefficients in `K`, find the Root `r` of Polynomial `P` that is an Element of `K` such that evaluating `P` at `r`, then `P(r)` evaluates to `0` (`P(r) = 0`)

* Polynomial Division
    * Given Polynomials `A,B,C`
    * `B` divides `A` is denoted `B|A`
    * If `B` divides `A` then `A = B * C` (`C = A/B`)
    * Useful when writing proofs

* Polynomial Long Division
    * Decompose a Polynomial to another Polynomial of lower degrees
    * Re-write `P(x)` of degree `n` (highest power of terms `x`) into the following form `(x - r)(Q(x))`, where:
        * root `r` of `P(x)` is known
        * `Q(x)` is a Polynomial of degree `n - 1` (since we have factored `x` out of `Q(x)` and put it in term `(x - r)`)
        * `Q(x)` is a quotient obtained from the division process
        * Remainder must be `0` since `r` is known to be a root of `P(x)`
        * If evaluate `(x - r)(Q(x))` at Point `x = r` then we get result `0` where Polynomial evaluates to `0`
    * Useful when writing proofs

* Schwartz-Zippel Lemma
    * different Polynomials are different at most Points on an XY plane
    * if you have two non-equal Polynomials of degree of max `d` then when they are evaluated at any Point `x`, then most of the time, they will intersect at max `d` points on XY plane
    * Use Case: 
        * Accept a proof and check whether two given Polynomials are exactly the same or not
            * Prover and verifier may check whether they are the same if you know they intersect at a specific Point, and then check if they get the same value as each other at that specific Point `x`

* Lagrange Interpolation
    * Perform Lagrange interpolation on a given set of Points gives resulting Polynomial equation that passes through all those Points
        * e.g. Given two points on XY plane, define single straight line passing through all points
        * e.g. Given three points on XY plane define single 2nd-degree curve (e.g. 5x^2 + 2x + 1) that goes through them, where the Polynomial is defined by Coefficients are `5,2,1` and `x` is the Variable
            * If we have the Polynomial Coefficient representation (Polynomial Representation #1), then may substitute values for Variable `x` to evaluate its Points representation on XY plane (Polynomial Representation #2).
            * Interpolation is that process in reverse order, where given Points on XY plane (Polynomial Representation #2) we may use them to determine the Coefficients of the equation (Polynomial Representation #1)
        * e.g. Given n-points, create an (n-1) degree Polynomial that goes through all those Points


##### Elliptic-Curve Pairings

    * Elliptic-Curve (EC)- has set of points in `x`-dimensions that satisfy a complex equation. Efficient approach to Encryption
        * e.g. a straight line has equation `y = mx + b`
    * Field/Group Axioms (closure, commutativity, associativity, identity) - satisfied for some equations of an Elliptic Curve, by using many values of x to produce y values (points on the curve). These Points on the EC form a Group, and may be used as basis for public/private key cryptography
    * Elements (of EC) - are members of a Field and must have a specific set of properties
    * Operation (of EC) - defined over EC so its points form a Group
    * Set - defined over an Elliptic Curve `EC1` (maths object)
        * `S1` defined over `EC1`
        * `S2, S3` of Groups `G2` and `G3` are defined on other Elliptic Curves `EC2` and `EC3`, which are derived from `EC1`
    * Pairing - bilinear function that takes two Points `p1` and `p2` that are Elements from two Sets `S1` and `S2` (Groups `G1` and `G2`), and maps them to produce a third Point `p3` that is an Element on the third Set `S3` (Group `G3`), where each Set is a Group with a single Operation acting on its Elements

###### Elliptic-Curve Families

* Montgomery Curves
    * Represent addition operation graphically as an Elliptic Curve over Real Numbers with a defined curve
        * Draw line between Point `P` and Point `Q` and where it intersects the curve we take the negative mirrored curve value (along x-axis) at that intersection represents the result
    * If was over Integers instead then the EC of equation `y^2 = x^3 - 4 * x` over Z_191 is the set of Integers modulo 191 and appear like a scatter plot.
    * Reference https://youtu.be/zdoqKiap_bg?t=3270

* 25519 Curve
    * 128 bits security
    * Designed for use in Diffie-Hellman (ECDH) key agreement scheme
    * Fast ECC
    * `y^2 = x^3 + 486662*x^2 + x`

* BN254 / BN_128 Curve
    * Used in Ethereum for ZK-SNARKS

* BLS12-381 Curve
    * Used by ZCash

* Edwards Curve
    * `ax^2 + y^2 = 1 + (d * x^2 * y^2)`, with `a = 1` for some scalar `d` of value `0` or `1`.
    * If `a <> 1` they are called Twisted Edwards Curve. Twisted Edwards Curve is birationally equivalent to a Montgomery Curve

##### Verifiable Random Functions (VRFs)

* VRF - cryptographic primitive mapping inputs to verifiable pseudorandom outputs. Ask third-party for randomess, and with output may generate proof to be confident it has been generated correctly without bias
    * e.g.
        * Given input x
        * Given secret key SK
        * Owner of SK computes `y = F_SK(x)` function value
        * Owner of SK computes `π_x` proof to verify correctness for any input value
        * Anyone else uses proof and public key or verification key to check the function value was calculated correctly (without revealing SK)
        * Use proof to convince Verifiers that value `y = F_SK(x)` is correct wrt public key of VRF

* Use Cases
    * Find block producers in a blockchain in a trustless verifiable way

##### Hash Functions

    * Hash function - is a math function with input and output
        * Deterministic (for same input always get same output)
    * Hash function properties - 
        * Prevents Hash Collisions - Changing the input always causes different output 
        * Difficult to find the input given the output. Possible with brute force by testing every conceivable input but using a lot of computation
    * Example
        * Merkle Tries

##### Encryption

* Symmetric Encryption
    * e.g. Send secret message
        * Alice and Bob share secret key
        * Alice encrypts message with shared key
        * Bob decrypts message with same key
        * Issues: Require meet in person, or share securely

* Asymmetric Encryption
    * e.g. Send secret message
        * Bob has two keys, public and private
        * Bob shares public key with Alice
        * Alice encrypts message send to Bob with Bob's public key
        * Bob decrypts message with private key
    * e.g. Prove ownership (knowledge of) a private key
        * Alice signs message with private key
        * Alice shares public key and message
        * Anyone decrypts message with public key

##### Arithmetic Circuits

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

##### Argument Systems (for NP-problems)

###### What is an Argument System

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

###### Types of Argument Systems

### Build <a id="build"></a>

#### Cairo

* Install [Scarb](https://docs.swmansion.com/scarb) 0.5.1
```bash
curl --proto '=https' --tlsv1.2 -sSf https://docs.swmansion.com/scarb/install.sh | bash -s -- -v 0.5.1
source /Users/luke/.bashrc
scarb --version
```
* Note: [Prostar](https://docs.swmansion.com/protostar/) does not yet support Cairo V2

* Create Scarb project
```
mkdir -p contracts
scarb new ./contracts/cairo1_v2
cd ./contracts/cairo1_v2
```

### Examples <a id="examples"></a>

#### Colour-Blind Verifier

* About
    * Interactive proof of passing messages between Prover and Verifier where:
        * Prover shows they have different colours and shows they can distinguish between a red and a green coloured billiard ball, but without revealing which of the balls are red and green
        * Verifier cannot distinguish between them
    * For blockchain use cases the message interaction are squashed into a single interaction for Knowledge-Interaction Proof
* Steps
    * Verifier holds each ball in a hand in front of Prover, then hides them behind back
    * Probability of 50% Swap (once) or No Swap
    * Show balls in each hand in front of Prover again
    * Prover says whether Swap or No Swap occurred to prove they can distinguish between the different ball colours
        * Verifier checks if Prover is really able to distinguish between the two balls, if so then they should know if Swap or No Swap occurred
            * 50% probability of Prover being wrong
    * But risk to Verifier that Prover "Guessed" correctly by chance that they were different or not, but was actually colour-blind
    * Repeat process above `k` times to convince Verifier with high probability, so risk of "Guessing" correctly becomes `1 / 2^k`, to minimise that risk to as low as possible
    * Verifier accepts proof (zero knowledge aspect) is true, but its "probabilistic" with high probability (only very small probability that not correct, or false proof provided), but Verifier does not gain any other knowledge about the balls so the Verifier still cannot distinguish between the balls by themselves

#### Where's Wally (Physical Proof)

* https://youtu.be/zdoqKiap_bg?t=4898

#### Suduko

* https://youtu.be/zdoqKiap_bg?t=4975

#### 3-Colouring Problem

* Problem - 3-Colouring Problem by Goldwasser, Micali, Wigderson (GMW)uses the Hat (GMW) Protocol
    * e.g. statement of assigning frequencies to cellular networks
* Protocol Rounds (to reduce probability of cheating enough to convince Proof is Valid): E^2
    * Probability of cheating successfully after first test: (E-1)/E (99%)
    * Probability of cheating successfully after 2nd test: ((E-1)/E)^2 (98%)
* Commitment Scheme - created used to allow Prover to 'commit' to a given message while keeping it secret, and then later 'opening' the resulting commitment to reveal it when Verifier challenges it. Built using:
    * Cryptographic hash functions (strong)

* Problem Class: NP-Complete
    * Note: Interactive ZKP for every statement of class NP of other [decision problems](https://en.wikipedia.org/wiki/Decision_problem) (with yes/no answer) whose witness solution can be verified in polynomial time, that we wish to Prove may be able to reuse the 'efficient' ZKP proof of the 3-Colouring Problem and Hat Protocol, by [translating their useful statement of class NP to an instance of this 3-Colouring Problem](https://www.cs.cmu.edu/~ckingsf/bioinfo-lectures/sat.pdf) (represent input problem as boolean circuit, where need know correct input to satisfy circuit, then translate circuit into a graph) and run the digital version of the Hat Protocol.
        * But doing so would be insanely expensive

* Reference
    * [x]  https://blog.cryptographyengineering.com/2014/11/27/zero-knowledge-proofs-illustrated-primer/
    * [ ] https://www.cs.cmu.edu/~ckingsf/bioinfo-lectures/sat.pdf

### Problem Classification of Complexity

* NP
* NP-Complete
    * https://en.wikipedia.org/wiki/NP-completeness

* References
    * [x] https://blog.cryptographyengineering.com/2014/11/27/zero-knowledge-proofs-illustrated-primer/
    * NP - https://en.wikipedia.org/wiki/NP_(complexity)

### Use Cases <a id="use-cases"></a>

* Private Tx (not reveal sender or amount)
    * e.g. Zcash, Monero, ZKDai, Nightfall
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

* ZK Rollups (Ethereum Scalability)

* DApps with ZK
    * Aleo (run app, verify run correct, but with private code, private data, private interactors)
    * EZKL

#### Schnorr Identification Protocol

* About
    * Basis of most modern signature schemes

* Example
    * Alice generates Key Pair
        * public key format
            * `p` prime number
            * `g` generator of Cyclic Group of prime Order `q`
        * pick random integer between `1` and `q` and compute Key Pair (same Key Pair type that Diffie-Hellman and DSA Signing Algorithm uses) with:
            * `PK_A = g^a mod p`
            * `SK_A = a`
    * Alice publish public key
    * Alice wants prove Proof of Knowledge to Bob that she knows the corresponding secret key using Interactive Protocol conducted with Bob
        * Note: So far this is similar to public key SSH protocol
        * Protocol
            * Alice picks random `k` in range `1,..,q`
            * Alice sends `h = g^k mod p` to Bob
            * Bob picks random `c` in range `1,..,q`
            * Bob sends `c` to Alice
            * Alice sends `s = ac + k mod q` to Bob
            * Bob checks that `g^s ≡ PK_A^c • h mod p`, where `≡` means eqiuvalent to
        * Note: Check if Protocol satisfies property of:
            * Completeness
                * Substitution to verify that if Alice uses protocol honestly, Bob will be satisfied at the end
                ```
                g^s ≡ PK_A^c • h mod p
                g^ac+k ≡ (g^a)^c • g^k mod p
                g^ac+k ≡ g^ac+k mod p
                ```
            * Soundness
                * demonstrate soundness of Proof of Knowledge by demonstrating existence of a special algorithm called the Knowledge Extractor (Extractor) for every possible Prover
                    * Note: Knowledge Extractor is a special type of Verifier that interacts with a Prover (to extract the Prover's original secret if the Prover completes the proof)

    * TODO - finish summarising

* Reference: https://blog.cryptographyengineering.com/2017/01/21/zero-knowledge-proofs-an-illustrated-primer-part-2/

## Developer Experience <a id="devex"></a>

### Cairo Learning

* https://github.com/ltfschoen/starklings-cairo1

* Note: `ref` is the Cairo equivalent to `&mut` in Rust

### Cairo Scarb

* Cairo Mini Series https://extropy-io.medium.com/cairo-mini-series-4633053173f5
    * use Scarb 0.5.1

* Reference Lesson 5
* References
    * https://docs.swmansion.com/scarb
    * https://asdf-vm.com/
    * https://asdf-vm.com/guide/getting-started.html
    * https://docs.swmansion.com/scarb/docs/cheatsheet

```bash
brew install coreutils curl git
```
* Add curl to PATH
```
echo 'export PATH="/usr/local/opt/curl/bin:$PATH"' >> $HOME/.bash_profile
```

* For compilers to find curl you may need to set:
```
export LDFLAGS="-L/usr/local/opt/curl/lib"
export CPPFLAGS="-I/usr/local/opt/curl/include"
```

* For pkg-config to find curl you may need to set:
```
export PKG_CONFIG_PATH="/usr/local/opt/curl/lib/pkgconfig"
```

```
brew install asdf
```

* Add asdf to shell profile
```
. /usr/local/opt/asdf/libexec/asdf.sh
```

```
asdf plugin add scarb https://github.com/software-mansion/asdf-scarb.git
asdf install scarb 0.5.1
asdf global scarb 0.5.1
asdf reshim scarb
echo 'export PATH="/usr/local/opt/asdf/bin:$PATH"' >> $HOME/.bash_profile
asdf current
asdf which scarb
echo 'export PATH="$HOME/.asdf/installs/scarb/0.5.1/bin:$PATH"' >> $HOME/.bash_profile
source $HOME/.bash_profile
scarb --version
```

* Install Starkli CLI to deploy smart contracts to Starknet 
    * https://github.com/xJonathanLEI/starkli
    * Docs https://book.starkli.rs/installation
    ```
    curl https://get.starkli.sh | sh
    . $HOME/.starkli/env
    starkliup
    starkli --version
    ```

* Create project
```
mkdir -p contracts
cd contracts
scarb new hello_world
cd hello_world
touch ./src/contract.cairo
```
* Change contents of ./src/lib.cairo to be `mod contract;`
* Paste contents for ./src/contract.cairo as shown at https://extropy-io.medium.com/cairo-mini-series-4633053173f5

* Build smart contract with Scarb to generate Sierra JSON output ./target/dev/hello_world_contract.sierra.json
```
scarb clean
scarb build
```

* Setup Signer account with Starkli
    * Update .gitignore to include `keys/`
    ```
    mkdir -p keys
    starkli signer keystore new ./keys/demo-key.json
    ```
    * Output
        ```bash
        Created new encrypted keystore file: ../zk/contracts/hello_world/keys/demo-key.json
        Public key: 0x0590c8717f28e0ab8d03ca2a55cf760cecb795c9c51d79caa7918522e5590724
        ```
    * Enter password (if any) to encrypt to JSON file

* Note: It is possible to inspect the associated private key with:
    ```
    starkli signer keystore inspect-private ./keys/demo-key.json
    ```

* Initialize OpenZeppelin account
    ```
    starkli account oz init ./keys/demo-account.json --keystore ./keys/demo-key.json
    ```
    * Enter password
    * Output
        ```bash
        Created new account config file: ../zk/contracts/hello_world/keys/demo-account.json

        Once deployed account available at 0x00cb2a0ea73f2b502eb51802b6c58f940ed859c4b062f81410475f7d132810d5

        Deploy this account by running:
            starkli account deploy ./keys/demo-account.json
        ```

* Request testnet from faucet L2 Goerli ETH to an account address on Starknet Goerli to pay transaction fee in Starknet https://faucet.goerli.starknet.io/
    * Signer address balance https://testnet.starkscan.co/contract/0x0590c8717f28e0ab8d03ca2a55cf760cecb795c9c51d79caa7918522e5590724#portfolio
* Repeat requesting testnet tokens for OpenZeppelin account that will exist once deployed (differs from public key) 0x00cb2a0ea73f2b502eb51802b6c58f940ed859c4b062f81410475f7d132810d5
* Note: When you create a keystore with Starkli, it asks you to enter a password which acts as your encryption for the file. https://book.starkli.rs/signers?highlight=encr#encrypted-keystores
* Note: The reason why it needs tokens is that the account you are about to deploy has to pay for the `DEPLOY_ACCOUNT` transaction fee. Refer to this resource to take Starkli to set it as your environment variable https://medium.com/starknet-edu/starkli-the-new-starknet-cli-86ea914a2933

* Deploy OpenZeppelin account
    * https://book.starkli.rs/providers
    ```
    starkli account deploy ./keys/demo-account.json --keystore ./keys/demo-key.json --network goerli-1
    ```

    * Output
        ```bash
        The estimated account deployment fee is 0.000004323000034584 ETH. However, to avoid failure, fund at least:
            0.000006484500051876 ETH
        to the following address:
            0x00cb2a0ea73f2b502eb51802b6c58f940ed859c4b062f81410475f7d132810d5
        Press [ENTER] once you've funded the address.
        Account deployment transaction: 0x06729884d01da04d405a87f73e8fc2cf9850b4451331a85321e84f644c444c03
        Waiting for transaction 0x06729884d01da04d405a87f73e8fc2cf9850b4451331a85321e84f644c444c03 to confirm. If this process is interrupted, you will need to run `starkli account fetch` to update the account file.
        Transaction not confirmed yet...
        Transaction 0x06729884d01da04d405a87f73e8fc2cf9850b4451331a85321e84f644c444c03 confirmed
        ```

* Note: If you get error `Error: unable to convert gateway models to jsonrpc types` then you likely need to obtain testnet tokens for the public key or the account address from the faucet and check the balance exists using Starkscan

* Declare contract
    ```
    starkli declare ./target/dev/hello_world_contract.sierra.json --account ./keys/demo-account.json --keystore ./keys/demo-key.json --compiler-version 2.0.1 --network goerli-1 --watch
    ```
    * Output
        ```
        Not declaring class as it's already declared. Class hash:
        0x01bd57d79c17fe2a24c013f58c72a47f9f3acc0b8bd7e9b8e1e0f9e50936726f
        ```
    * Class hash https://testnet.starkscan.co/class/0x01bd57d79c17fe2a24c013f58c72a47f9f3acc0b8bd7e9b8e1e0f9e50936726f

* Record HASH address that is returned

* Deploy contract using HASH
    ```
    HASH=0x01bd57d79c17fe2a24c013f58c72a47f9f3acc0b8bd7e9b8e1e0f9e50936726f
    starkli deploy $HASH --account ./keys/demo-account.json --keystore ./keys/demo-key.json --network goerli-1 --watch
    ```
    * Output
        ```
        Deploying class 0x01bd57d79c17fe2a24c013f58c72a47f9f3acc0b8bd7e9b8e1e0f9e50936726f with salt 0x00334d045db72d1ab2c0c2aca82be4b0b61d40e590e1c5bf5281a326d67349c1...
        The contract will be deployed at address 0x046fe65fad329c740051c5ee0a54a8a1c46fb5a64854379cf2ca49ffe3e4cb94
        Contract deployment transaction: 0x02900c8a0d2a58e3fca29766a20af02809f4fff8555fbd052509538511dc44d8
        Waiting for transaction 0x02900c8a0d2a58e3fca29766a20af02809f4fff8555fbd052509538511dc44d8 to confirm...
        Transaction not confirmed yet...
        Transaction 0x02900c8a0d2a58e3fca29766a20af02809f4fff8555fbd052509538511dc44d8 confirmed
        Contract deployed:
        0x046fe65fad329c740051c5ee0a54a8a1c46fb5a64854379cf2ca49ffe3e4cb94
        ```
* Note: The salt acts as a seed that is used in the computation of the contract's address.
https://docs.starknet.io/documentation/tools/CLI/commands/#starknet_deploy

* View deployed contract and call functions
    * https://goerli.voyager.online/contract/0x046fe65fad329c740051c5ee0a54a8a1c46fb5a64854379cf2ca49ffe3e4cb94#readContract

* Note: It is possible to deploy to a local network using Katana using `--rpc http://0.0.0.0:5050` instead of `--network goerli-1` 
    * Alternatively use Starknet Devnet https://github.com/0xSpaceShard/starknet-devnet/releases, where Seed 0 will ensure you to always work with the pregenerated accounts, accounts the number of accounts generated. Check more info on their subcommands here: https://0xspaceshard.github.io/starknet-devnet/docs/guide/run/
        ```
        brew install gmp
        pip install starknet-devnet
        starknet-devnet \
            --accounts 3 \
            --gas-price 250 \
            --seed 0 \
            --port 5050
        ```
    * Note: If encounter error can run in Docker container and expose relevant port
* Note: It is possible to incorporate use of wallets Braavos and Argent X (see https://medium.com/starknet-edu/starkli-the-new-starknet-cli-86ea914a2933)

### Cairo Extension for Visual Studio Code

* Reference: https://github.com/starkware-libs/cairo/tree/main/vscode-cairo

```bash
mkdir -p starkware-libs && cd starkware-libs
git clone https://github.com/starkware-libs/cairo
cd ./cairo/vscode-cairo/
nvm use v18.16.0
sudo npm install --global @vscode/vsce
```

```
npm install
vsce package
```

```
code --install-extension cairo1*.vsix
```

```
code .
```

* View > Terminal
```
npm install
npm run compile
```
* Restart Visual Studio Code

* Note: It may be possible to just install Cairo support VSCode Extension "starkware.cairo" instead of the above steps
    * https://marketplace.visualstudio.com/items?itemName=starkware.cairo1&ssr=false

* Add the following to $HOME/Library/Application\ Support/Code/User/settings.json to  make the "Debug"/"Run" CodeLens above tests work and for logs to be printed in your VSCode terminal when you click the "Debug"/"Run" CodeLens above your tests.

```
code $HOME/Library/Application\ Support/Code/User/settings.json
```
* Paste the following in settings.json. Alternatively use `trace` instead of `debug`

```
"rust-analyzer.runnableEnv": {
   "CARGO_MANIFEST_DIR": "/Users/luke/code/github/ltfschoen/starklings-cairo1/",
   "RUST_LOG": "debug,salsa=off,minilp=off"
},
"[cairo]": {
    "editor.tabSize": 4,
    "editor.formatOnType": true,
    "editor.insertSpaces": true,
    "editor.semanticHighlighting.enabled": true
},
```

* Install Cairo syntax highlighting with VSCode Extension "0xChqrles.cairo-language"

* Open relevant Cairo code to run in VSCode
* Run > Start Debugging (F5)

### Mina zkApp CLI

* Reference https://github.com/o1-labs/zkapp-cli/
* Homework 9

```
nvm use v16.18.1
npm install -g zkapp-cli
zk --version
zk example sudoko
```

### zkOracle Nodes (by Hyper Oracle)

#### Introduction

* Traditional Oracles vs zkOracle networks
    * Traditional Oracles analogy is similar to Optimistic Rollups
        * Examples of Traditional Oracles
            * Input Oracles
                * Chainlink price feeds
            * Output Oracles
                * The Graph Protocol
        * Performance relies on the challenge period or slashing, which may take days or weeks
    * zkOracle networks (i.e. Hyper Oracle) analogy is similar to ZK Rollups
        * Note: zkOracle is not a Rollup or L2. See for details https://docs.hyperoracle.io/resources/faq#is-hyper-oracle-a-rollup-or-layer-2
        * Performance is based on ZK Proof generation time that may be performed in parallel and performed in minutes or seconds. Additional nodes adds redundancy and nearly linearly boosts its performance with parallel proving
        * zkOracle Nodes
            * Multiple zkOracle Nodes may target zkPoS as well as each zkGraph. This enables parallel generation of ZK proofs, which can significantly enhance performance.
            * Only a single zkOracle Node is necessary to be considered decentralised and to maintain network security since the zkOracle network follows the 1-of-N trust model, as defined in [Vitalik Buterin's article on trust models](https://vitalik.ca/general/2020/08/20/trust.html), which only requires one honest node to create a secure network and maintain the network's health and uptime, since zkOracle security is fully based on maths and cryptography and inherits its security from Ethereum that serves as its data source, whereas traditional oracles require redundancy, as mentioned here https://docs.hyperoracle.io/resources/faq#how-data-source-of-zkoracle-is-secured-since-zk-are-only-safeguarding-computation
        * zkOracle network is censorship-resistant and operates trustlessly without requiring external trust in third-parties
        * Verification Contracts are used in zkOracle to provide intensive computation that is carried out securely and trustlessly off-chain using ZK and using Verification Contracts.
            * zkWASM secures off-chain computation. See for details https://docs.hyperoracle.io/resources/faq#what-computation-in-hyper-oracle-is-secured-by-zk
        * Finality is achieved at the end of the challenge/dispute period (to finalise any disagreement on computation) according to the definition of finality for rollups and when all ZK Proofs are verified, and data becomes fully immutable and constant

#### zkGraph (Mapping)

* zkGraph (offchain smart contract) - based on to The Graph's Subgraph https://thegraph.academy/developers/defining-a-subgraph/\
	* Deposit Testnet ETH balance
		* config.js `UserPrivateKey`
	* Update config.js
	* Run test.sh to check it works
	* Configure using the zkGraph Template repository:
		* zkgraph.yaml (configures the zkGraph, manifest, see documentation https://github.com/graphprotocol/graph-node/blob/master/docs/subgraph-manifest.md)
			* Information for zkGraph Explorer
			* data source (Meta Apps used)
			* target blockchain network
			* target smart contract address. Destination Contract Address is the on-chain contract that will be triggered by the I/O zkAutomation Meta App (a zkOracle) associated with the zkGraph
			* target event
			* event handler
		* schema.graphql - optional data structure defining how data stored and accessed. See documentation https://graphql.org/learn/schema/#type-language
		* config.js - configure local development API
			* Ethereum JSON RPC provider URL (supporting `debug_getRawReceipts` JSON RPC method, e.g. HTTPS endpoint of Ethereum Goerli Testnet)
			* Private key to sign zkWASM messages (with a balance of Goerli Testnet Eth)
			* zkWASM provider URL (i.e. by Hyper Oracle)
			* Compiler server endpoint (i.e. by Hyper Oracle)
			* Built zkGraph WASM bin path full
			* Built zkGraph WASM bin path local 
		* References
			* Library in AssemblyScript (data structures. i.e. Bytes, ByteArray, BigInt)
			* Examples for reference (see ./example)

	* Develop new zkGraph provable program by modifying the following in AssemblyScript with source code in ./src
        * mapping.ts - specifies core data mapping logic of zkGraph (data mapping of off-chain computation logic) of filtering (run in zkWASM) and handling emitted on-chain event data (or setting up calldata of smart contract automation) in AssemblyScript and generation of output state in other forms. The defined data mapping is between zkGraphs in the zkOracle network, and the Meta Apps (zkIndexing, zkAutomation) in a Hyper Oracle zkOracle node. See https://docs.hyperoracle.io/zkgraph/introduction. It is used to execute zkGraph Standards (i.e. zkML https://docs.hyperoracle.io/zkgraph-standards/zkml, zkAutomation, or zkIndexing https://docs.hyperoracle.io/zkgraph-standards/zkindexing), and generate ZKPs in zkWASM)

	* Interact with zkGraph using API (using ./api, see test.sh)

	* Validate
		* Compile
			* Generates zkgraph.wat compiled WASM file from zkGraph using compiler server endpoint in config.js
			* Generates hyper_oracle.wasm binary WASM file in build/ folder
			* Estimate and minimise instructions costs to reduce proof generation time
		* Setup
			* Generate zkWASM image ID
			* Deploy the WASM file to the Hyper Oracle node zkWASM provider url specified in config.js `CompilerServerEndpoint` for ZKP generation
		* Execute
			* Execution the WASM file to process data to get expected output at a specific Block Number and Generate Output State for the zkGraph if `require` used in mapping.ts to verify inputs and conditions before execution returns `true` using Hyper Oracle nodes.
				* zkAutomation is an automation job that is triggered if all `require` conditions are `true`. See https://docs.hyperoracle.io/zkgraph/zkgraph-assemblyscript-lib
				* zkAutomation is a I/O zkOracle, because the data flows from on-chain (original smart contract event data) to off-chain (zkGraph source) to on-chain (automation triggered).

				* zkAutomation requires specifying their target contract, target function, and source (when to trigger). For more complex trigger conditions, developers can choose to either trigger automation every N-th block (in scenarios like a keeper bot) or use a zkGraph as the off-chain source. https://docs.hyperoracle.io/zkgraph-standards/zkautomation/introduction
		* Prove
			* Prove zkGraph (given a block number and expected state, we generate input, pre-test for actual proving, and prove)
				* Hyper Oracle nodes used
				* ZK proofs generated for the zkGraph to see if it is valid, based on the specified definitions to ensure computational integrity and validity
	* Publish
		* Upload zkGraph code and settings to an IPFS Address
			* zkGraph code files stored in EthStorage (storage scaling layer supported by Ethereum ESP) to guarantee a fully decentralised development pipeline for zkGraph
		* Deploy the ZK Verifier Contract for the ZKP of the zkGraph to Hyper Oracle testnet (for local testing or fully with zkWASM node)
            * Verifier Contract Interface - https://github.com/DelphinusLab/halo2aggregator-s/blob/main/sol/contracts/AggregatorVerifier.sol#L40
                * TODO - does this prove that L2 block transition was correct, batch tx together?? see Lesson 10 slides, like Scroll
		* Deploy and Register the zkGraph with global on-chain Registry Contract

* Subgraph
	* Setup Subgraph:
		* Create a subgraph through bootstrapping that is assigned to index all events of an existing smart contract that may have been deployed to Ethereum testnet or an example Subgraph (e.g. based on Graphity contract)
		* Subgraph fetches contract ABI from Etherscan or fallback to requesting a local file path
	* Define Subgraph manifest (i.e. subgraph.yaml) that specifies the:
		* Smart contract address the Subgraph indexes to be sourced and ABI to use
		* Events from the smart contracts to monitor
		* Define mapping between event data emitted by the smart contract to entities The Graph Node stores
	* Emitted events from smart contract are written to the Graph Node and stored as entities associated with that smart contract by the subgraph.
	* ...
	* Deploy Subgraph to hosted service and inspect using Graph Explorer
	* Migrate Subgraphs to zkGraph
		* Requires just 10 lines of configuration difference. Implementations such as Standardized Subgraph and ecosystem tooling like Instant Subgraph and Subgraph Uncrashable can be used for developing zkGraph.

* References:
	* zkGraph API Reference - https://docs.hyperoracle.io/zkgraph-standards/zkgraph
	* https://docs.hyperoracle.io/zkgraph/develop/1.-zkgraph-studio-ui
	* https://www.youtube.com/watch?v=1ehlXhwk5eE
	* Subgraph
		* https://thegraph.academy/developers/defining-a-subgraph/
		* https://docs.hyperoracle.io/zkgraph/zkgraph-assemblyscript-lib
		* https://github.com/messari/subgraphs
		* https://docs.goldsky.com/indexing/instant-subgraphs
		* https://thegraph.academy/developers/subgraph-uncrashable/

#### zkWASM (Runtime)

* Inputs received including Block Header and Data Roots to run zkGraphs
* zkGraph Configuration
	* Define Customised Data Mappings
* Operator of zkOracle Node chooses proportion of deployed zkGraphs to execute
* Execution
	* Generate ZK Proof of the Operation
		* Optionally Outsource to decentralised Prover Network
* Output
	* Final State
		* Note: Off-chain data that developers can use through Hyper Oracle Meta Apps (zkGraph Standards) that are Services provided by Hyper Oracle for DApp developers, including zkIndexing and zkAutomation
		* Data is correct if at least one honest zkOracle node and all ZK Proofs are verified
	* Final ZK Proof
		* ZK tech stack used is Halo2 PSE and UltraPLONK https://docs.hyperoracle.io/resources/faq#what-is-the-zk-tech-stack-of-hyper-oracle
			* Circuit details https://github.com/DelphinusLab/zkWasm#circuit-details
		* Note: To demonstrate the validity and computation of the data
* Notes
	* zkWASM is a zkVM (virtual machine with ZK that generates ZK proofs) with WASM instruction set as bytecode https://docs.hyperoracle.io/resources/glossary#zkwasm
	* zkWASM is used instead of zkEVM. See for details https://docs.hyperoracle.io/resources/faq#why-zkwasm-not-zkevm
	* Rollups are a popular Layer-2 scaling solution for Ethereum.
	* zkEVM is a new type of zk-Rollup that is EVM compatible and secured by ZK Proof (ZKP). ZKP is a cryptographic proof that verifies the transaction data within a zk-Rollup is accurate.
	* zk-Rollups enhance both the privacy and security of a rollup as the ZKP verifies its transactions so no trust or "optimism" is required. Verify the truth of all the data and transactions in a zk-Rollup with "zero-knowledge", without needing to know the details of every transaction contained within it
	* Rollups bundle transactions in order to improve blockchain throughput while lowering transaction costs. Rollups "roll up" (combines) a number of transactions from a Layer-1 protocol (a blockchain like Ethereum) and executes them off-chain (not on the primary blockchain) using a Layer-2 protocol such as a sidechain or an EVM-compatible blockchain.
	* "Optimistic" Rollups (ORs) are assuming (optimistically) that all the transactions in a rollup are valid and not fraudulent. For this reason, there is a challenge/dispute period (typically several days) where one can challenge the validity of a transaction. https://decrypt.co/resources/what-is-zkevm

#### zkPoS (Consensus)

* Fetch Block Headers and Data Roots (including stateRoot, transactionRoot, receiptsRoot, by proving Ethereum consensus with ZK) from Ethereum blockchain trustlessly using zkPoS, and combining zkPoS with use of a secure and decentralised light client such as Helios to retrieve the data we may build a ZK SNARK-based light client that uses off-chain computation to deliver SNARKified block attestation, recursive proof of multiple blocks of Ethereum consensus
    * Helios https://a16zcrypto.com/building-helios-ethereum-light-client/
* Generate ZK Proof
    * Optionally Outsource to decentralised Prover Network
    * zkPos secures on-chain data source access that is already verified and secured by the base layer blockchain. See
        * https://docs.hyperoracle.io/resources/faq#what-computation-in-hyper-oracle-is-secured-by-zk
        * https://docs.hyperoracle.io/resources/faq#how-data-source-of-zkoracle-is-secured-since-zk-are-only-safeguarding-computation
* Output Block Header and Data Roots to zkWASM
    * Note: zkPoS is foreign Circuit of zkWASM
* Note: zkPoS refers to Ethereum's consensus algorithm fully verified with ZK https://docs.hyperoracle.io/resources/glossary#zkpos
* References
    * https://docs.hyperoracle.io/resources/faq#what-is-zkpos-exactly
    * https://docs.hyperoracle.io/technology/core-components/zkpos
    * https://mirror.xyz/hyperoracleblog.eth/lAE9erAz5eIlQZ346PG6tfh7Q6xy59bmA_kFNr-l6dE

#### zkAutomation

* About https://docs.hyperoracle.io/resources/glossary#zkautomation
* Benefits - TODO https://docs.hyperoracle.io/technology/comparisons#zkautomation-vs.-other-automation-protocols

#### zkIndexing

* About - https://docs.hyperoracle.io/resources/glossary#zkindexing
* Benefits - TODO https://docs.hyperoracle.io/technology/comparisons#zkindexing-vs.-other-indexing-protocols

#### zkML

TODO

### Axiom

* Intro to ZK
    * ZK proof is a proof of a computation satisfying:
        * Succinctness - property where size of proof is constant (or logarithmic) in the size of the computation. Succinctness allows us to compress expensive computations into ZKPs that are computationally cheap to verify. In a ZKP the Prover generates a ZKP of an expensive computation and sends the (constant sized) ZKP to a Verifier. Verifier then runs a cheap constant time verification algorithm on the ZKP (since ZKP is constant sized), and if it passes, the Verifier is assured that the Prover executed the claimed computation truthfully, and has this assurance **without trusting** the Prover, where the precise assurance is of the form under certain cryptographic assumptions, where ___ is true with probability `1 - 2^-100` .

        * ZK - certain inputs or intermediate variables of computation may be hidden from the verifier of the proof, but this property is often not used or turned off in current applications of ZK
    * Toolkits to Translate NP computations to ZK circuits (i.e. Rust/JavaScript API)
        * Inputs given are computation-specific
        * ZK circuit generates a ZK proof
            * ZK "circuits" are closer in spirit to circuits in hardware chips than normal computer programs (ZK circuits are not specified in a Turing complete language). There are still many improvements to be made in ZK circuit design.
        * Submit ZK proof to the Verifier
    * Circuit Design: Arithmetisations
        * ZK circuit computations are represented as a collection of vectors together with imposed constraints (aka relations) between certain entries in the vectors. In a trustless environment, all entries of the vector can be adversarially selected, and your only safeguards are the constraints you impose on these numbers. So in the following example, if we did not have the last constraint `a + b == c`, then we could supply `c = 0` and all our constraints would still be satisfied.
            * e.g. computing `1 + 1 = 2`, we could say we have vector `(a, b, c)` and constraints 
`a == 1, b == 1, a + b == c`
        * **Arithmetisations** are the different ways to translate a standard computation into such a collection of vectors and constraints.
            * Custom developer "front-ends" are available with different levels of abstraction and customizability for translating a ZK circuit into an arithmetization. Choosing an arithmetization and a front-end for writing in that arithmetization is the closest thing to choosing a **programming language** in ZK.
    * Prover-Verifier Dynamic (in a general Off-Chain setting)
        * Given an arithmetization (vectors + constraints)
        * Prover-verifier dynamic procedure is "interactive" as follows:
            * Prover sends the Verifier
                * commitment to the vectors
                * commitments (details omitted) to the constraints.
            * Verifier sends the Prover some random numbers (hence why it is "interactive")
            * Prover uses the previous commitment, along with some cryptography, to give a proof that the supplied vectors actually satisfies the claimed constraints (computation did what it claimed).
        * Using ZK SNARKs on-chain on Ethereum? 
            * Verifier is now a smart contract that runs the algorithm to verify a ZK SNARK supplied by the Prover. This enables powerful modularity and composability: the smart contract can programmatically perform further actions depending on whether the SNARK is verified correctly or not. For more details about how to produce SNARK verifier smart contracts, [see](https://docs.axiom.xyz/transparency-and-security/on-chain-zk-verifiers)
        * Note: Use non-interactive protocol to make it non-interactive using the [**Fiat-Shamir Heuristic**](https://www.zkdocs.com/docs/zkdocs/protocol-primitives/fiat-shamir/), where the prover does all of their steps first and sends the result to the verifier. The Fiat-Shamir Heuristic allows the verifier to then verify the proof with the same assurance of correctness as if the whole process had been interactive.
        * Note: **Polynomial Commitments**
            * Reference: https://docs.axiom.xyz/zero-knowledge-proofs/introduction-to-zk#polynomial-commitments
            * Commitments are a more expressive hash that pins down the vector so you can't change it later, but still allows you to perform some operations on the hashes which tell you useful information
            * Commitment of the vectors is an area of active research, where most vector commitments translate a vector into a polynomial (by [Lagrange interpolation](https://en.wikipedia.org/wiki/Lagrange_polynomial)) and work with the polynomial. Then the polynomials currently fall into two categories:
                * Elliptic curve cryptography used (not quantum-secure, additional assumptions for security, slower runtime)
                * Hash the polynomials and do sampling (proof sizes are larger, additional [assumptions](https://a16zcrypto.com/snark-security-and-performance/) for security)
            * [API perspective overview](https://learn.0xparc.org/materials/halo2/miscellaneous/polynomial-commitment/) of Polynomial Commitments
        * Note:
            * Choice of which **Polynomial Commitment** scheme to use is extremely important for the performance and security of the entire ZKP process. The speed of proof generation ([step 3 in the prover-verifier dynamic](https://docs.axiom.xyz/zero-knowledge-proofs/introduction-to-zk#prover-verifier-dynamic)) and cost of proof verification hinge upon this choice.
            * **Performance of ZK circuits** is governed by the laws of math, and polynomial commitment schemes specify which laws apply (analogy to hardware circuits where performance is governed by the laws of physics)
        * **Polynomial Commitment** 
            * Reference: Video by Yi Sun https://learn.0xparc.org/materials/halo2/miscellaneous/polynomial-commitment/
            * Definition: 
                * General API of a Polynomial Commitment is a cryptographic procedure that allows you to:
                    * Input Polynomial `P(x)`
                    * Commitment to the Polynomial `c = Commit(P)` is created by condensing it into a small amount of data
                    * Send Commitment from Prover to Verifier
                    * Upon Verifier knowing Commitment
                    * Prover cheaply construct Proofs of various evaluations of the Polynomial
                    * e.g. Prover with input point `x0` and evaluation `y0 = P(x0)` sends to the Verifier the values `x0`,`y0` and a Proof, then Verifier assured when verifying with `c` alone that `y0 = P(x0)` 
            * **Polynomial Commitment scheme** variations all implement these procedures/functions
                * Setup() - Generates a trusted data called the "setup" pk
                * Commit(pk, P) - Outputs commitment `c` to `P` (Polynomial), based on inputs `pk` ("setup") and `P`, which is a Pair of functions that commit to a Polynomial
                * VerifyPoly(pk, c, P) - Verify the commitment is valid. Given a commitment `c` and Polynomial `P`, this function checks if `c` is a valid commitment to `P`
                * Open(pk, P, x) - Allows prover to generate a proof `PI` for a Polynomial `P` evaluation `y` relative to a commitment Polynomial 
                Generates a proof PI for y=P(x)
                * VerifyOpen(pk, c, x, y, PI) - Allows Verifier to check that a claimed evaluation `y=P(x)` of a Polynomial `P` actually corresponds to the true evaluation of the commited Polynomial using proof `PI`
            * Why do we commit Polynomials?
                * Encode values of vectors in Polynomials
                    * e.g. 
                        * Given vector `(y1,..,yN)` of length `N`
                        * Encode coordinates of `y` as evaluations of Polynomial `P(x)` at specific values that are `ω^k` (powers of the roots of unity)
                        * If have root of unity `ω` that has order `K > N + 2` then we can encode the vector in a Polynomial `P(x)`..
                * Lagrange Interpolation used to construct Polynomial `P(x)` in coordinate form if you only know the evaluations
                * If Polynomial `P(x)` is an encoding of a vector, then the commitments `c = Commit(pk, P)` to that Polynomial `P` may be viewed as commitments to that vector, and;
                    * commitment `c` allows the Prover to prove coordinates of `y` belong to the originally committed vector (called a "vector commitment"), and;
                    * "opening" the commitments with `Open` may be viewed as proving the coordinates of the original vector. This allows conversion of any **Polynomial Commitment Scheme** into a **Vector Commitment Scheme** (more obvious how you would use)
            * Given a committed Polynomial...
                * If want to check Polynomial `P(x) = 0`
                    * `Open` the committed Polynomial `c = Commit(pk, P)` at randomly chosen evaluation point `z`, then if the degree of the `P(x)` is sufficiently small, then the chance of landing on the roots of the Polynomial is close to zero
                    * Therefore may use fact that the opening of its commitment `c` at a random `z` is `0` as a proof that the Polynomial `P` is identically `0`
            * **KZG Commitment Scheme** @ 8:00 in video
                * TODO

    * Choose ZK proving Stack and start Building
        1. Choose Arithmetization to use, along with a developer front-end for writing ZK Circuits in that Arithmetization.
        2. Choose Polynomial Commitment scheme the Prover/Verifier will use. Often baked into the choice of Arithmetization.
        3. Find an existing library that generates ZK Proofs from a given Arithmetization, or preferrably roll your own
* Axiom Stack
    * [PLONKish Arithmetisation](https://hackmd.io/@aztec-network/plonk-arithmetiization-air) with [Halo2](https://docs.axiom.xyz/zero-knowledge-proofs/getting-started-with-halo2) frontend
    * [KZG](https://dankradfeist.de/ethereum/2020/06/16/kate-polynomial-commitments.html) Polynomial Commitment scheme
    * Privacy Scaling Explorations [fork](https://github.com/privacy-scaling-explorations/halo2) of Halo2 backend, supporting KZG commitments
* Overhead
    * Proof size and proof verification time are constant
    * Runtime to generate a proof is not constant
    * Estimated overhead of generating a proof for a particular computation is around 100-1000x now. This is an active engineering problem with many facets for improvement:
        * Improving circuit design - this involves finding the optimal way to translate a Computation into an Arithmetization.
        * General performance engineering - some of the open-source code used for proof generation was developed for other purposes, and serious performance optimization has not been applied yet.
        * Choice of proving system: the combination of Arithmetization and Polynomial Commitment scheme forms a proving system. New research in this area can lead to step change improvements in performance.
    * Hardware: many core algorithms (Fast Fourier Transform, Elliptic Curve Multiscalar Multiplication) involved in the polynomial commitments can be parallelized or otherwise optimized using GPUs, FPGAs, ASICs.
* VM / Turing Completeness
    * ZK circuits in their purest form are not Turing complete (you cannot have recursive functions or infinite loops). They do not behave like general purpose VM we are used to (e.g., LLVM). For example, the notion of an "if" statement is very different: assuming boolean a, to replicate
        ```
        if a:
            f(b)
        else:
            g(b)
        ```
    * ZK circuits need to compute both `f(b)` and `g(b)` then return `a * f(b) + (1 - a) * g(b)` (assuming `a` is either `0` or `1`). 
    * ZK circuits may be used to build general or customized VMs using the principles of recursion and aggregation of ZK circuits. For example, to create a ZKP of `f(g(x))`, you would create ZKP `A` for `y == g(x)` and then a ZKP `B` that verifies the proof `A`: `y == g(x)` and further computes `f(y)`. See [here](https://0xparc.org/blog/groth16-recursion)
* Numerical Architecture
    * Difference between traditional compute and all ZK circuits is that in a numerical system the compute is applied on top of. In traditional architecture, we work in the world of bits: numbers are uint32, uint64, int32, int64, etc. Meanwhile, due to the cryptographic underpinnings behind ZK, all ZK circuits involve modular arithmetic, i.e., numbers are element in a finite field. This usually means there is a special prime number p, and then all operations are performed modulo p. This difference means that:
        * Operations that are cheap for bits (bit shifts, AND, XOR, OR) are expensive to implement in ZK.
        * ZK circuits still need to be implemented in traditional architectures, the implementation of things like finite field arithmetic adds another layer of overhead to all computations. There are continual developments to overcome this challenge, such as ZK friendly [Poseidon hashes](https://eprint.iacr.org/2019/458.pdf) or using "lookup tables" for ZK-unfriendly operations, but for now it is still a source of difficulties for performance and development.

* ZK Proof process
    * **Read** ZK proofs trustlessly with Axiom from Ethereum on-chain data encoded in block headers, states, transactions, and receipts in any historical Ethereum block that an archive node may access
    * **Compute**: After injesting data, Axiom applies verified compute primitives on top using diverse operations shown below, and then ZK proofs verify the validity of each of the below computations. ZK proofs verification means results from Axiom have security cryptographically equivalent to that of Ethereum. and make no assumptions about crypto-economics, incentives, or game theory, to offer the highest possible level of guarantee for smart contract applications
        * basic analytics (sum, count, max, min)
        * cryptography (signature verification, key aggregation)
        * machine learning (decision trees, linear regression, neural network inference)
    * **Verify**: Each query result is accompanied by an Axiom ZK validity proof confirming the following, and then the ZK proof is verified on-chain in the Axiom smart contract, with the final result then trustlessly available for use in your smart contract
        * input data was correctly fetched from the chain
        * compute was correctly applied

* Axiom Architecture
    * Reference: https://docs.axiom.xyz/protocol-design/architecture-overview
    * `AxiomV1` - a cache of Ethereum block hashes starting from genesis by:
        * Smart Contract - https://github.com/axiom-crypto/axiom-v1-contracts/blob/main/contracts/AxiomV1.sol
        * About
            * smart contract that caches block hashes from Ethereum history
            * allows user smart contracts to verify the historic block hashes against the cache
        * Details
            * store **Keccak Merkle roots** as cache in `historicalRoots`, stored in groups of 1024 consecutive block hashes (start block is a multiple of 1024), where the Merkle roots are kept updated by ZK proofs which verify that hashes of block headers form a commitment chain that ends in either one of the 256 most recent blocks directly accessible to the EVM, or a blockhash already present in the `AxiomV1` cache.
                * **Update** cache by calling functions:
                    * `updateRecent` - verify a ZK proof that proves the block header commitment chain is correct and update `historicalRoots` accordingly. the ZK proof checks that each parent hash is in the block header of the next block, and that the block header hashes to the block hash.
                    * `updateOld` - verify a ZK proof that proves the block header commitment chain is correct, where block startBlockNumber + 1024 must already be cached by the smart contract. This stores a single new Merkle root in the cache.
                    * `updateHistorical` - similar to as `updateOld` except it uses a different ZK proof to prove the block header commitment chain from. It requires block `startBlockNumber + 2 ** 17` to already be cached by the smart contract. This stores `2 ** 7 = 128` new Merkle roots in the cache
                * each function to update the Merkle root emits event `UpdateEvent`

            * store a Merkle Mountain Range (MMR) of these Merkle roots starting from the genesis block, where the MMR is constructed on-chain with updates to the **Keccak Merkle roots** in the first portion of the cache. this allows access to block hashes across large block ranges. `AxiomV1` stores historic block hashes in a second redundant form by maintaining a MMR of the Merkle roots cached in `historicalRoots`. The latest MMR is stored in `historicalMMR`.
                * **Update** `historicalMMR` by using `updateRecent` and `appendHistoricalMMR`
                * cache commitments to recent values of `historicalMMR` in the ring buffer `mmrRingBuffer` to facilitate asynchronous proving against a MMR, which may be updated on-chain during proving

            * `isBlockHashValid` method verifies that `merkleProof` is a valid Merkle path for the relevant block hash and checks that the Merkle root lies in the cache (verify block hashes against Merkle roots in the cache). It requires users to provide a witness that a block hash is included in the cache and is formatted via `struct BlockHashWitness`
            * `mmrVerifyBlockHash` function verifies block hashes against a cached Merkle mountain range

            * **Read** from cache may be achieved by accessing commitments to the entire cache simultaneously, where users may access recent MMRs in `mmrRingBuffer`.  This is primarily used for fulfillment of queries by `AxiomV1Query`, but users may also access it for their own purposes

    * `AxiomV1Query` - **Axium Query Protocol** uses this smart contract which allows users to query arbitrary block header, account, and storage data from the history of Ethereum. It fulfills batch queries against `AxiomV1` for trustless access to arbitrary data from historic Ethereum block headers, accounts, and account storage.
        * Queries may be submitted on-chain and are fulfilled on-chain with ZK proofs that are verified on-chain against the block hashes cached in `AxiomV1`, where query results are verified on-chain with ZK proofs of validity, where the ZK proofs check that the relevant on-chain data either lies directly in a block header or lies in the account or storage trie of a block by proving verification of Merkle-Patricia trie inclusion (or non-inclusion) proofs.

            * **Initiate Queries**
                * Initiate a query into Axiom with either on- or off-chain data availability using the following functions in `AxiomV1Query`. Each query request must be accompanied by an on-chain payment which is collected upon fulfillment.  The minimum payment allowed is specified by `minQueryPrice` in `AxiomV1Query` and is initially set to 0.01 ETH. If a query is not fulfilled by a pre-specified deadline, anyone can process a refund for a query specified by `keccakQueryResponse` to the pre-specified refundee by calling `collectRefund`.
                    * `sendQuery` - Request a proof for `keccakQueryResponse`. This allows the caller to specify a `refundee` and also provide on-chain data availability for the query in `query`
                    * `sendOffchainQuery` - Request a proof for `keccakQueryResponse`. This allows the caller to specify a `refundee` and also provide off-chain data availability for the query in `ipfsHash`.

            * **Fulfilling Queries**
                * **Verification**
                    * Queries are fulfilled by submitting a ZK proof that verifies `keccakQueryResponse` against the cache of block hashes in `AxiomV1`. Fulfillment has been permissioned to the `PROVER_ROLE` for safety at the moment. Both of the following fulfillment functions use the verifier deployed at `mmrVerifierAddress` to verify a ZK proof of the query result. See [here](https://docs.axiom.xyz/protocol-design/axiom-query-protocol#fulfilling-queries) for the list of public inputs/outputs responses of the ZK proof
                        * `fulfillQueryVsMMR` allows a prover to supply a ZK proof which proves `keccakQueryResponse` was correct against the MMR stored in index `mmrIdx` of `AxiomV1.mmrRingBuffer`. The prover must also pass some additional witness data in `mmrWitness` and the ZK proof itself in `proof`. The prover can collect payment to `payee`.
                        * `verifyResultVsMMR` allows a prover to prove a `keccakQueryResponse` without on-chain query request.
                * **Post-Verification**
                    * the smart contract uses the additional witness data in `mmrWitness` to check that `historicalMMRKeccak` and `recentMMRKeccak` are consistent with the on-chain cache of block hashes in `AxiomV1` by checking the following, and if all checks pass, the fulfilled results `keccakQueryResponse` and `poseidonQueryResponse` are stored in `verifiedKeccakResults` and `verifiedPoseidonResults`.
                        * `historicalMMRKeccak` appears in index `mmrIndex` of `AxiomV1.mmrRingBuffer`.
                        * `recentMMRKeccak` is either committed to by an element of `AxiomV1.historicalRoots` or is an extension of such an element by block hashes accessible to the EVM.
                * **Reading Verified Query Results**
                    * Axiom supports reading block, account, and storage data from verified query results via:
                        * `areResponsesValid` - check whether queries into block, account, and storage data have been verified. Each query is specified by:
                            * `BlockResponse` - The `blockNumber` and `blockHash` as well as a Merkle proof `proof` and leaf location `leafIdx` in `keccakBlockResponse`.
                            * `AccountResponse` - The `blockNumber`, `addr`, `nonce`, `balance`, `storageRoot`, and `codeHash` as well as a Merkle proof `proof` and leaf location `leafIdx` in `keccakAccountResponse`.
                            * `StorageResponse` - The `blockNumber`, `addr`, `slot`, and `value` as well as a Merkle proof `proof` and leaf location `leafIdx` in `keccakStorageResponse`.
                    * Raw query results may also be accessed using:
                        * `isKeccakResultValid` - Check whether a query consisting of `keccakBlockResponse`, `keccakAccountResponse`, and `keccakStorageResponse` has already been verified.
                        * `isPoseidonResultValid` - Check whether a query consisting of `poseidonBlockResponse`, `poseidonAccountResponse`, and `poseidonStorageResponse` has already been verified
        * ZK Circuits underlying historic Axiom data Queries
            * About:
                * Axiom proves in ZK that historic Ethereum on-chain data is committed to in block headers of the corresponding Ethereum block. The structure of this commitment and how Axiom uses ZK circuits to prove the commitment are shown below
            * **Account and Storage Proofs**
                * Account and account storage data is committed to in an Ethereum block header via several Merkle-Patricia tries. **Inclusion proofs** for this data into the block header are provided by **Ethereum light client proofs**.  For example, consider the value at storage slot `slot` for address `address` at block `blockNumber`. **Light client proof** for this value is available from the `eth_getProof` JSON-RPC call and consists of:
                    * block header at block `blockNumber` and in particular the `stateRoot`.
                    * account proof of Merkle-Patricia inclusion for the key-value pair `(keccak(address)`, `rlp([nonce, balance, storageRoot, codeHash]))` of the RLP-encoded account data in the state trie rooted at `stateRoot`.
                    * storage proof of Merkle-Patricia inclusion for the key-value pair `(keccak(slot), rlp(slotValue))` of the storage slot data in the [storage trie](https://ethereum.org/en/developers/docs/data-structures-and-encoding/patricia-merkle-trie/#storage-trie) rooted at `storageRoot`.
                * Verifying this **light client proof** against a block hash `blockHash` for block `blockNumber` requires checking:
                    * block header - is properly formatted, has Keccak hash `blockHash`, and contains `stateRoot`.
                    * state trie proof - is properly formatted, has key `keccak(address)`, Keccak hashes of each node along the Merkle-Patricia inclusion proof match the appropriate field in the previous node, and has value containing `storageRoot`.
                    * storage trie - similar validity check for its Merkle-Patricia inclusion proof
        * ZK Circuits underlying historic Account and Storage Proofs
            * Axiom verifies **light client proofs** in ZK using the open-source [axiom-eth](https://github.com/axiom-crypto/axiom-eth/) ZK circuit library, which supports operations in ZK shown listed [here](https://docs.axiom.xyz/protocol-design/zk-circuits-for-axiom-queries#zk-circuits-for-account-and-storage-proofs), where the end result of these are ZK circuits for block headers, accounts, and account storage, which prove validity of the block, account, and storage statements, and when combined together these circuits give ZK Circuits for Account and Storage Proofs
        * Aggregating ZK Proofs in Queries
            * Fulfilling queries into Axiom with ZK proofs verified against MMRs cached in `AxiomV1`, requires combining ZK Circuits for Account and Storage Proofs from the previous section with ZK Circuits verifying Merkle inclusion proofs into MMRs.
            * ZK proofs are generated for a query in the [Axiom Query Format](https://docs.axiom.xyz/developers/sending-a-query/axiom-query-format), where the ZK proofs are of:
                * Merkle inclusion proofs of each block hash in a MMR in the format cached in `AxiomV1`.
                * Proofs of the `stateRoot` in the block header committed to in each block hash.
                * Account proofs for each queried account relative to its stateRoot which in particular establishes the `storageRoot` of the account.
                * Storage proofs for each queried storage slot relative to its `storageRoot`.
                * Consistency between the block hashes, state roots, and storage roots referenced in the four previous proofs.
            * Verify ZK proofs on-chain
                * Reference: https://docs.axiom.xyz/transparency-and-security/on-chain-zk-verifiers
                * ZK proof aggregation may then be used with the [snark-verifier](https://github.com/axiom-crypto/snark-verifier/) library (uses Halo 2, Plonk) developed by the [Privacy Scaling Explorations](https://github.com/privacy-scaling-explorations/snark-verifier) group at the Ethereum Foundation are the specialized smart contracts that Axiom uses that are programmatically generated in Yul code for each SNARK, to aggregate these ZK proofs and verify any given ZK circuits on-chain. See [on-chain ZK verifiers](https://docs.axiom.xyz/transparency-and-security/on-chain-zk-verifiers) for a list of the deployed on-chain verifiers used in Axiom.
            * Compiling ZK Circuits to On-Chain Verifiers
                * Record the Rust command using the [snark-verifier](https://github.com/axiom-crypto/snark-verifier/) library which generates each of the on-chain ZK circuit verifiers below
                    * `AxiomV1` Verifier (AxiomV1Core SNARK Verifier)
                        * Yul generation command (to create this SNARK)
                            ```bash
                            cargo run --bin header_chain --release -- --start 0 --end 1023 --max-depth 10 --initial-depth 7 --final evm --extra-rounds 1 --calldata --create-contract
                            ```
                    * `AxiomV1` Historical Verifier
                        * Yul generation command
                    * `AxiomV1Query` Verifier 
                        * Yul generation command
            * Deployed Verifier Contracts
                * Yul source code for each verifier contract deployed in production is listed on [Github](https://github.com/axiom-crypto/axiom-v1-contracts/tree/main/snark-verifiers).
                * Generate bytecode for deployment using the following command with solc Version: 0.8.19. The Yul contracts compiling to bytecodes may be deployed and viewed on Etherscan
                    ```
                    solc --yul <YUL FILE> --bin | tail -1 > <BYTECODE FILE>
                    ```
            * Checking Verifiers are not Metamorphic
                * In `AxiomV1` and `AxiomV1Query`, each of these verifiers are subject to a timelock upgrade guarantee as detailed in [Guardrails](https://docs.axiom.xyz/protocol-design/guardrails) where there are three admin permissioned roles: `PROVER_ROLE`, `GUARDIAN_ROLE`, and `TIMELOCK_ROLE`.
                * Verify on each upgrade that the bytecode for verifier contracts above does not contain `DELEGATECALL` or `SELFDESTRUCT` opcodes, to ensure that this timelock guarantee cannot be bypassed by a metamorphic contract attack.
                * Verifying the absence of these potentially problematic opcodes is possible either directly from the bytecode view on Etherscan or using tools such as metamorphic-contract-detector or evmdis.  For convenience, we have integrated the latter to perform this check automatically in our Github CI for the axiom-v1-contracts repo [here](https://github.com/axiom-crypto/axiom-v1-contracts/blob/main/.github/workflows/foundry.yml#L95).

* Axiom SDK
    * Process
        * Initialize Axion SDK
            * Configure JSON-RPC provider and chainId (i.e. Goerli)
            * TODO - in progress

* Integrate Axiom
    * Axiom Alpha release live on mainnet may be used to trustlessly query historic Ethereum block headers, accounts, and account storage from your smart contract, and then use trustless compute primitives over this verified data.

* TODO - Axiom
    * [ ] try Axiom alpha release to query historic block data from a smart contract
    * if get early partner access try to use trustless compute primitives over this verified data
    * review axiom-eth that is used by Axiom to verify **light client proofs** in ZK https://github.com/axiom-crypto/axiom-eth/
    * watch [API perspective overview](https://learn.0xparc.org/materials/halo2/miscellaneous/polynomial-commitment/) of Polynomial Commitments
    * halo2 frontend https://docs.axiom.xyz/zero-knowledge-proofs/getting-started-with-halo2
    * kzg polynomial commitments https://dankradfeist.de/ethereum/2020/06/16/kate-polynomial-commitments.html
    * recursive ZK SNARKS https://0xparc.org/blog/groth16-recursion
    * ZKPs without math https://blog.cryptographyengineering.com/2014/11/27/zero-knowledge-proofs-illustrated-primer/
    * Vitalik post on QAPs, a math-y intro that gives a better flavor of how ZK works, uses arithmetization known as R1CS https://medium.com/@VitalikButerin/quadratic-arithmetic-programs-from-zero-to-hero-f6d558cea649
    * Poseidon ZK hashes https://eprint.iacr.org/2019/458.pdf

### The Portal Network

* About - Lightweight access to the Ethereum Protocol
* Problems - Existing clients (infrastructure that serves Ethereum Protocol not users) don't provide what is necessary to delivery lightweight protocol access
* Existing clients
    * Full node - heavy + decentralized (high CPU use for EVM execution + tx pool, high store 250GB history, 50GB canonical indices, 175GB state)
    * Portal Client - light + decentralized + [distributed](https://youtu.be/0stc9jnQLXA?feature=shared&t=499)
        * Homogeneous network, all participants are a clients + server
        * A protocol, not a single client, with multiple client reference implementations (Trin, Ultralight, Fluffy)
        * More nodes = more powerful it gets
        * Multiple could be embeddable, so could baked Client right into an Application so it runs in background and for example Metamask could connect to it

        * Currently "Sequential" queries so multiple round-trips of JSON-RPC requests and total latency increases 
            * e.g. ERC-20 balanceOf, need to download smart contract, starts executing, then access state database
        * Future Innovation
            * Individual Light Clients in The Portal Network might: 
                * "Concurrent or Batch" queries so single round-trip to lookup data, parallelise at networking level
        * ZK in Light Clients using The Portal Network
            * Unknown status
        * L2 use with Light Clients for cheap operations
            * Unknown status
        * Light Client freeloaders/act maliciously (fake and do not work, or increase fan speed high)
            * No plans for them to prevent this, its attackable (which would mean its working and ready to fine-tune), since The Portal Network is not core infrastructure at the protocol level, since the Ethereum Protocol does not depend on The Portal Network for anything
            * Too many freeloaders would degrade performance for all
    * LES Light Client - light + decentralized + no incentive to run it, just costs, purely taking from network by design
        * Degenerative since adding more nodes takes up limited capacity, and degrades service for all
    * Infura, Alchemy - light + centralized (risk of correlate IP with txs, selling your data, server down all stops working)
* Goals
    * Allows lightweight and resource constrained devices (i.e. raspberry pi, phones) to participate
    * Traditional execution layer client data load needs to be spread out to all the participants in network in even way
    * Remove height restrictions (hardware restrictions) that prevent you from joining the network
    * Devp2p network that supports execution layer clients currently only allow participants that hold all the state, and all the history, and sufficient processing power to process every block, and run the tx mempool
    * Client to network should be able to tune parameters dictating how much storage space and processing power the network will ask of you
    * UX elimination of long sync times so bearable for users so traffic doesn't all go to Infura and Alchemy
    * The Portal Network has designed a system where for a given head of the chain all data is accessible to you in seconds to minutes after peering, but not hours
    * Scalable to millions of network participant nodes (not TPS or sharding)
        * Previous LES light client didn't deliver on its goal as it existed in a client/server architecture
            * LES Nodes are dependent on Full Nodes serving them data
            * Problem is Full Node overwhelmed by LES Nodes with expensive queries for information
            * Issue is due to imbalance existing between client/server 
* Solution
    * Storage networks, partitioned from each other, specialised (5 OFF) - serve all data necessary for interacting with Ethereum Protocol
        * 1. Beacon Light Client - Beacon chain light protocol data
            * 2022 - After History Network
            * Data Types (3 OFF) - minimal objects required to jump to head of the Beacon Chain in The Portal Network
                * Light client update objects
                * ?
                * ?
        * 2. State Network - Account and Contract storage
            * 2023
        * 3. Transaction Gossip - lightweight Mempool
            * 2023
        * 4. History network - Headers, block bodies, receipts
            * 2022 - Imminently operational
        * 5. Canonical Txn Index - TxHash > Hash, Index
            * 2023
* Design
    * Building off the existing JSON-RPC standard
    * JSON-RPC (standard API that execution layer clients expose to users) level used to design The Portal Network, like what Alchemy exposes, and that Metamask is calling into, so The Portal Network is not creating Wallet interfaces for users (where user testing would be done) even though they are user-focused, but they are building Clients that consume the JSON-RPC API (low-level computers talking to computers)
* Exclusions
    * JSON-RPC Debug endpoints since heavier data access required 
        * Focus is on human-driven wallet interactions
* Example
    * Balance Query using The Portal Network
        * Uses 3 OFF networks from The Portal Network
            * Traditional approach - Client reads from local DBs
                * `eth_getBalance` <-> JSON-RPC Server
                    * <-> DB - Canonical Index
                        * Go into index to see what the Client thinks the head of the chain is
                    * <-> DB - Header Storage
                        * Look up the header in whatever database its stored in
                    * <-> DB - State
                        * Look for field in header to get state root, then read into State Database to get you account balance
            * The Portal Network approach - Client reaches out 3 OFF networks from The Portal Network to get samples of data before returned to user
                * `eth_getBalance` <-> JSON-RPC Server
                    * <-> DB - Beacon Light Protocol Network
                        * Tracks head of chain that provides Beacon Light Protocol data. 
                    * <-> DB - History Network
                        * Look up the header in in History Network where its stored
                            * Stores all historical block bodies, headers, receipts
                    * <-> DB - State Network
                        * Lookup relevant state root, then reach into State Network for that state to get you account balance
* Project Status (of The Portal Network)
    * Research complete
    * Building
* Client Implementations of The Portal Network
    * Trin - Rust, by EF Piper team - https://github.com/ethereum/trin
    * Ultralight - JS, by EF
    * Fluffy - by Nimbus team, run by Status network

## References <a id="references"></a>

* Encode ZK Bootcamp
    * Lessons
        * [x] Introductory Reading
        * [x] Lesson 1 recording https://youtu.be/zdoqKiap_bg
        * [ ] Lesson 2 recording https://youtu.be/zJjTUtd9h34
        * [ ] Lesson 3 recording https://youtu.be/Zli9goL0dWM
    * ZKP
        * [x] ZKP Primer Part 1 of 2 https://blog.cryptographyengineering.com/2014/11/27/zero-knowledge-proofs-illustrated-primer/
        * [ ] ZKP Primer Part 2 of 2 https://blog.cryptographyengineering.com/2017/01/21/zero-knowledge-proofs-an-illustrated-primer-part-2/
        * [ ] The Cambrian Explosion of Crypto Proofs https://medium.com/starkware/the-cambrian-explosion-of-crypto-proofs-7ac080ac9aed
    * Papers
        * Probabilitic Encryption, Goldwasser, Micali, Rackoff, 1984
        * The Knowledge Complexity of Interactive Proof Systems, Goldwasser, Micali, Rackoff, 1989
        * On the Size of Pairing-based Non-interactive Arguments, Jens, Groth, 2016
        * Proofs that Yield Nothing But Their Validity All Languages in NP Have Zero-Knowledge Proof Systems https://people.csail.mit.edu/silvio/Selected%20Scientific%20Papers/Zero%20Knowledge/Proofs_That_Yield_Nothing_But_Their_Validity_or_All_Languages_in_NP_Have_Zero-Knowledge_Proof_Systems.pdf
    * Blogs
        * L2 DApps https://medium.com/starkware/a-thundering-herd-the-rise-of-l2-native-dapps-290598f6477f
    * Cairo
        * [ ] https://perama-v.github.io/cairo/technicals/
    * ZK Rollups
        * https://github.com/barryWhiteHat/roll_up
        * https://medium.com/starkware/a-thundering-herd-the-rise-of-l2-native-dapps-290598f6477f

* ZK Whiteboard Sessions - Module 1 SNARK https://www.youtube.com/watch?v=h-94UhJLeck

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

* zkOracle
    * zkOracle Hyper Oracle Youtube - https://www.youtube.com/watch?v=YVWAQI2Kaew
    * [zkOracle Youtube](https://www.youtube.com/watch?v=kHT6uOX3jto)
    * [zkOracle](https://ethresear.ch/t/defining-zkoracle-for-ethereum/15131)
    * [zkOracle Wiki (another project)](https://zkoracleofficial.gitbook.io/zk-oracle-wiki/)
    * zkWasm - https://github.com/hyperoracle/zkWasm
    * zkWASM - https://mirror.xyz/hyperoracleblog.eth/abKqUB4iEJ4kRsGqq8baIFUnhV_eY-lblmhCrwRm31E
    * zkWASM technical - https://jhc.sjtu.edu.cn/~hongfeifu/manuscriptb.pdf

* Elliptic Curves
    * Elliptic Curves - https://www.udemy.com/course/elliptic-curve-cryptography-in-rust/
    * Elliptic Curves - https://github.com/RustCrypto/elliptic-curves

* News
    * Zero Knowledge Podcast https://zeroknowledge.fm
        * ZK Podcast Youtube https://www.youtube.com/watch?v=PtPcBnC9yAs&list=PLj80z0cJm8QEUVSlofe1Zd7wyaoZrixFM

* Blogs
    * Alex Pinto's Blog - https://coders-errand.com

* Unsorted
    * Cryptography Resources https://asecuritysite.com/encryption/finite
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
    * [Extropy tutorials](https://www.extropy.io/#education)
    * [AwesomeZK](https://github.com/fewwwww/awesome-zk)
    * [Encode ZK Bootcamp](https://www.encode.club/zk-bootcamp)
    * [ZK Podcast](https://zeroknowledge.fm/)
    * Recursive zk
        * https://medium.com/@rishotics/nova-based-folding-of-verifiable-ai-zkml-circuits-fdfdfd508736
        * https://zkresear.ch/t/folding-endgame/106
        * Recursive zkSNARKS https://0xparc.org/blog/groth16-recursion
    * zk examples
        * https://www.proofoftrack.xyz/p/proof-of-track-2023-06-29
    * Georgios Konstantopoulos links
        * https://www.gakonst.com/
    * Cryptographic library https://github.com/jedisct1/libsodium
    * Polynomials Arithmetic https://www.youtube.com/watch?v=MBw86Z-s5HY
    * Cairo
        * https://www.starknet-ecosystem.com/en/academy
        * https://cairo-by-example.com/
        * https://book.cairo-lang.org/
        * https://starknet-by-example.voyager.online/starknet-by-example.html 
        * Node Guardians
        * https://docs.swmansion.com/scarb/docs
        * Cairo Workshop by David Barreto — https://www.youtube.com/watch?v=7Yfsm7V9R4A&ab_channel=Topology
        * Starkli Advanced - https://medium.com/starknet-edu/starkli-the-new-starknet-cli-86ea914a2933
        * https://docs.openzeppelin.com/contracts-cairo/0.6.1/
    * Advanced ZK by Extropy https://zkp.ninja/
    * Starknet node
        * https://www.kasar.io/
    * RISC
        * [ ] RISC Zero Docs - https://dev.risczero.com/
        * [ ] RISC Zero Study Club - https://www.youtube.com/playlist?list=PLcPzhUaCxlCjdhONxEYZ1dgKjZh3ZvPtl
        * [x] RISC zkVM Design Principles - https://www.youtube.com/watch?v=VvYOECJnbEM&list=PLcPzhUaCxlCgig7ofeARMPwQ8vbuD6hC5&index=6
        * [x] RISC Zero How it Works - https://www.youtube.com/watch?v=8hwY88xJoyM&list=PLcPzhUaCxlCgig7ofeARMPwQ8vbuD6hC5&index=8
        * Examples
            * [x] RISC Password - https://www.youtube.com/watch?v=Yg_BGqj_6lg&list=PLcPzhUaCxlCgig7ofeARMPwQ8vbuD6hC5&index=6
            * [x] RISC Matching JSON - https://www.youtube.com/watch?v=6vIgBHx61vc&list=PLcPzhUaCxlCgig7ofeARMPwQ8vbuD6hC5&index=7
            * [x] RISC Checkmate - https://www.youtube.com/watch?v=vxqxRiTXGBI&list=PLcPzhUaCxlCgig7ofeARMPwQ8vbuD6hC5&index=9
        * Extropy.io Examples
            * [ ] https://github.com/ExtropyIO/ZeroKnowledgeBootcamp/tree/main/risc0/examples
    * Verkle - https://verkle.dev/
    * Ethereum
        * [How ZK Rollups publish transaction data on Ethereum](https://ethereum.org/en/developers/docs/scaling/zk-rollups/#how-zk-rollups-publish-transaction-data-on-ethereum)
    * Sequence Diagrams - https://sequencediagram.org/
    * Games
        * ZK ML repo for Cairo https://orion.gizatech.xyz/welcome/readme 
            * Example game that implements Orion https://github.com/cartridge-gg/drive-ai
    * EZKL - tutorial to use EZKL in browser with WASM https://docs.ezkl.xyz/tutorials/wasm_tutorial/
    * Encode ZK Bootcamp July 2023 Cohort Lesson Recordings
        * Note: Refer to materials folder for Lessons and Homework PDFs
        * Lesson 1 - Maths and Cryptography Intro - https://youtu.be/zdoqKiap_bg
        * Lesson 2 - Zero Knowledge Proofs - https://youtu.be/zJjTUtd9h34
        * Lesson 3 - ZKP System Comparison - https://youtu.be/Zli9goL0dWM
        * Lesson 4 - Introduction to Starknet - https://youtu.be/6gJuhgMCg-Q
        * Lesson 5 - Introduction to Cairo - https://youtu.be/CPLiWZmiP2A
        * Lesson 6 - Confidential Tokens - https://youtu.be/Ky6ElYpVYv0
            * Confidential tokens and Aztec not Cairo nor Warp
        * Lesson 7 - Cairo Mini Series (Practical Session) - https://youtu.be/R3jnREBGSjM
            * Practical tutorial: https://extropy-io.medium.com/cairo-mini-series-4633053173f5
            * Scarb docs: https://docs.swmansion.com/scarb/docs
            * Starkli docs: https://book.starkli.rs/installation
            * Starknet Version: https://docs.starknet.io/documentation/starknet_versions/version_notes/
            * Cairo by example: https://cairo-by-example.com/
            * Starknet by example: https://starknet-by-example.voyager.online/
            * Starknet Faucet: https://faucet.goerli.starknet.io/
        * Lesson 8 - Noir and Warp - https://youtu.be/JcX3EOg9VvU 
        * Lesson 9 - Mina - https://youtu.be/lghPTl3rL0k
        * Lesson 10 - zkEVM Solutions - https://youtu.be/qka88pY6IG0
        * Lesson 11 - Risc Zero/PLONK - https://youtu.be/ksWnDElMTHo
        * Lesson 12 - Circom/SNARK Theory - https://youtu.be/d98P7aW38O8
        * Lesson 13 - Stark theory - https://youtu.be/tJOyUBGfVek
        * Lesson 14 - Cryptographic Alternatives / Voting Systems - https://youtu.be/r1w2rsLWN0M
        * Lesson 15 - Identity Solutions, zkML and Oracles - https://youtu.be/H7bdDYtb2H0
        * Lesson 16 - Auditing / Course Review - https://youtu.be/q0J7I-XvA28
        * Tenderly - https://dashboard.tenderly.co/module/encode-tenderly-2023-9?coupon=promo_1MycUgK1YE4Y6l3sOcrGiL07