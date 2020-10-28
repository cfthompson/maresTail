# ec2-steamStreamer
terraform and powershell code to automate the creation of a windows ec2 instance with steam

The utlimate goal here is partly to sketch this up with providers and similar instance types for Azure and GCP as well, and see if any one works better than the others, but mostly to play with terraform.

Note: the powershell script seems to work when run manually, but when run as userdaya, it currently only runs the first line, starting the log file, then hanging. One problem was the missing carriage returns for the line breaks, but even after solving that with unix2dos, it still only runs the first line.  Stillinvestigating...