# ec2-steamStreamer
terraform and powershell code to automate the creation of a windows ec2 instance running steam

The utlimate goal here is partly to sketch this up with providers and similar instance types for Azure and GCP as well, and see if any one works better than the others, but mostly to play with terraform.

## TODO:

- create instructions for manually creating security group and using its id as a parameter rather than doing it in terraform.  0.0.0.0/0 for rdp "would be bad"
- the powershell script seems to work when run manually, but when run as userdaya, it currently only runs the first line, starting the log file, then hanging. One problem was the missing carriage returns for the line breaks, but even after solving that with unix2dos, it still only runs the first line.  Need to learn more about powershell
- Testing with the Monkey Island games.  Secret of Monkey Island audio was somewhat choppy, but not bad and video was fine.  Escape from MI wouldn't even start streaming, it just hung.  Tales of MI streamed, but was so choppy it was unplayable.  I suspect this is a limitation of my home internet speeds, but it's worth trying it on different instance types before doing anything drastic and soul crushing, like installing Windows 10 on my laptop.