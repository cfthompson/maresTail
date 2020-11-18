# maresTail azure-packer
packer code to build an azure image

### Notes:

- The powershell script doesn't entirely work in Azure and blows errors. This can cause the build to fail. Commenting out the problematic lines and adding "exit 0" to the last line seems to work, though the sysprep line is one of the ones that fails and the final image hasn't been tested.  Baby steps.
- It turns out that the Azure builder isn't implemeented on Packer for Debian, so what testing has been done on this code was done in the Azure cloudshell.
- So far, attempts to populate variables with a var-file have been unsuccessful, and only setting them in the builder block of image.json has worked. This is probably some sort of synta problem I haven't worked out yet, but in any case, doing it this way sucks and needs to be made better.

## Usage:
1. Clone this repo

2. Set up your Azure credentials and create a resource group in the portal.  You need a subscription id, a client id, and a client secret. You also need a resource group name.

3. Populate these variables in image.json

4. Run "packer validate image.json" to validate the image

5. Run "packer build image.json" to build it.  Be sure to remember to go into your resource group in the portal and delete it when you're done if you want to avoid the charges incurred for keeping it around when you're done using it.
