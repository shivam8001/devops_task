# DevOps Task

## 1. Objective
Set up a simple **CI/CD pipeline** for a sample Node.js application using **AWS**, **Jenkins**, and **GitHub**.  
The pipeline demonstrates automation, scalability, and best DevOps practices.

---

## 2. Task Details

### a. Source Code & Version Control
- Fork/clone the Node.js app: [https://github.com/shivam8001/devops_task.git](https://github.com/shivam8001/devops_task.git)
- Push code to your GitHub repository.
- Use a clear branching strategy:
  - `main` → Production-ready code
  - `dev` → Development and testing

### b. CI/CD Pipeline (Jenkins)
- Jenkins pipeline triggered via **GitHub webhook**.
- **Pipeline stages:**
  1. **Build**: Install dependencies
     ```bash
     npm install
     ```
  2. **Dockerize**: Build Docker image
     ```bash
     docker build -t devops-task:latest .
     ```
  3. **Push to Registry**: Push Docker image to **AWS ECR**
     ```bash
     aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 554461595648.dkr.ecr.ap-south-1.amazonaws.com
     docker tag devops-task:latest 554461595648.dkr.ecr.ap-south-1.amazonaws.com/devops-task:latest
     docker push 554461595648.dkr.ecr.ap-south-1.amazonaws.com/devops-task:latest
     ```
  4. **Deploy**: Deploy container to **AWS ECS Fargate**
     ```bash
     aws ecs update-service \
       --cluster devops-task-cluster \
       --service devops-task-app-service-potubetn \
       --force-new-deployment \
       --region ap-south-1
     ```

### c. Infrastructure (AWS)
- Deployed using:
  - **AWS ECS Fargate** cluster
  - **Application Load Balancer**
  - **Security Group** with HTTP access on port 80
  - **Target Group** linked to ECS service on port 3000

### d. Monitoring & Logging
- **AWS CloudWatch** used for monitoring and logging.
- ECS tasks send logs to CloudWatch log group: `/ecs/devops-task-logs`
- Logs can be viewed in AWS Management Console → CloudWatch → Log groups

---


