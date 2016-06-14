Pampran
=======

Packer script to create an AMI with MySQL, Papertrails, Redis, Node.js, and NewRelic installed.

The AMI contains scripts that will poll an specified S3 bucket for a node package, in the form of a tar file. When a new version appears in the S3 bucket, it will be installed and started with npm. If a previous version of the server is running, its process will be killed before the new version is started.

Requirements
------------
To use this, you must:

0. Have an interest in using node.js with Redis and MySQL
0. Have an AWS account
0. Have a Papertrail account, a free one is fine (see papertrailapp.com)
0. Fork or clone this repo onto your dev machine
0. Have packer installed on your local system (linux or OSX, see packer.io for install instructions)

Procedure
---------
#### Step 0, AWS CLI

Make sure you local system has the AWS CLI installed and working. See http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-set-up.html for help with this.

#### Step 1, Packer build
Run the packer build, which will take a few minutes:

```
    cd pampran
    packer build \
      -var 'newrelic=bf3822a825435e9ca51c0865949aeca5ce123eaf' \
      -var 'pthost=logs2.papertrailapp.com' \
      -var 'ptport=12345' \
      -var 'region=us-west-2' \
      -var 'ami=ami-d0f506b0' \
      packer.json
    ```

This will create an AMI that can run your node/redis/mysql app. This is intended for low-cost application testing, as it runs everything in one instance. A future project (pampran-cf) will include AWS CloudFormation templates appropriate for a production deployment of an app using reliable, separate deployment of redis and mysql and deployment of the node servers behind ELB with an autoscaling group.

#### Step 2, Create IAM role
To create an instance for testing, first create an IAM profile for AmazonS3ReadOnlyAccess. (See http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html for help with this.)

#### Step 3, Create S3 bucket

In this example, we create a bucket for the node package in the test directory called 'simple'. Keep in mind that S3 bucket names must be globally unique, even if they are private buckets, as in this example. You need to use your own bucket name, and make it weird enough to be globally unique or the command will fail

`aws s3 mb s3://simple.freak-domain.party`

#### Step 4, Upload your node package to the bucket

We provide a shell script for this. The script uploads into the bucket a file named 'version' which consists of three lines:

1. A unique version id, which must be a valid directory name. The script uses the current date.
2. The name of the tar file for the npm package
3. The name of the package (for npm Starting)

It also uploads the npm package as a tar file. The script runs `npm pack` to create the tar file. Example:

`cd test/simple`
`../../tools/upload.sh simple.freak-domain.party`

#### Step 5, Start an EC2 instance

To test this, launch an EC2 instance from the AWS console:
1. In the EC dashboard, select AMI, the choose the AMI that was just built by Packer.
2. Press the Launch button, and in the launch wizard choose an instance type (micro or small is fine for a test.)
3. Next: Configure Instance Details, then select the IAM role you created in step 2.
4. Continue through the Wizard to Tag Instance, pick a name you will recognize, then create another tag with the Key: "tarBucket" with the value being the name of the s3 bucket you created in step 3, e.g. "simple.freak-domain.party".

When this instance comes up, it will download the 'simple' package from the tarBucket, and start it.

#### Step 5, Monitor server log with Papertrail

Go to papertrailapp.com (you should have created an account there before starting this) and select the 'events' tab. The log messages for the server you started will show up next to the AWS internal IP address for the EC2 instance.

Generally you will not need to ssh into your instance, since you can see the logs here. If you see a bug, you very often can fix it in your node code and use the tools/upload.sh script to deploy the fix.

This can be a nice way to do live development for the server for a mobile app, so you can test the deployed app on your phone while you monitor the server with papertrail and fix problem by uploading new code to S3.


Known Bugs
==========
1. When rebooting instance, it will not start the app if the app does not need to be pulled from s3
2. Logging is going to forever.log instead of out.log
