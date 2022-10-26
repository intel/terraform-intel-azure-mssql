# Do not deploy the testing environment on the same account as the production that you are using live. 
These permissions show what the workflow uses, but due to possible differences in end environment they might need modifying to suit the infrastructure that you are using.
# The MSSQL on AWS workflow requires four groups of permissions:
+ AWS KMS permissions for creation of KMS key
+ IAM instance profile role management permissions
+ Full EC2 Access to create and manage used VMs (EC2FullAccess managed policy)
+ Secrets Manager Read Write access (managed most efficiently using AWS SecretsManagerReadWrite policy)
+ The easiest to deploy is to create AdministratorAccess, but this would require a separate isolated AWS environment as to prevent ANY access to non-managed resources from the current account.

Terraform KMS management permissions:
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "kms:CreateGrant",
                "kms:GenerateDataKey*",
                "kms:Decrypt",
                "kms:Encrypt",
                "kms:GetKeyPolicy",
                "kms:GetKeyRotationStatus",
                "kms:ReEncrypt*",
                "kms:DescribeKey",
                "kms:CreateKey",
                "kms:CreateAlias",
                "kms:TagResource",
                "kms:EnableKeyRotation",
                "kms:ScheduleKeyDeletion",
                "kms:CancelKeyDeletion",
                "kms:ListResourceTags",
                "iam:CreateServiceLinkedRole"
            ],
            "Resource": "*"
        }
    ]
}

IAM instance profile role management permissions:
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "iam:CreateInstanceProfile",
                "iam:DeleteInstanceProfile",
                "iam:GetRole",
                "iam:GetInstanceProfile",
                "iam:TagRole",
                "iam:RemoveRoleFromInstanceProfile",
                "iam:CreateRole",
                "iam:DeleteRole",
                "iam:PutRolePolicy",
                "ec2:ReplaceIamInstanceProfileAssociation",
                "iam:AddRoleToInstanceProfile",
                "iam:ListInstanceProfilesForRole",
                "iam:PassRole",
                "iam:DetachRolePolicy",
                "iam:ListAttachedRolePolicies",
                "iam:DeleteRolePolicy",
                "iam:ListRolePolicies",
                "iam:GetRolePolicy",
                "ec2:AssociateIamInstanceProfile",
                "iam:TagInstanceProfile"
            ],
            "Resource": "*"
        }
    ]
}

The policies above might be used as the starting point for production IAM policies, but are not the smallest subset of possible policies. For example, the KMS policies might be limited further.

Managed policies:
AmazonEC2FullAccess
SecretsManagerReadWrite

AdministratorAccess policy is also enough
