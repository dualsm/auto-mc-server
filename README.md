# auto-mc-server
created for spring system administration course.

need to run these 2 commands after downloading aws CLI 
 
```bash
aws ec2 create-key-pair --key-name my-minecraft-key --query 'KeyMaterial' --output text > ~/.ssh/my-minecraft-key.pem
```
then 

```bash 
chmod 400 ~/.ssh/my-minecraft-key.pem
```

after doing that, create the main.tf file

then the variables.tf file 

make sure u did export USE_CAPS_FOR_THE_NAMES

ok now run

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

then press yes when it asks u, or if there are ❌ **ERRORS** hahahha good luck

ok now it should output the instance_public_ip="<generic_ip_here>"

copy that into your minecraft server address on the minecraft client

connect, and have fun!