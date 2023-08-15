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
    * Sequence Diagrams - https://sequencediagram.org/
