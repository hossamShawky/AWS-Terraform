# AWS-APIGateWay-Lambda
### AWS Terrafrom scripts to provision and deploy api gateway invoke lambda function to execute _(CRUD)_ on dynamodb.
![alt](images/image.png)
## Table of Contents

- [Setup Instructions](#setup-instructions)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Configuration](#configuration)
  - [Deployment](#deployment)
- [Usage](#usage)
- [Cleanup](#cleanup)
- [Customization](#customization)
- [Contributing](#contributing)
- [License](#license)



### Prerequisites

1. **AWS Account**: Ensure you have an AWS account with permissions to create and manage API Gateway, Lambda functions, and S3 buckets.
   
2. **AWS CLI**: Install AWS CLI to configure your AWS profile and manage resources via command line and change profile name in file _**providers.tf**_.

### Installation

Clone the repository:

```bash
git clone https://github.com/hossamShawky/AWS-Terraform.git
cd aws-api-labmbda/
```


### Configuration
- Configure AWS Profile:

Open terminal or command prompt and configure AWS CLI with your AWS credentials:

```bash
aws configure --profile <your-profile-name>
```
_Follow the prompts to enter your Access Key ID, Secret Access Key, AWS Region, and output format._

### Deployment

```bash
terraform init
terraform apply
```
_Follow the prompts to enter **yes** , wait untill all resources created and then try to upload files._
![alt](images/outputs.png)



### Usage

```bash
Copy api_gateway_url and open postman or use curl command
```
_Status_
![alt](images/status.png)

_All Items_
![alt](images/all_items.png)

_Add Item_
![alt](images/add_item.png)

_Check All Items_
![alt](images/check1.png)

_Get Item_
![alt](images/get_item.png)

_Update Item_
![alt](images/update_item.png)

_Check Update Item_
![alt](images/update_check.png)

_Delete Item_
![alt](images/delete_item.png)

_Check Delete Item_
![alt](images/delete_check.png)

_Check All Items_
![alt](images/all_items_2.png))

### Cleanup
To avoid ongoing charges, delete the resources created for the demo:

```bash
terraform destroy
```
_Follow the prompts to enter **yes** and wait untill all resources deleted._

### Customization
Feel free to customize the project as per your requirements. You can modify the VPC CIDR ranges, security groups, instance types, or add additional configurations as needed.

### Contributing
Contributions to enhance or expand this project are welcome! If you find any issues or have suggestions, please open an issue or submit a pull request.

### License
This project is licensed under the MIT License.

