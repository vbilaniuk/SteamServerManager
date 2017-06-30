import boto3
from operator import itemgetter # for the sorting, later

description = 'ARK Backup Test Server' # TODO: make the description user settable

# bizarre method to get the instance ID because apparently this functionality is missing from boto3:
import urllib2
instanceId = urllib2.urlopen('http://169.254.169.254/latest/meta-data/instance-id').read()

# get this instance's volume ID:
ec2 = boto3.resource('ec2')
instance = ec2.Instance(instanceId)
volumes = [v for v in instance.volumes.all()]
root = volumes[0].id

# now we can make a snapshot with that volume ID:
result = ec2.create_snapshot(VolumeId = root, Description = description) 

# and we delete the oldest one:
# this grabs the account number programmatically:
iam = boto3.client('iam')
account = iam.get_user()['User']['Arn'].split(':')[4]

# get all the snapshots for this account only
ec = boto3.client('ec2')
snapshots = ec.describe_snapshots(OwnerIds=[account])

# sort them: 
# first we have to put the IDs and date/times in a new list, as an actual LIST
snapList = []
for snap in snapshots['Snapshots']:
  snapList.append([snap['SnapshotId'], snap['StartTime'], snap['Description']])

# now we can sort:
snapList = sorted(snapList, key=itemgetter(1))

# and delete the first one that has the right description:
counter = 1 # we want 5 snapshots total so we need to do some counting
for item in snapList:
  if item[2] == description:
    if counter == 1:
      # this is the first one so let's keep track of it
      deletionCandidate = item[0]
    print item
    if counter > 5:
      # we have 5, so we can go ahead and delete the oldest one
      print "Going to delete snapshot ID: ", deletionCandidate
      ec2resource = boto3.resource('ec2')
      snapshot = ec2resource.Snapshot(deletionCandidate)
      snapshot.delete()
      break
    counter = counter + 1

# crontab entry: 
# crontab -e
# 0 * * * * /usr/bin/python /home/ubuntu/scripts/createSnapshot.py