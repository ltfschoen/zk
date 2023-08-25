


will cover zkEVM and verkel trees in the course

### trick with proofs

- degree n of polynomial is the highest power of x of that polynomial
- root is evaluating polynomial at a point
- i.e. (x-r)(Q(x))=0
- decompose into polynomials of less degrees


if two poly's that are different, the evaluation at any point x will be different, i.e. at 2^250, except at intersections in a graph.  use of proovers and verifiers in zkp

5x^2 + 2x + 1, where coefficients are 2 and 1, so could then enter values of x to evaluate the polynominal

or given a blue line, we'll give you 6 of the points of the line at x-axis values 1,2,3,4,5,6.... so use interpolation to determine the coefficients, legranian polynominals...


### colour blind verifier example

probability changes to 1/(2^k) if repeated
- think of as interactive process, and as probabilistic
- always a finite chance that the verifier is given a false proof, and it turns out to be accepted, so want to reduce that chance

Quote from Vitalik Buterin
===
- able to generate proof of something quickly, even though original computation would have taken a really long time



### Q&A

why is it so important to know or use these various curve types? Are there downsides to each or limitations that we need to know?
- yes, for example quantum resistance.

How are we doing P + Q? As P and Q would be of type (x,y).
- check Montgomery curves and their arithmetic: https://eprint.iacr.org/2017/212.pdf

in a blockchain context, i've heard that using a VRF to generate randomness could be gamed by miners/validators. is using a future block hash a better approach?
- VRFs are verifiable, so if validator would game VRF that it wouldn't verify. I would say that block hash can be gamed by builders / validators when they build the block.



DAY 2

argument vs proof

what if proover had infinite power

when creating a proof, you
must be clear what trying to proove
i.e. something has been calculated, and the calculation is correct


homomorphic encryption
- get data, encrypt it, then do math operations on it, then decrypt it, and data still legible
- diagram - outsource computation to third party, but don't want to give info about what data represents (green), 
then (red) they send it back, then they decrypt it and get the results of the computation (red doc)

3+4, encrypt scheme, multiply them, someone else does coputation by adding them, then return results as 14, 
then divide by 2 and get back the answer we want of 7 (not proper example but shows how it works)

link to Medical Data example, sensitive data, outsourced for computation


vanity key example
- keep trying to generate vanity key pair until get it, then try sell it

Complexity Theory

categorise problems in a way, depending on an input, how is time taken to solve the problem depend on the size 
of the input (i.e. efficiency when solving problems), and put them into categories, in terms of time or space
such as memory required to run on computer

i.e. travelling salesman, shortest route... that's our problem, but compare it against size of input,
where only 3 cities, and find shortest route, not take long to find and verify solution,
but takes longer if dealing with 100 cities

categorise problem,
i.e. polynomial
n^k problems are easy/feasible problems to solve
phrase the problem as trying to get a Yes/No answer

both important in complexity theory
- how long does it take to solve a problem
- how long to verify the solution to a problem

classes
- P - polynomial time / easy
    - where have a solution to a problem, and could verify the solution in polynominal time, 
    then it is a P classed problem
    - polynomial time, where size of input is n, if wrote formula of how long to solve problem, it'd 
    be like n^k (i.e. n^3), so can see it graphically...
    if linear, ...
    root n, time taken to solve it happens more slowly
    n^k, time taken to solve it happens more quickly
- NP
    - NP-Complete
    - NP-Hard

might have situation where P == NP


could have one problem, rephrase it as a different problem using "transformations" but of same compexity,
and if could solve one of the problem, it might solve other problems...
complexity is built into the problem

IP class (interactive proof class)
- before it was created, we had static proofs, had assumptions, wrote down steps, last step was what 
wanted to proove, and was acceptd or not.... then zk proofs wanted interaction b/w proover and verifier
not just static... and if verifier could ask questions of proover to check if cheating,
and if verifier could use randomness to check... which led to IP class

Big-O

use notation to compare how fast they are at doing things
O(1) means not dependent on input at all.. so constant regardless of size of input, 
SNARK - small proof sizes
O(poly-log(N))
STARK - better prooving time, but worse verification time

Post-Quantum secure or not - this is because of underlying assumptions (see diagram with timeline of different ZKP Ecosystem)
    - hash functions are quantum secure, so if wanted to find out input using an output, can use brute force...
    and quantime secure offers no advantage?
    - but with discrete log (DLP), if have output, harder to get input, but can also use quantum to do it more efficiently, so open to attack

zk-SNARK
-----

basis of prooving system, to proove to people that you know the square root of a number, give the proof, verify the proof, but they don't know the square root themselves... it tests if you actually know the
square root without revealing it
C computation,
P proof, 
V verify

proving key pk - for the prover
verification key vk - for the verifier
- these are generated once, but could then use them many times to keep prooving that we know the square root of various numbers without revealing them..

private witness is the secret/answer... i.e. 5

public input i.e. 25 

prooving key and public input are send to the verifier


C(x,w) = true

want program to test the knowledge
...
check that answer to test is true


Trusted setups
- important that secret parameter doesn't get into hands of proover
trusted setup is ceremony... so instead of just one person knowing the secret,
multiple people involved, multi-party computation, each proviging some piece of randomness,
if they all colluded they could figure it out... but can't figure out the toxic waste if at least one 
person is honest. e.g. Aztec, ZCash,
it's a way of setting up randomness so people will trust it

program C - to show that ZCash programs were setup correctly... but quite impractical to setup the trusted setups, have to get many people involved... Aztec took a couple of weeks, so a drawback to SNARKS..
but later SNARKS had a "universal setup", so if changed program didn't have to go through that whole process
STARKS don't have to go through that process


trusted setup secret is done only once


but witness could be different each time you get a question and need an answer


Polynomials in ZKPs
- when creating ZK proof systems, we start with program C, then need "transform" it when
creating proofs, which is a number of bits that get sent to the verifier.
there's also the interactive aspect, of what proover and verifier are trying to do,
i.e. do i know sqrt of 25 yes/no.... write program, then transform the ccomputation
both inputs and outputs into a proof which is just some bits, and that process is 
complex, transforming the algorithm into things that are easier to manipulate
that preserves the aspects of ZKP that we want
so it preserves outputs, and has ZK aspects like hiding witness from...
and don't let proover to be able to cheat...
polynomials are heavily involved in this process of steps,
mathmatical objects that we can manipulate them more easily and succinctly
so we're representing our computation as a polynomials

 KZG is a polynomial commitment scheme

Q & A

There are a lot of ways to verify or prove a point when it comes to ZK. What are some things that define a proof done right?

Is the proof Succinctness? Soundness: If the statement is false, no cheating prover can convince the honest verifier that it is true. Non-Interactive: In some cases, the zero-knowledge proof can be designed to be non-interactive, meaning it requires only a single message from the prover to the verifier. Can it be variefed publically

---

Is there trade off between privacy and succinctness for generating proof
Moderator

There is! If you try to shorten the proof size, it might be necessary to reveal more information, thus reducing privacy.

---

Does it mean, using the other ways is prone to errors?

Could you please describe your question in more detail? Which point are you referring to?

---

STARK doesn't use elliptic curve at all?

It relies on hash functions entirely which offers some benefits such as quantum resistant proofs. https://eprint.iacr.org/2018/046.pdf

---

why blockchain system prefers non interactive proof system rather than interactive proof system?

Non-interactive proof system offers better scalability as it do not require additional rounds of communications and can handle large number of transactions. In addition it is extremely efficient since it doesn't need back and forth communication between the prover and verifier.

Mostly because you want to be able to send a single transaction (with a proof) to the verifier smart contract without going back and forth etc.

---

ZKP prove something without reveal it yes ? but then it's don't prove that the information is correct right?

You check the proofs integrity and authenticity. If the proof is valid, the verifier knows that the your solution is true.

---

if the proof is not interactive how it is proved then? yesterday you gave the example of both of them were interactive.

imagine there is an interaction, but squashed into one round proof message heuristic

---

Are there consensus algorithms that use zero knowledge, can there be multiple provers and a single verifier. is rotation/entry/exit possible for provers?

collaborative SNARKS

---

TBC....

the combination of witness variable and public variable is called trust setup?

How we safeguard the algorithm or mechanism used to encode a statement? If this encoding process is visible to an attacker, they might be able to imitate it

By high probability, how the correctness and soundness are measured.


==========


Day 3

proof starts with algorithm, so proof only as good as your algorithm
proof should show that program runs correctly

process of creating a SNARK
program testing what we're trying to proove
then use the system to proove it multiple times
setup creates proovng key, etc

Zokrates
- Go to Remix,
- Choose Zokrates
- Choose Prooving System "Groth16"
- Shows template "Program C" called main.zok, written in Zokrates (not Python)
- Program to test claim that we know the sqrt
    - First arg witness, second arg public key i.e. 5 (witness)
    - Assertion checks if its true i.e. 25, number we want the sqrt of (public input)
    - click Compute, to check that the witness actually works (i.e. if first arg given is `6` then it won't work)
- ZK part is where the program could be shared with the Verifier, and they may want to check that the Test works and generates a secret number
- Click Run Setup
    - generates proving key, verification key
    - generates proof.json
        - which is a Grose 16 SNARK
        - which contains `a,b,c`,
        - where 'inputs' is input `25` in hex, which is "0x0000..019"
        - then pass this as input to a Verification process
        - generates proof in format "Verifier input" to copy/paste and give to them
        ... not possible to determine that we entered witness value of `5`
    - generates elliptic curve bn128
    - in production would need to be more careful

    - generate  verifier.sol smart contract containing Verifiation Key and Publick Function to verify solution to compiled program
        - verifyTx - takes public inupt 25, then verify if true or false using ZK

    - Remix VM Shanghai, 3000000 Gas Limit, click Deploy,
    - paste into verifyTx the "Verifier input" value from earlier, should return `true`

Run this to generate proof, then give it to a verifier, and they can check that we know the sqrt of a number

Front-running
- if have this program, and someone copies the proof, could put in your identity as an argument to main.zok to get around that 

Pairing.json
Pairing_metadata.json


* means there's a multiplicative inverse

Started with main.zok, and want to end up with proof.json
but how move from one to the other, is using Arithmetisation, using Polynomials, and use them with interaction to proove if cheating, and for security, and send proof to verifier contract, didn't have to go back and forth

for SNARKS, we transform the algorithm into something more static, like a piece of hardware with gates, called Arithmetic Circuits, to simplify code into simpler operations like addition and multiplication, then bring together to reproduce the program using gates, and we want witness in there, so if witness is correct, then the circuit will make sense and outputs of the gates add up correctly, so we constrain what is valid to have as inputs

might need to simply code, put intermediate values in, remove loops or only use loops with fixed bound,
then 
add constrains R1CS, a system build from constraints at each gate, 
constrain C to be sum of A and B, for proof to be correct
then create vectors of all gates in system, then transformation into Polynomial from that with relationship to each other whilst maintaining the constraints that allow us to test the proof

Zokrates used to convert code into a circuit, and have to have tests in the DSL of the prooving system

advantage of transformations is we get Polynomials, and get numbers that we can handle mathmatically easier

ci refers to index of a specific gate in the system, so end up with huge relationships


Lesson 3

can create custom gates for doing hash functions.
divide is a problem in a finite field

SNARKS
- security assumptions are falsifyable?
knowledge exponent, can't find an example to proove its wrong, less confidence than a hash function 

Zcash
- want so anyone to verify that tx are correct
- Zcash allows checking things correctly, but don't need access to all tx to verify that tx is correct by using ZK to proove the receive had sufficient balance, etc, but without giving info of who sender and receiver is and what balance that was changed is

Monero
- wasn't initially secure, but now moved to ZKP

Example
- decommissioning nuclear weapons, someone signing that done correct, use AI to proof done, hash the Neural Network Input, then bundle into a proof, then pass to verifier, but verifier doesn't know how neural network is setup

Privacy Preserving Financial Systems

Aztec - gives more complex financial interactions with privacy, built as a layer 2
want EIP1724 Ethereum Standard for Confidential Tokens

Scalability - relies on being able to verify that a computation has been done correctly
Trilema - can't get all in a blockchain : scalability, decentralisation, and security..
i.e. Ethereum had all except scalability

people focusing on turquoise ones in the diagram

Offchain Scaling (Layer 2)
- layer 1/0 used for security.
- layer 2 is for scalability to do tx more efficiently, and taking load away...
Rollups being used like Aztecs

Rollups
tx bundled together, then attest to correctness of tx, then submit that to the Layer 1

ZK or Validity Rollup
provide proof that execution done correct, 
...
verifier contract proove it was done correct, confirm latest state transition done correclty

ZK-Rollups
- ppl send tx into network
- networks achieve scalability by building chains from scratch using experience of people with ethereum, so can introduce improvements not yet seen before, like handle account abstraction (flexibility around how handle accounts and signing that not avail on ethereum, and how to remove unncessary info from tx the size isn't as big, so cheaper since storing data is expensive)
- transactors send tx
- relayers are operators/sequencer
- sequencery send to be executed and proof generated, then send to layer 1

blue slide
left
centralised Layer 2 proover

deposit funds on L1,
msg L2 allows access to L1

operator just collects tx, and then whene enough tx, bundles them up into state transition into block on layer 2, then send to layer 1
operator creates proof ZKP that txs submitted were executed correctly send to verifier
make statement on l1 that it was done correctly



==========


Day 4

==========

- l3 rollup onto a l2 (fractal scaling)
- filecoin uses zkp, proofs that data stored initially and continues to be stored 
    - they use large circuits compared to zcash
- dark forest
    - important to use ZKP in games
    - ppl play games with limit info about game, but rules apply on what ppl can do
    - use zkp to ensure ppl follow rules
    - rules check moves are valid, but don't give away location in the game
    - started in dark forest
- zk microphone
    - issue of fake media, verify the autheticity of audio
- worldcoin
    - todo
- starknet
    - l2 layer
    - zk-rollup uses zkp validity proofs as part of rollup process using STARKs instead of SNARKs
        - STARK provides validity proof of the zk-rollup
    - cairo is language to write contracts in Starknet
    - Starknet Architecture Overview 
        - blue is l2, grey is l1, Full Node is on Starknet (if issue with Starknet sequencer, could get latest state from Ethereum)
        - how it works as l2?
            - own blockchain, takes in tx and generates blocks itself
            - provides proofs of state transitions to l1
        - to build on Starknet
            - smart contracts + UI Dapp creates tx
            - tx specify they want to run code in a smart contract
            - tx picked up by sequencer of Starknet OS, which provides services
            - Cairo runner executes using VM using the functions of smart contracts
            - sequencer execution trace with details of the tx when it was running
            - want generate proof that tx's were run correctly
            - creates proof that set of tx run correctly, and if so create block on l2, and prover uses  details of the tx to generate proof that tx's run correctly, and sent to verifier contract on l1, which checks the succinct, and notify Starknet Core l1 that is correct
        - frontrunning
            - sequencer is centralised currently, run by starkware, chooses tx's to include and in what order
            - sequencer is central point of failure, but planning to have more than one and decentralised, then security important
            - security vs optimisation
                - training wheels
                    - we have centralised sequencers currently, gives false sense of security, someone could put in a fake tx, since relying on the proof
                    - centralised sequencers run by Starkware, but why would they put in a fake tx
                    - need proof water tight for when goes decentralised
            - we get MEV on L2's, but sequencer takes tx directly
            - execution trace is input to the proof
            - want take computation and go through arithmetisation process
        - until verifier has checked the proof, we shouldn't be accepting the latest block,
        but time to go from sequencer to prover to verifier is only minutes for tx to become final,
        so instead send tx to sequencer, application will regard it as being correct, take risk that could be a reorganisation and block rejected on l2, but just accept the tx quickly
        - verifying contract reflects that execution happened correctly using solid proofs
    - cairo language (Safe Intermediate Representation (Sierra)
        - write smart contract in cairo language, changed syntax a lot from v1
        - send tx and pay tx fee to sequencer to cover computation
            - tx weren't being included on Starknet initially, so was attack vector
    - warning - Starknet is changing
    - Builtins - included in contracts but not currently in an optimal way
    - Volition Mode - data availability, we sending data details of tx to L1, since want nodes on L1 to be able to check the state transitions that have happened. alternatively could leave data on L2 but then have aspects of security and ensuring it'll always be available incase nodes on L2 withhold data if it benefits them, and allow people to decide whether to store the data on L1 or L2 when creating the contract
    - fee market for transactions - fixed fees by sequencer
    - proove failed transactions - app specific chains on L3 could be customised if need shorter blocktimes
zkEVM
zkSync

Zustlings
bootcamp repo

================

31 July 2023 - Lesson 5

=================

runner (execution engine)
trace is a step-through of the program, then picked up by sequencer, then prover, who creates proof that execution of the smart contract was done correctly, then proof sent to L1 along with data of the tx 

might accept it on L2 instead of L1, but taking risk if tx rejected, but can update app quicker

Recursive STARKS

incrementally start to work on the proofs before all the txs have arrived, so don't have to hold all tx in memory before starting on the proofs. so at each step can throw away data you had in favour of the aggregated data, and allowing process of working on proofs to start earlier, to speed things up

Application Recursion

application aware... when creating proofs, prover might already know about certain things, not a generic process to be proved, so prover might know semantics of what they are doing (proving the txs, the processing of a fn in a contract has been done correctly) so they can use that knowledge to optimise

Idiomatic Rust

don't have to deal with garbage collector
rust compiler works out what is happening and at what point it can remove things from memory like variables values. 
some things it works out itself, and asks you to follow certain rules during compile time so it can do things safely.
risk of null-pointer if goes out of scope, or point to different value, so follow rules to avoid this, so we have only one owner of a value, and we drop a value from memory when variable out of scope

Cairo, Noir, Zero - use Rust

not everything on the Heap, some primitives on the Stack
complex data types on the Heap, so be careful when copying of what owns them, and check not left without an obvious owner, see "Move" section

Note: data types are wrong in "Control Flow" section...


even with mutable reference you don't necessarily have ownership, just means you can change the value, but still some variable that can change the value

Traits - similar to interfaces in other languages, polymorphism, grouping behaviours together

e.g. `trait Summary`

if you use trait summary, then you need to provide an implementation of the `summarize` function, as shown in the example in the lecture slides

polymorphism - allows referring to multiple objects as a group in the same way (i.e. `notify`), where the data type for `item` is something that must implement the Trait `Summary`, and since `Summary` is defined with an interface including function `summarize`, for this reason it must be implemented and available

Generics - allows parameterising functions across data types


Q & A

* can it be accepted on L2 so can update app quicker, and notify users this response is at risk, but still continue waiting for it to be processed by L1  (edited)  
    * Great question. AFAIK, there is an active communication between the verifier and the prover until the verifier is convinced about the block status. In case it's rejected on L1, all the transactions are rejected on L2 as well.
    * More info: https://book.starknet.io/chapter_4/transactions.html#optional_transaction_finality_in_starknet

* How Solidity vs Cairo comes into this whole bigger picture? in Validating proofs  (edited)  
    * Cairo's efficiency is its ability to create verifiable proofs using a single machine while Solidity requires extensive computation repetition. Here is a great article explaining some of the differences: https://medium.com/starkware/moving-from-solidity-to-cairo-7d44f9723c68



Cairo 
Introduction

is trace that we are running, going to be used in a proof, and what proving, so think carefully.
for example a witness in a proof and secret, like in Cairo Programs (old stuff).
cairo contract everything is public, so more like solidity contracts.
proof is proving what happened in contracts happened correctly and as expected in CairoOS

https://www.starknet-ecosystem.com/

homework - zeroknowledgbootcamp - cairo exercises


Homework 3

if create proof with incorrect witness, why bother having proof
vs if edit proof

proof can have various inputs
data from ethereum system alongside inputs for other proofs to the verifier contract,
but then how much does prover and verifier trust each other
i.e. provide balance... i.e. however we entered the data to verifier and created verifier contract happy with data, but prover might not be happy with source or not satisfied that verifier would be happy with inputs from that source.
trust data source... i.e. oracles
prover and verifier could even be same person... wrote proof, just need verifier to add a witness
so can trust that verifier contract is correct...

Q&A 

if create a proof and add input of their balance, then verify later, possibly the balance might have changed by then, so could be exploited by changing the balance within the proof so it no longer matches, so timing is important


==========

Lesson 6 - Confidential Tokens

==========

Zcash - well designed and implemented project, based on how bitcoin worked so is in the bitcoin camp
verify all tx done correctly, in ethereum since its all public
but in Zcash, they don't need full disclosure of info, they prove tx done correct, but don't need all info public, only need know tx was correct so receiver can accept it and block transition proceeds, so get confidential token

Zcash tx can be transparent or shielded

Zcash tax reporting
- i.e. compliance or audit person with access to shielded tx, goes against decentralisation, CBDCs would definitely want that feature
i.e. canadian bank would need this as a requirement before using any private tokens to prevent money laundering, so need factor this in.

UTXO model - work out what owed based on unspent tx, a natural way to to private tx too.

ZCash has "notes", that represent a value

Nullifier (to show a note has been spent, so note can't be spend again) - prevents double spends.. i.e. Alice cancel her note and allow Bob to have control 
- can deterministically create a Nullifier for a note.
If someone spending a note, check the note hasn't been spent by checking it isn't in the nullifier set which means it shouldn't be used again and need details of a note to be able to work out what a note is for.

can't work out someone's balance for a shielded address
store commitments in Merkle Tries, so can create proofs that an item is in it

The Global ...

preimage hash?


Q: if someone sends you something in the system how do you know you've got it. there's a receiving key to check for it.

Commit Scheme - need randomness so hidden properly. if create a commitment, can't pretend the commitment was for a different message later on, as it binds you to that message, Hiding so other's can't tie you to the message

two inputs and two outputs for the tx
bottlenecks are the hash functions, see "Cryptography Used"


proving time increases as increase circuit size
try reduce time to feasible and increase security

Bulletproofs - another proving system but a more generic system than ZCash (i.e. SNARKS, STARKS, Bulletproofs). it doesn't have a trusted setup, 

Range proofs - could be part of a proving system or application. i.e. showing a value is within a specific range (i.e. balance is between certain values). i.e. proof of solvency
Merkle proofs - to show set membership in a data structure

Grin - proof of zero sum to proove balance transfer

Tornado cash - code on etherscan is similar to Zocrates

Introduction to Aztec

Bottleneck - recalculate merkle root, so for spending, need two tries, need 30 hashes for note tree, 30 hashes for nullifier tree, and 27k gates for arithmetic circuit, so 1.6m gates.
note: PLONK is a type of proving system invented by Aztec

when working with finite fields, need ensure inputs (notes) don't overflow 

==========

Lesson 8 - Noir (by Aztec in Rust) and Warp 

==========

* Warp build an Ethereum Client
* Warp helped devs get up and running with Cairo contracts
* Warp is a transpiler from Solidity to Cairo
    * i.e. a project on Ethereum and want to transfer to Starknet, you could transpile
* Code produced by transpiler varies over time, if use simply and using recognised patterns then they would match targets in Cairo

Aztec (the new one) - Ethereum state is public. Aztec Connect (old version) provided confidentiality around it and focused on DeFI (like Zcash), but new one is going to broaden that an allow private state in general.
It is not a zkEVM approach (i.e. use EVM and create proofs that it works correctly, but not specifically looking at privacy in Ethereum)
UTXO model works well with privacy
Old Aztec UTXO represented value, but in Aztec new can represent a contract or anything
Take their 100+ TPS with grain of salt, have to wait and see

Develop of Aztec use a language called Noir, flexible language for code that ends up as proofs.
Aztec is based on SNARKS and Plonks (they invented this family).
Noir looks at universalities, i.e. write in Noir without being specific about where code would be used, so could be used on many different backends and chains. Noir introduced when Cairo was v0 when lots of nuances, Zokrates was too specific and language limited in what can do, Circom too low level but has improved, and before that was constructing circuits by hand. so Noir wanted high level DSL for zk, similar to python, so can focus on features and code but not worried about where code is going to run.
Noir wants zk languages to be more like traditional languages so ZK aspects wouldn't intrude to improve developer experience.
Noir produces an interface to reduce the coupling
Refer to Aztec blog with layers including Noir Program diagram.

Proving side
    Halo2 is similar to Plonk
    Groth16 similar to SNARK
    zkSync will likely become STARK provers
Create verifier contract and deploy to various blogchains
Blockchain
    Polygon / zkSync - zkEVM approach
    Cosmos - IBC? 

zkEVM (layer 2 approach) is like zkSync write Solidity creates validity zk proofs that txs happened correctly, contrast to Starknet where written in Cairo, and runner executions..
Aztech not doing zkEVM where not changing how Ethereum state works... Aztec doing more powerful by allowing smart contracts with private state

Aztech features 
* Barretenberg - proving sys based on Plonk
* Marlin - idea of write code but not forced to use only Plonk system
ACIR - code compiled into intermediate representation, then interacts with bigger algorithms and hash functions and signature schemes like Sha256, or whatever is available in the backend

Noir example main.nr x is witness, y is public input, but can change to public or private
    * use public values in proof when inputing the in main.nr
Prover.toml
Verifier.toml config, is public input that verifier knows
noir check
noir prove p
noir verifier p (checks if proof is valid, but only if valid proof is assertion does not fail

prover could create proof based on the system that was false, looked like a proof but wasn't not, so fails when gets to verifier

prover knows witness and public
verifier only sees y


Noir Language

Mutability - passed by referene to `helper`, not by value

typically if hear SNARK, think of as zkSMARK

`Field` could mean something different depending on your backend

`contrain` has been deprecated, so use `sa
does Noir have recuriv

Cairo doesn't have same need to add assertions like in Noir, since we adding proof th

testing whether is proof is correct

scalar multiplcation - elliptic curves
schnoo

chec membership - merkle proof to show part of step
ACIR - allows you to target different backends

Fly - polynomial commtment scheme

github.com/noir-lang/noir-web/starter/next

how prevet wintess being exposed??


============

MINA

============

- Recursion to optimise the process
- Mina L1 blockchain, succinct blockchain, has bridge to Ethereum ecosystem, where Mina state stored on Ethereum (wrapped Mina on Ethereum), send proofs of state transitions
- Size of chain not in terms of state but size to verify the state transitions are correct
- Light client checks all merkle roots are correct and blocks, where size increases over time
- But with Mina it's size should be "Succinct" Fixed Size (i.e. 22KB fixed size, instead of 300GB increasing size), so validation done on constrained devices like in browser to validate blocks
- Blockchain state exists and grows, but only on validator nodes, whereas light clients are fixed size
- Block produces can also be SNARK producers
- Roles
    - Block producers, delegate stake, uses Ouroboros PoS from Cardano to select block producer. More stake higher chance selected for a slot and produce block and block reward. VRF chooses who will produce a block. Fortnightly epochs, each block every 10 days or so.
    - ??? create proofs for block producers
- Produce ZKP for each block to prove each block and its transaction, but size increases, so iinstead use recursion... look at block a, zkp of transition from block a to block b was done correctly, then at block b, check an existing proof and a proof of all previous transitions
- proof (STARK) up to a certain block + proof of latest block, and use this proof for light clients, no matter how many blocks we've done. expect size of each STARK to be constant and small, regardless of circuit size
- Mina's "Launch Web Node" is too popular and not working at the moment
- Mina Grants - zkIgnite Cohort 2
- Mina Playground is good web-based IDE
- Mina introducing smart contracts called zkApps
    - on Ethereum, everything public, dapp.update, occurs on all nodes
        - computation on-chain
    - on Mina, snapp.update(x,y -> )
        - computation off-chain, then send proof that transition is correct, and details of zkApp on-chain, not a L2, but security of offchain state 
- Opportunity to apply to oracles 

Suduko Puzzle
- Mina use snarkyjs to write zkApp, write in TypeScript, then snarky compiler. Similar to zokrates

- Inductive Proof System - to use Recursion

- Halo - another type of SNARK
- PLONK - where BN128 is type of curve. reuse parameters not have to setup again from scratch if change
- Groth16 - setup required, if change must setup again
- MNT - pairing, cycles of elliptic curves

Trustless - no toxic waste and multi-party computation

Mina Elliptic Curves - Pallas & Vesta
y^2 = x^3 + 5
- choose curves carefully, so base field of one curve == scalar field of other curve
- we start with a finite field, set of integers, do arithmetic based on that, then create elliptic curve, where x values are from finite field, y values are points on curve that produce a group that is the scalar field
    - do operations on the points

=========

Lesson 11

RISV - general purpose, doesn't require blockchain

does the verifier know exactly what's running?
does the proof have anything to do with what the verifier is expecting?
creator and verifier working together so proof is what the verifier is expecting?

- take hash of binary, giving image id called a receipt, that goes to the verifier
- ELF binary running produces an execution trace like Starknet, then that goes in cryptographic seal that's combined with detailed execution trace.
- public and private inputs go into the Journal
- verifier check that program is what they are expecting, and check the execution, and check the public details like public input to Journal
- proof from the execution (seal is the proof)

Further details
- code constraints transformed into polynomials, then verifier checks polynomials were done correctly

Example RISC programs 
- https://github.com/ExtropyIO/ZeroKnowledgeBootcamp/tree/main/risc0/examples

QAP - quadratic arithmetic process

secret random value is the toxic waste

each proof has its own witness
