# Jenkins CI/CD Pipeline for Dockerized Portfolio Application

This project demonstrates a complete **CI/CD pipeline** built using **Jenkins**, **Docker**, and **AWS EC2**.  
The pipeline automates the process of **building**, **scanning**, **pushing**, and **deploying** a containerized web application.

---

## 🚀 Project Overview

This portfolio application is packaged as a **Docker image** and is deployed to **AWS EC2** through a Jenkins pipeline.  
The pipeline is triggered on every code update and ensures:

- Automated build process
- Security vulnerability scanning
- Seamless application deployment
- Zero manual intervention during releases

---

## 🧱 Architecture Diagram

Developer → GitHub → Jenkins → Docker Build → Trivy Scan → Push to Docker Hub → SSH → Deploy on EC2


---

## 🛠️ Tools & Technologies Used

| Tool | Purpose |
|------|---------|
| **Jenkins** | CI/CD Pipeline Automation |
| **GitHub** | Source Code Repository |
| **Docker** | Containerizing the Application |
| **Docker Hub** | Container Image Registry |
| **Trivy** | Vulnerability Scanning for Images |
| **AWS EC2** | Application Deployment Server |
| **Shell & Jenkinsfile** | Pipeline Scripting |

---

## 📦 Pipeline Stages

| Stage | Description |
|-------|-------------|
| **Checkout** | Pull latest source code from GitHub |
| **Build Docker Image** | Build container image for the application |
| **Security Scan (Trivy)** | Scan image for vulnerabilities |
| **Push to Docker Hub** | Store versioned images in registry |
| **Connect to EC2** | Authenticate using SSH from Jenkins |
| **Deploy Container** | Pull new image, stop old container, run new version |

---

## 🧰 Prerequisites

Before running this pipeline, ensure the following:

- Jenkins is installed and running
- Docker is installed on Jenkins server and EC2 instance
- Jenkins has credentials configured:
  
  | Credential | Type | Usage |
  |-----------|------|-------|
  | `docker-cred` | Username/Password | Push Image to Docker Hub |
  | `ec2_ssh_key` | SSH Private Key | Connect to EC2 through pipeline |

- EC2 Security Group allows:
  - Inbound: Port `22` (SSH), `80` (Web App)

---

## 🔧 Jenkinsfile (Pipeline Script)

This repository includes a `Jenkinsfile` that defines the entire pipeline.  
Ensure Jenkins has **Pipeline** plugin installed.

---

## 🏃 How to Run

1. Clone this repository:
   ```bash
   git clone https://github.com/lucifer045/Devops-portfolio.git

2. Open Jenkins → New Item → Select Pipeline
3. Choose Pipeline from SCM
4. Provide GitHub repo URL
5. Save and Build Now


🌐 Application Access
Once deployed, access the application using:
http://<EC2-Public-IP>/


👨‍💻 Author
Prince Raghav
Freelance DevOps & SRE Engineer
Expert in: AWS | Jenkins | Kubernetes | Terraform | CI/CD | Docker | Observability
LinkedIn: https://www.linkedin.com/in/prince-raghav
GitHub: https://github.com/lucifer045