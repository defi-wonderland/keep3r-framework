# Create your first Automation Vault

An Automation Vault serves as the home for your on-chain automations. 

Within your vault, you can activate various automation networks (for example, Gelato) and select specific tasks they are authorized to perform.

In order to pay for your onchain automation, you can deposit ETH or any ERC20 into your vault.

Let's go ahead and try all this out.


## Step 1: Deploy your vault

First, navigate to [xkeeper.network](https://xkeeper.network/) in your browser. Once there, connect your wallet and select the testnet of your choosing.

Next, click the "Create Vault" button and follow the shown steps.

<video controls width="1280">
  <source src="../../media/how-to/automation_vault/vault-creation.mp4" type="video/mp4">
  <source src="../../media/how-to/automation_vault/vault-creation.webm" type="video/webm">
  Your browser does not support the video tag.
</video>

Well done! You now have created your first Automation Vault 🥳.


### Step 2: Add metadata

Adding a name and description to your vault will make it easier for bots to identify and execute your jobs. Ensure that your description is comprehensive, detailing all the necessary information for task execution.

A compelling metadata entry looks something like this:

> **Name:** My Protocol
> 
> **Description:** Automation of My Protocol reward and distribute jobs. Automation scripts can be found here: [https://github.com/my-protocol/automation-scripts](https://github.com/my-protocol/automation-scripts).

<div class="warning">
Please note, xKeeper operates entirely on-chain. Therefore, storing metadata requires an onchain transaction.
</div>

<video controls width="1280">
  <source src="../../media/how-to/automation_vault/metadata.mp4" type="video/mp4">
  <source src="../../media/how-to/automation_vault/metadata.webm" type="video/webm">
  Your browser does not support the video tag.
</video>

Now, give it a try and add some metadata to your new vault.


### Step 3: Add balance

To prepare your vault for task execution, deposit the necessary funds to cover associated costs.

As an example, let's add some ETH to it. Using your preferred wallet, send ETH to the address of your new Automation Vault.

<video controls width="1280">
  <source src="../../media/how-to/automation_vault/deposit-eth.mp4" type="video/mp4">
  <source src="../../media/how-to/automation_vault/deposit-eth.webm" type="video/webm">
  Your browser does not support the video tag.
</video>


### Step 4: Setup your relays and jobs

Relays act as bridges between your vault and various automation networks. For instance, you can enable the **Keep3rRelay** for Keep3r's network or the **GelatoRelay** for Gelato's services within your vault.

The **OpenRelay** is a unique exception; it doesn't connect to a specific automation network. Instead, it allows any bot to execute your on-chain tasks, compensating them directly with ETH. This approach is particularly attractive to MEV Searchers and contributes significantly to the decentralization of your tasks.

Upon enabling a relay, you also define which tasks it can carry out.

To complete the setup, enable one or more of the following relays in your vault:
* [Open Relay](./open_relay.md)
* [Gelato Relay](./gelato_relay.md)
* [Keep3r Relay](./keep3r_relay.md)