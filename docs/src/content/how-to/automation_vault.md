# Create your first Automation Vault

An automation vault is the home to your onchain automation. You can deposit ETH or any ERC20 into it, and use it for automation payments.

Inside your vault, you can also enable multiple automation networks (i.e. Gelato), and define which jobs can they work.

## Step 1: Deploy your vault

Go to [xkeeper.network](https://xkeeper.network/) in your browser, connect to your favorite chain, and click on "Create Vault".

<video controls width="1280">
  <source src="../../media/how-to/automation_vault/vault-creation.mp4" type="video/mp4">
  <source src="../../media/how-to/automation_vault/vault-creation.webm" type="video/webm">
  Your browser does not support the video tag.
</video>

Well done! You now have created your first Automation Vault 🥳.


### Step 2: Add metadata

Adding a name and description to your vault will make it easier for bots to identify your job. Make sure to include everything needed for the execution of your job in the description.

The better your description, the more amount of bots will be able to run it. A good job metadata could be:

> **Name:** My Protocol
> 
> **Description:** Automation of My Protocol reward and distribute jobs. Automation scripts can be found here: [https://github.com/my-protocol/automation-scripts](https://github.com/my-protocol/automation-scripts).

<div class="warning">
xKeeper is a fully onchain protocol. Metadata is stored onchain, thus it requires a transaction.
</div>

<video controls width="1280">
  <source src="../../media/how-to/automation_vault/metadata.mp4" type="video/mp4">
  <source src="../../media/how-to/automation_vault/metadata.webm" type="video/webm">
  Your browser does not support the video tag.
</video>

Go ahead, try it out and add some metadata to your newly created vault.


### Step 3: Add balance

Transfer the necessary funds to your vault to cover the costs associated with task execution.

For this example, let's go and add some ETH to it. Using your favorite wallet, transfer ETH to your newly created automation vault address.

<video controls width="1280">
  <source src="../../media/how-to/automation_vault/deposit-eth.mp4" type="video/mp4">
  <source src="../../media/how-to/automation_vault/deposit-eth.webm" type="video/webm">
  Your browser does not support the video tag.
</video>


### Step 4: Setup your relays and jobs

Relays are the connection between xKeeper and different automation networks. For example, inside your vault, you can enable the **GelatoRelay** to use Gelato's automation network, or **Keep3rRelay** to use Keep3r's.

There is one exception to the rule, the **OpenRelay**, which is not connected to any automation network. This relay will let **any bot** execute your onchain jobs, and get directly rewarded with ETH for it, attracting MEV Searchers and maximising your further contributing to your job's decentralization.

When you enable a relay, you will also specify which jobs you allow it to execute.

As the final step, go ahead and enable one of the following relays to your vault:
* [Open Relay](./open_relay.md)
* [Gelato Relay](./gelato_relay.md)
* [Keep3r Relay](./keep3r_relay.md)