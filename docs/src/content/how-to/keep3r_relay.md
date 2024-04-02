# Enable the Keep3rRelay on your Vault

> 🚧 Prerequisite: Please ensure you have completed the [Automation Vault setup](./automation_vault.md) before proceeding.

Keep3r Relay harnesses the technology of Keep3r Network alongside xKeeper, creating a formidable combination that enhances job automation and liquidity management.Traditionally, Keep3r Network users are tasked with registering each job, minting Klp tokens, and individually adding liquidity to ensure Keepers are properly compensated. xKeeper, through the Keep3rRelay, offers a more efficient route.

With xKeeper, you're able to utilize the Keep3rRelay to leverage centralized liquidity provision. This means you register your Automation Vault once, mint Klp tokens just one time, and add liquidity in a single, unified location, rather than repeating the process for each job. The synergy between Keep3r Network and xKeeper via the Keep3rRelay presents a robust solution that reduces the operational overhead for users and provides a seamless experience in managing and automating decentralized jobs.

## Step 1: Enable the relay in your vault

Once inside your vault, click on "Add New Relay", and then select the Keep3r Relay as your relay.

In the Callers section of the window that appears, activate the "Allow any caller" option to permit any address to execute your job. However, remember that within the Keep3r Network, only addresses recognized as Keepers are actually capable of executing the job.

In the context of setting up your job for Keep3r Network, you have to ensure your job is properly configured to interact with the Keep3r ecosystem. After adding your job details in the Jobs section, such as the example provided for testnets, you'll also need to take additional steps to integrate fully with Keep3r requirements.

> Job Address: `0x129f5C4Adf38a1860e54DE46970653465A605364`
>
> Work function: `work (0x322e9f04)`
>
> Keep3rV2: `keep3rV2 address`
>
> IsKeep3r function: `isKeeper (0x6ba42aaa)`
>
> Keep3rV2: `keep3rV2 address`
>
> Worked function: `worked (0x5feeb794)`

Done! Now go ahead and confirm in order to submit the transaction.

<video controls width="1280">
  <source src="../../media/how-to/gelato_relay/setup.mp4" type="video/mp4">
  <source src="../../media/how-to/gelato_relay/setup.webm" type="video/webm">
  Your browser does not support the video tag.
</video>

## Step 2: Setup Keep3r requirements

1. Open your web browser and navigate to [Gelato Network's App](https://app.gelato.network/settings).
   Connect your Web3 wallet by clicking on the "Connect Wallet" button located at the top right corner of the page.

2. Once connected, find and click on the "Create Task" button or link, often found in the dashboard or the side menu.

3. In the Gelato App's "Create Task" interface, you have several options for setting the trigger conditions for your task. Here’s a brief overview of each:

- Time Interval: This trigger allows you to set the task to execute at regular intervals, specified in days, hours, minutes, and seconds.

- Cron Expressions: This is a more advanced scheduling option that enables you to define complex time patterns such as "every Monday at 3 PM" or "every 5 minutes during business hours on weekdays".

- On-chain Event: Choose this trigger to initiate the task based on specific events on the blockchain. For instance, you could trigger a task when a transaction is confirmed or when a certain state change occurs in a contract.

- Every Block: This option will execute the task every time a new block is mined on the blockchain.

4. In the next step of setting up your task, you'll be presented with options for what action should be triggered.

5. To create your task within the Gelato App, you’ll need to fill in the following fields:

- **Network:** Here you select the blockchain network where your task will operate.

- **Solidity function contract address:** This field refers to the contract that contains the checker function. The checker function is what Gelato calls to determine whether your task should execute.

- **Target smart contract:** Input the address of your Gelato Relay as the destination since it's tasked with executing the actions.

6. Lastly, in the "Task Properties" section under "Advanced Settings," toggle on "Transaction pays itself" to ensure the transaction costs are covered and the executor is compensated for executing the task.

In our walkthrough, we've set up a task to trigger every **5 minutes** using the **Solidity Function** as our action point. This configuration is demonstrated in the accompanying example video:

<video controls width="1280">
  <source src="../../media/how-to/gelato_task/setup.mp4" type="video/mp4">
  <source src="../../media/how-to/gelato_task/setup.webm" type="video/webm">
  Your browser does not support the video tag.
</video>

## Verify execution

With all the steps completed, we now have everything necessary to harness the automation capabilities of Gelato Network and xKeeper. This seamless integration allows us to set up tasks that are automatically executed, with payments and incentives managed through the Automation Vault, ensuring a streamlined process for users and fair compensation for executors.

To verify the executions of your tasks, you can conveniently check the dashboard of xKeeper as well as the Gelato App.
