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

To fully integrate your job with the Keep3r Network, you must complete a series of steps:

1. Register Your Job: Navigate to the [Keep3r Network dashboard](https://keep3r.network/) and click on register job. The address that should be used has to be your deployed automation vault.

2. Click on your register jon and mint Klp tokens directly through the Keep3r Network. Ensure you have enough tokens to cover the expected work.

3. Add Liquidity: Once you have the Klp, you will have to add liquidity to the job, in this case the automation vault. With this the different keepers will be able to get paid.

<video controls width="1280">
  <source src="../../media/how-to/gelato_task/setup.mp4" type="video/mp4">
  <source src="../../media/how-to/gelato_task/setup.webm" type="video/webm">
  Your browser does not support the video tag.
</video>

We already have everything we need to be able to work in xKeeper with Keep3r network. With all this configuration the Keepers will be able to work through the keep3r relay and will receive the payment of the previously added liquidity.

## Verify execution

Within the activity tab in our xKeeper automation vault, we will have all the necessary data of the executions made by the different keepers through Keep3r Network.
