# ec2-steamStreamer
terraform and powershell code to automate the creation of a windows ec2 instance running steam

- The utlimate goal here is, partly, to sketch this up with providers and similar instance types for Azure and GCP, and see if any one cloud provider's service offering works better for this use case than the others, but mostly, to play with terraform and learn how to bootstrap windows instances with powershell.

- Testing is being done with the Monkey Island games.  On a manually built version of this thing, Secret of Monkey Island audio was somewhat choppy, but not bad and video was fine.  Escape from MI wouldn't even start streaming, it just hung, probably because of a failed DirectX install.  Tales of MI streamed, but was so choppy it was unplayable.  I suspect this is a limitation of my home internet speeds (about 125-ish down and 100-ish up), but it's worth trying it on different instance types and with similar instance types with different cloud providers, before I take the shameful and soul-crushing route of installing Windows 10 on my laptop.

### TODO:

- nvidia driver installs, but default display driver doesn't get disabled.
- ZeroTier vpn client should be installing correctly now, but joining the network is still a manual process.  Need to somehow pass the network id as a param all the way to the userdata and modify the powershell script to read it.  Probably using environment variables.
- work out how to do this as an Azure VM and/or GCE instance.

### Notes:

- One annoying thing about the powershell script is the need to convert back and forth between newlines and newlines with carriage returns, otherwise the userdata gets passed as a single line. unix2dos and dos2unix tools help somehwat, but it's still incredibly annoying.
- chocolately install of vb-cable doesn't work because there's no longer a silent install option. Powershell script downloads and extracts the package, but VBCABLE_SETUP_x64.exe needs to be run manually.
- xfreerdp script generation is working now.  TF waits for and attempts to decrypt the local Administrator password using the private key of the keypair  provided (assuming the key is in ~/.ssh and has the same name as the keypair specified, with a .pem suffix) and plunks the plaintext password into the script.  If this were any sort of long lived system or one that could be used to gain access to sensitive resource, this would be a terrible bad idea.  Since it's a throwaway instance used soley for video games, it's only idea that's only mostly bad.

## Pre-deployment tasks:

1. Clone this repo, set up your AWS CLI credentials/tokens and install terraform.  Google around for a bit if you don't know how to do this.

2. Sign yourself up for an account on Zero Tier and create a VPN.  Make a note of the address space you'll be using.

https://www.zerotier.com/

3. Install the Zero Tier client on your local machine and join the network you created.  You can find documentation on this on the Zero Tier site.

4. Decide on an AWS region, AMI, and VPC, and make a note of these id's.  Create a security group in that region and VPC that allows the following inbound (and everything outbound):

   - RDP (TCP 3389) from only your ip address ("My IP" in the ec2 security group console dropdown)
   - All Trafic from the address space of your Zero Tier VPN network.

 5. Create an EC2 keypair and download the private key.  You'll need it to decrypt the Administrator password.

 6. Populate the terraform variables, either by changing the default values in variables.tf or passing them on the CLI.  Specifically, set the AMI, secuirty group id, and keypair (all from step 4), and optionally change the instance type if you want a different instance type.

 Note: the vpcid variable currently isn't used, as the vpc gets matched via the security group parameter.

## Deploy:

 1. Run terraform init to download the providers.

 2. Run terraform plan to see what will be created, terraform apply to create it, and/or terraform destroy to tear it all down.

 3. RDP in, see if things are working, join the zerotier network, authorize the new node on your zerotier network, install VB-Cable, log into steam, click the noLockLogout shortcut, login to steam on your local linux machine, and see if you can stream your windows games.