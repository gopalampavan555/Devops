#!/bin/bash

# Get current region
REGION=$(aws configure get region)

# Function to convert bytes to human-readable format
human_readable() {
    local -i bytes
    bytes=$1
    local -i kbytes
    local -i mbytes
    local -i gbytes
    if (( bytes < 1024 )); then
        echo "${bytes} B"
        return
    fi
    if (( bytes < 1024 * 1024 )); then
        kbytes=$(( (bytes + 1023) / 1024 ))
        echo "${kbytes} KB"
        return
    fi
    if (( bytes < 1024 * 1024 * 1024 )); then
        mbytes=$(( (bytes + 1023 * 1024) / (1024 * 1024) ))
        echo "${mbytes} MB"
        return
    fi
    gbytes=$(( (bytes + 1023 * 1024 * 1024) / (1024 * 1024 * 1024) ))
    echo "${gbytes} GB"
}

# Get EC2 instances
echo "### EC2 Instances in region: $REGION ###"
echo "Instance ID | Instance Type | State | Public IP | Private IP | CPU Cores | Memory"
aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name,PublicIpAddress,PrivateIpAddress,CpuOptions.CoreCount,MemoryInfo.SizeInMiB]' --output table

# Get S3 buckets
echo ""
echo "### S3 Buckets in region: $REGION ###"
echo "Bucket Name"
aws s3api list-buckets --query 'Buckets[*].Name' --output table

# Get EBS volumes
echo ""
echo "### EBS Volumes in region: $REGION ###"
echo "Volume ID | Size | State"
aws ec2 describe-volumes --query 'Volumes[*].[VolumeId,Size,State]' --output table

# Get Elastic IPs
echo ""
echo "### Elastic IPs in region: $REGION ###"
echo "Public IP | Instance ID"
aws ec2 describe-addresses --query 'Addresses[*].[PublicIp,InstanceId]' --output table

