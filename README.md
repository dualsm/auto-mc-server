# auto-mc-server ⛏️


## a simple terraform script to run an mc server

This is a 3️ step guide, including environment setup, launching AWS, and getting connected 

⚠️ The code for this project was partially created and further assissted by Copilot and ChatGPT-o4. It is intended for individual use and does not have security provisions.   

I also drew file-separation inspiration from this repository, though I did not use any code from here: https://github.com/DavidMikeSimon/McTerraform/
<br><br>

---
### **Checklist ✅ - Complete before Step 1**
-  AWS CLI is installed 
-  Terraform is installed
-  📁 Directory created for the scripts to be placed in

| Software | link to download |
|---------|-----------|
| 🧡 AWS CLI  | [AWS CLI Install guide](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html#getting-started-install-instructions)|
| 💜 Terraform| [HashiCorp Terraform Install Guide](https://developer.hashicorp.com/terraform/install)|

<br>

> Recommendations:
> - Use a linux-based command terminal ([Git bash](https://git-scm.com/downloads) is a good one if using Windows), Otherwise, adapt commands for Windows.
> - Install the AWS CLI at your home directory (`cd ~` before installing!)
> 

## Step 1️⃣: Setting up our environment 

Create your ~/.aws/ directory for AWS CLI & Terraform to access your credentials.

```bash
mkdir ~/.aws/
```

Place your AWS credentials _([how to find](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html))_ in your ~/.aws/credentials for terraform to use. 

```bash
echo "[REPLACE_WITH_AWS_CLI_CREDENTIALS]" >> ~/.aws/credentials
```

Create a keypair for your scripts to authenticate with! Keep in mind, you will need this specific keypair in the case you want to access the minecraft server. 

```bash
aws ec2 create-key-pair --key-name my-minecraft-key --query 'KeyMaterial' --output text > ~/.ssh/my-minecraft-key.pem
```

Adjust permissions on key so it's only readable.  

```bash 
chmod 400 ~/.ssh/my-minecraft-key.pem
```

> These setup steps are crucial for the next portion, if there are any errors in the credential setups then debugging later will be hard. 

## Step 2️⃣: Configuring Terraform scripts

**Clone the repository into your directory.**

Scan through the files, replacing [provider region in variables.tf](./variables.tf) and [amazon machine image in main.tf](./main.tf) (ami) to your desired region. 

Making sure you are within the correct directory, run the following commands to configure terraform. Pay attention to errors at this step, as they might arise (especially when `terraform apply`-ing!)

```bash
terraform fmt
```

then 

```bash
terraform init
```

then 

```bash
terraform apply
```

then press yes when it asks you! 

It should take around 2 minutes for the server can be up and running. 

> <font color="pink"> If there are ❌ **ERRORS**, read them and make sure you followed the proper setup steps, especially the credentials and keypair setup. </font>
>
> If the keypair did not get configured correctly and you need to make a new one (with a different name), you will need to adjust the "private_key" field in the connection block and the "key_name" in the "aws_instance" block.

## Step 3️⃣: Connect to the Server 🌐

Successfully running the script should print out instance_public_ip="**generic_ip_here**" in our terminal. 

📋 Copy that into your minecraft server address on the minecraft client

Connect, and have fun!

<font color="turquoise"> If you encounter "**getsockopt**" error, give the server some more time to setup. If after 5-6 minutes the server prints its IP address it is still not connecting, retrace your steps and make sure each step was followed.</font>
