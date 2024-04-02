# How to Generate execData

Welcome to our tutorial on how to efficiently and simply generate execData. If you're automating tasks on the blockchain with xKeeper, this guide is designed to walk you through the process step by step.

## Get Encode Data

Execution of jobs through Relays requires specific data

Jobs should always be executed through Relays. In this case, we need to generate the data needed to call the `exec` function.

Let's gather the needed information:

#### `_automationVault`

Your vault's address.

#### `_execData`

This encapsulates the encoded function signature of your job and its parameters. A typical `_execData` example is as follows:

````json
[{ "job": "<JOB_ADDRESS>", "jobData": "<JOB_DATA>" }]

### Using Chisel to get Job Data

#### Prerequisites

Before we start, make sure you have Foundry installed. Foundry includes forge for compiling and testing your contracts, as well as chisel, a CLI tool that makes it easier to interact with EVM bytecode and ABI data.

Open your terminal and navigate to your project directory. If you haven't already initialized a project with Foundry, you can do so by running forge init [your_project_name].

Chisel is an incredibly useful tool for encoding functions and arguments in the correct format for the blockchain. We'll use Chisel to generate the execData you need.

Run chisel in your terminal to start the CLI interface. To encode a function call, use:

```bash
> chisel
> abi.encodeWithSignature("function()", args)
````

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

### Understanding the Output

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

### Using ethers.js in TypeScript to get Job Data

#### Prerequisites

Ensure Node.js and npm are installed in your environment.

Initialize a new Node.js project if you haven't already by running npm init in your project directory.

Install ethers.js in your project using npm:

```bash
npm install ethers
```

If TypeScript is not yet set up in your project, install it along with the necessary types for Node.js:

```bash
npm install typescript @types/node --save-dev
npx tsc --init
```

Ensure your tsconfig.json is configured for your project needs.

Create an instance of ethers.utils.Interface with the ABI of the contract containing the function you want to encode. Then, use encodeFunctionData to encode the function call.

```typescript
import { ethers } from "ethers";

const abi = ["function workHard(uint256 _howHard)"];

const iface = new ethers.utils.Interface(abi);

const encodedData = iface.encodeFunctionData("workHard", [100]);

console.log(encodedData);

("0x3bb39c33000000000000000000000000000000000000000000000000000000000000006400000000000000000000000000000000000000000000000000000000");
```

## Additional Tips

Experiment with Different Functions: Don't limit yourself to just one function. Try out different function signatures to get familiar with how the encoded data changes.
