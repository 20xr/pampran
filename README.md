Pampran
=======

Packer script to create an AMI with MySQL, Papertrails, Redis, Node.js, and NewRelic installed.

The AMI contains scripts that will poll an specified S3 bucket for a node package, in the form of a tar file. When a new version appears in the S3 bucket, it will be installed and started with npm. If a previous version of the server is running, its process will be killed before the new version is started.

For the simplest configuration, the Pampran AMI can be used to create an EC2 instance to run a node application.

For a more scalable configuration, this project also contain AWS CloudFormation templates to deploy EC2 instances based on the AMI as part of an autoscaling group behind a load balancer. The node.js servers may use an RDS (or Aurora) instance, and an Elasticache Redis cluster.

Requirements
------------
To use this, you must:

0. Want to use node.js with Redis and MySQL
0. Have an AWS account
0. Have a Papertrail account, a free one is fine (go to papertrailapp.com to sign up)
0. Have a (free) license for NewRelic on EC2 (go to newrelic.com/aws to sign up)
0. Fork or clone this repo onto your dev machine
0. Have packer installed on your local system (linux or OSX, see packer.io for install instructions)

Procedure
---------
#### AWS CLI

Make sure you local system has the AWS CLI installed and working. See http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-set-up.html for help with this.

#### Packer build
Run the packer build, which will take a few minutes:

```
cd pampran

packer build \
  -var 'region=us-west-2' \
  -var 'ami=ami-d0f506b0' \
  -var 'pthost=logs2.papertrailapp.com' \
  -var 'ptport=12345' \
  -var 'newrelic=bf3822a????????????????????????5ce123eaf' \
  packer.json
```

The vars passed for the build command will be specific for your requirements:

* **region** is the AWS datacenter you want to use (us-west-2 is Portland, OR)
* **ami** is the base AMI to start with, which will vary with the region. Use Amazon Linux HVM for the region you choose. You can get the AMI id by clicking "Launch Instance" form the EC2 console screen and copying the first AMI in the list. ami-d0f506b0 is one for us-west-2 around summer 2016. Get the latest!
* **pthost** is the host name for your Papertrail account. Get this from papertrailapp.com by clicking on the "Add System" button.
* **ptport** is the port number for the same.
* **newrelic** is the license id you get from signing up for a free standard account at NewRelic.com

### Single EC2 instance deployment
The following steps are for deploy a dev or test environment on a single (possibly micro) EC2 instance. Later, if you want a scalable and reliable production setup, skip down to *CloudFormation Deployment*.

#### 1. Create IAM role
To create an instance for testing, first create an IAM profile for:

0. AmazonS3ReadOnlyAccess
0. AmazonEC2ReadOnlyAccess

(See http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html for help with this.)

#### 2. Create S3 bucket

In this example, we create a bucket for the node package in the test directory called 'simple'. S3 bucket names must be globally unique, even if they are private buckets, as in this example. You need to use your own domain name, or make it weird enough to be globally unique, or the command will fail

`aws s3 mb s3://simple.freak-domain.party`

#### 3. Upload your node package to the bucket

A shell script is provided for this.

`tools/uploadPackage.sh`

The script uploads into the bucket a file named 'version' which consists of three lines:

1. A unique version id, which must be a valid directory name. The script uses the current date.
2. The name of the tar file for the npm package
3. The name of the package (for npm Starting)

It also uploads the npm package as a tar file. The script runs `npm pack` to create the tar file.

You can try this out with the trivial node package in the test directory.

Example:

`cd test/simple`
`../../tools/uploadPackage.sh simple.freak-domain.party`

#### 4. Start an EC2 instance

To test this, launch an EC2 instance from the AWS console:
1. In the EC dashboard, select AMI, the choose the AMI that was just built by Packer.
2. Press the Launch button, and in the launch wizard choose an instance type (micro or small is fine for a test.)
3. Next: Configure Instance Details, then select the IAM role you created in step 2.
4. Continue through the Wizard to Tag Instance, pick a name you will recognize, then create another tag with the Key: "tarBucket" with the value being the name of the s3 bucket you created in step 3, e.g. "simple.freak-domain.party".

When this instance comes up, it will download the 'simple' package from the tarBucket, and start it.

#### 5. Monitor server log with Papertrail

Go to papertrailapp.com (you will have created an account there before starting this) and select the 'events' tab. The log messages for the server you started will show up next to the AWS internal IP address for the EC2 instance.

Generally, you will not need to ssh into your instance, since you can see the logs here. If you see a bug in the log, you can fix it in your node package and use the tools/uploadPackage.sh script to deploy the fix.

This is a convenient to do live development for the server for a mobile app, so you can test the deployed app on your phone while you monitor the server with papertrail and fix problem by uploading new code to S3.

### CloudFormation deployment

WARNING: This is work in progress, so don't try this right now...

In the cf directory, there is a CloudFormation template, stack.json.

When you run the script,
```
cd cf

./create-stack.sh
```

It asks you for a stack name (e.g. dev, test, prod), a domain name (your's hopefully) and an AMI id, which will be tyhe one you just created with Packer.

It then calls aws cloudformation create-stack, which starts the process of creating a stack on your AWS account. To monitor the progress, go the the CloudFormation console for AWS.

There is a lot to know about CloudFormation, so you will have to read the docs and the stack.json template to figure out what is going on. I have tried to make the template as simple as possible, given what it is intended to do. :-)
