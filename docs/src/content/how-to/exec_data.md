# How to Generate `execData`

The `exec` function shared by every Relay requires a specific argument: `IAutomationVault.ExecData[] calldata _execData`. This guide covers the process of generating this essential data component.

How can you generate that exec data?

## Structure of `_execData`

The `_execData` is a collection that includes the encoded function signature of your job along with its parameters. Here’s how the `_execData` looks like:

```json
[{ "job": "<JOB_ADDRESS>", "jobData": "<JOB_DATA>" }]
```

### Generating Job Data with `chisel`

**Prerequisite:** Ensure you have [Foundry](https://book.getfoundry.sh/getting-started/installation) installed.

To generate your job data, execute the following commands in your terminal:

```bash
> chisel
> abi.encodeWithSignature("work(uint256)", 420)

Type: dynamic bytes
├ Hex (Memory):
├─ Length ([0x00:0x20]): 0x0000000000000000000000000000000000000000000000000000000000000024
├─ Contents ([0x20:..]): 0x5858d16100000000000000000000000000000000000000000000000000000000000001a400000000000000000000000000000000000000000000000000000000
├ Hex (Tuple Encoded):
├─ Pointer ([0x00:0x20]): 0x0000000000000000000000000000000000000000000000000000000000000020
├─ Length ([0x20:0x40]): 0x0000000000000000000000000000000000000000000000000000000000000024
└─ Contents ([0x40:..]): 0x5858d16100000000000000000000000000000000000000000000000000000000000001a400000000000000000000000000000000000000000000000000000000 <-- YOUR NEEDED DATA
```

Grab the Contents field of the result, and use that as your `<JOB_DATA>`.


### Generating Job Data with `ethers.js`

For those who use JavaScript, ethers.js provides a straightforward method to obtain your job data. Below is an example:
```js
abi = ["function work(uint256 _someData)"];
iface = new ethers.utils.Interface(abi);
encodedData = iface.encodeFunctionData("work", [420]);

> "0x5858d16100000000000000000000000000000000000000000000000000000000000001a4"
```

Try copy pasting the previous lines of code in the [Ethers Playground](https://playground.ethers.org/) to see the expected output.

Grab the value of `encodedData`, and use that as your `<JOB_DATA>`.