# RI Academy of Wine - Infrastructure

This directory contains Terraform configuration for deploying the RI Academy of Wine web application to AWS App Runner.

## Architecture

- **AWS App Runner**: Fully managed container/application service that builds and deploys the SvelteKit application
- **Route 53**: Custom domain configuration for www.riacademyofwine.com
- **IAM**: Roles and policies for App Runner to access necessary AWS services
- **Auto Scaling**: Automatically scales based on traffic

## Prerequisites

1. **AWS CLI**: Installed and configured with credentials for account `183295417701`
2. **Terraform**: Version 1.0 or higher
3. **S3 Bucket**: The backend state bucket `ri-academy-of-wine-infrastructure-state` must already exist in `us-east-1`
4. **GitHub Connection**: You must create an AWS App Runner GitHub connection before deploying

### Creating GitHub Connection

Before running Terraform, you need to create a GitHub connection in AWS App Runner:

1. Go to [AWS Console](https://console.aws.amazon.com/apprunner/)
2. Navigate to **App Runner** > **GitHub connections**
3. Click **Create GitHub connection**
4. Follow the prompts to authorize AWS to access your GitHub account
5. Select the repository containing this code
6. Copy the connection ARN (format: `arn:aws:apprunner:us-east-1:183295417701:connection/NAME/ID`)

## Setup

1. **Copy the example variables file:**
   ```bash
   cd infrastructure
   cp terraform.tfvars.example terraform.tfvars
   ```

2. **Edit terraform.tfvars:**
   - Add your GitHub repository URL
   - Add your GitHub connection ARN (from prerequisites)
   - Adjust any other settings as needed (CPU, memory, scaling, etc.)

3. **Initialize Terraform:**
   ```bash
   terraform init
   ```

4. **Review the plan:**
   ```bash
   terraform plan
   ```

5. **Apply the configuration (two-step process):**

   Due to AWS App Runner's certificate validation records not being known until after the custom domain association is created, the initial deployment requires a two-step apply:

   ```bash
   # Step 1: Create the App Runner service and custom domain association
   terraform apply -target=aws_apprunner_custom_domain_association.webapp

   # Step 2: Create the Route 53 validation records and complete the setup
   terraform apply
   ```

   After the initial deployment, subsequent applies can be done with a single `terraform apply` command.

## Configuration

### Instance Sizing

App Runner instance configuration can be adjusted in `terraform.tfvars`:

**CPU Options:**
- `0.25 vCPU` - Minimal workloads
- `0.5 vCPU` - Light workloads
- `1 vCPU` - Default, good for most applications
- `2 vCPU` - High performance
- `4 vCPU` - Very high performance

**Memory Options:**
- Must be proportional to CPU
- Range: `0.5 GB` to `12 GB`

### Auto Scaling

Configure scaling behavior:
- `min_size`: Minimum number of instances (default: 1)
- `max_size`: Maximum number of instances (default: 10)
- `max_concurrency`: Requests per instance before scaling (default: 100)

### Environment Variables

Add environment variables in `terraform.tfvars`:

```hcl
environment_variables = {
  NODE_ENV = "production"
  API_KEY  = "your-api-key"
  # Add more as needed
}
```

## Deployment

App Runner automatically builds and deploys your application when:
1. You push to the configured branch (default: `main`)
2. Auto-deployment is enabled (default: `true`)

The build process:
1. Pulls code from GitHub
2. Runs `npm ci` to install dependencies
3. Runs `npm run build` to build the SvelteKit app
4. Starts the app with `node build/index.js`

## Custom Domain

The infrastructure automatically configures the www subdomain (`www.riacademyofwine.com`):
- Certificate validation records in Route 53
- CNAME record pointing to App Runner service
- SSL certificate provisioning and validation

**Note**: The application uses the www subdomain because AWS App Runner requires CNAME records, which cannot be used at the domain apex (riacademyofwine.com) due to DNS protocol limitations.

After applying Terraform, allow 5-10 minutes for:
- SSL certificate provisioning
- DNS propagation
- Domain validation

Your application will be accessible at: **www.riacademyofwine.com**

## Outputs

After `terraform apply`, you'll see:
- `apprunner_service_url`: Default App Runner URL
- `custom_domain`: Your custom domain
- `custom_domain_status`: Status of domain association
- `apprunner_service_status`: Overall service status

## Monitoring

Access App Runner logs and metrics:
1. Go to [AWS Console](https://console.aws.amazon.com/apprunner/)
2. Select the `ri-academy-of-wine-webapp` service
3. View **Logs** and **Metrics** tabs

## Cost Optimization

App Runner pricing is based on:
- Compute: CPU and memory allocated
- Build: Time spent building deployments
- Requests: Number of requests processed

To optimize costs:
- Use smaller instance sizes if possible
- Set appropriate min/max scaling values
- Consider using reserved capacity for predictable workloads

## Troubleshooting

### Build Failures

Check build logs in AWS Console:
1. App Runner service > Activity tab
2. Look for deployment events
3. Click on failed deployment for logs

Common issues:
- Missing dependencies in `package.json`
- Build command failures
- Incorrect start command

### Domain Issues

If custom domain doesn't work:
1. Verify DNS records in Route 53
2. Check certificate validation status
3. Wait 5-10 minutes for propagation
4. Verify `custom_domain_status` output

### Connection Issues

If GitHub connection fails:
1. Verify connection ARN is correct
2. Check GitHub app authorization
3. Ensure repository access is granted

## Files

- `backend.tf`: S3 backend configuration
- `provider.tf`: AWS provider configuration
- `iam.tf`: IAM roles for App Runner
- `apprunner.tf`: App Runner service and auto-scaling
- `route53.tf`: Custom domain and DNS configuration
- `variables.tf`: Input variables
- `outputs.tf`: Output values
- `terraform.tfvars.example`: Example configuration

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

**Warning**: This will delete the App Runner service and DNS records. The S3 state bucket and GitHub connection are not managed by Terraform and will remain.

## Support

For issues or questions:
- AWS App Runner documentation: https://docs.aws.amazon.com/apprunner/
- Terraform AWS Provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
