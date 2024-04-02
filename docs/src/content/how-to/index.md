# How to Generate execData

Welcome to our tutorial on how to efficiently and simply generate execData. If you're automating tasks on the blockchain with xKeeper, this guide is designed to walk you through the process step by step.

## Prerequisites

Before we start, make sure you have Foundry installed. Foundry includes forge for compiling and testing your contracts, as well as chisel, a CLI tool that makes it easier to interact with EVM bytecode and ABI data.

## Step 1: Setting Up Your Environment

Open your terminal and navigate to your project directory. If you haven't already initialized a project with Foundry, you can do so by running forge init [your_project_name].

## Step 2: Using Chisel to Encode Data

Chisel is an incredibly useful tool for encoding functions and arguments in the correct format for the blockchain. We'll use Chisel to generate the execData you need.

Run chisel in your terminal to start the CLI interface. To encode a function call, use:

```bash
> chisel
> bytes32(abi.encodeWithSignature("function()", args))
```

### Without Arguments

Let's start with a simple function that does not require any arguments. The function signature might look like this in Solidity:

```bash
function work() public;
```

To encode this using Chisel for generating execData, you would use:

```bash
> chisel
> abi.encodeWithSignature("work()")

Type: dynamic bytes
├ Hex (Memory):
├─ Length ([0x00:0x20]): 0x0000000000000000000000000000000000000000000000000000000000000004
├─ Contents ([0x20:..]): 0x322e9f0400000000000000000000000000000000000000000000000000000000
├ Hex (Tuple Encoded):
├─ Pointer ([0x00:0x20]): 0x0000000000000000000000000000000000000000000000000000000000000020
├─ Length ([0x20:0x40]): 0x0000000000000000000000000000000000000000000000000000000000000004
└─ Contents ([0x40:..]): 0x322e9f0400000000000000000000000000000000000000000000000000000000
```

### With Arguments

Now, let's encode a function that takes arguments. For example, the function signature in Solidity might be:

```bash
function workHard(uint256 _howHard) public;
```

To encode a call to this function with a specific value for newThreshold using Chisel, the command would look something like this:

```bash
> chisel
> abi.encodeWithSignature("workHard(uint256)", 100)

Type: dynamic bytes
├ Hex (Memory):
├─ Length ([0x00:0x20]): 0x0000000000000000000000000000000000000000000000000000000000000024
├─ Contents ([0x20:..]): 0x3bb39c33000000000000000000000000000000000000000000000000000000000000006400000000000000000000000000000000000000000000000000000000
├ Hex (Tuple Encoded):
├─ Pointer ([0x00:0x20]): 0x0000000000000000000000000000000000000000000000000000000000000020
├─ Length ([0x20:0x40]): 0x0000000000000000000000000000000000000000000000000000000000000024
└─ Contents ([0x40:..]): 0x3bb39c33000000000000000000000000000000000000000000000000000000000000006400000000000000000000000000000000000000000000000000000000
```

## Step 3: Understanding the Output

The output Chisel provides you is a hash that represents the encoded data of the function you want to call. For example:

```bash
Type: dynamic bytes
├ Hex (Memory):
├─ Length ([0x00:0x20]): 0x0000000000000000000000000000000000000000000000000000000000000024
├─ Contents ([0x20:..]): 0x3bb39c33000000000000000000000000000000000000000000000000000000000000006400000000000000000000000000000000000000000000000000000000
├ Hex (Tuple Encoded):
├─ Pointer ([0x00:0x20]): 0x0000000000000000000000000000000000000000000000000000000000000020
├─ Length ([0x20:0x40]): 0x0000000000000000000000000000000000000000000000000000000000000024
└─ Contents ([0x40:..]): 0x3bb39c33000000000000000000000000000000000000000000000000000000000000006400000000000000000000000000000000000000000000000000000000
```

This hash is what you would pass as execData to execute the workHard(uint256 \_howHard) function on your smart contract through xKeeper or any other automation platform.

The data that we have to use is the contests.

## Additional Tips

Experiment with Different Functions: Don't limit yourself to just one function. Try out different function signatures to get familiar with how the encoded data changes.
