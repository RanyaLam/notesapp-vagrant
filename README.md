# 🚀 NotesApp - Kubernetes Deployment with Vagrant & Ansible

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Vagrant](https://img.shields.io/badge/Vagrant-2.4.9-blue)](https://www.vagrantup.com/)
[![Ansible](https://img.shields.io/badge/Ansible-2.10+-red)](https://www.ansible.com/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-1.28-blue)](https://kubernetes.io/)
[![Terraform](https://img.shields.io/badge/Terraform-1.6.0-purple)](https://www.terraform.io/)

**Automated deployment of a 3-tier web application on Kubernetes using Infrastructure as Code**

![NotesApp Demo](docs/notesapp-screenshot.png)

---

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Project Structure](#project-structure)
- [Technologies Used](#technologies-used)
- [Deployment Details](#deployment-details)
- [Accessing the Application](#accessing-the-application)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

---

## 🎯 Overview

**NotesApp** is a simple yet complete web application for taking notes, deployed on a local Kubernetes cluster using modern DevOps practices. This project demonstrates:

- **Infrastructure as Code** with Terraform
- **Configuration Management** with Ansible
- **Container Orchestration** with Kubernetes (Minikube)
- **Automated Provisioning** with Vagrant
- **Complete CI/CD-ready** architecture

The entire infrastructure—from VM creation to application deployment—is automated with a **single command**: `vagrant up`

---

## 🏗️ Architecture

### Application Architecture (3-Tier)
```
┌─────────────────────────────────────────────────────────────┐
│                        User Browser                          │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│              NGINX Ingress Controller                        │
│           (notes.192.168.49.2.nip.io)                       │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                 Frontend Service (2 replicas)                │
│              NGINX Alpine + HTML/CSS/JS                      │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                 API Service (2 replicas)                     │
│              Python Flask REST API                           │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│              Database Service (1 replica)                    │
│         PostgreSQL 15 + PersistentVolume                    │
└─────────────────────────────────────────────────────────────┘
```

### Infrastructure Architecture
```
┌──────────────────────────────────────────────────────────────┐
│                    Windows Host                               │
│                                                               │
│  ┌────────────────────────────────────────────────────────┐  │
│  │              VirtualBox + Vagrant                       │  │
│  │                                                         │  │
│  │  ┌──────────────────────────────────────────────────┐  │  │
│  │  │         Ubuntu 22.04 VM                          │  │  │
│  │  │                                                  │  │  │
│  │  │  ┌────────────────────────────────────────────┐ │  │  │
│  │  │  │  Minikube (Kubernetes Cluster)             │ │  │  │
│  │  │  │                                            │ │  │  │
│  │  │  │  - Frontend Pods (×2)                     │ │  │  │
│  │  │  │  - API Pods (×2)                          │ │  │  │
│  │  │  │  - PostgreSQL Pod (×1)                    │ │  │  │
│  │  │  │  - MetalLB Load Balancer                  │ │  │  │
│  │  │  │  - NGINX Ingress Controller               │ │  │  │
│  │  │  └────────────────────────────────────────────┘ │  │  │
│  │  │                                                  │  │  │
│  │  │  Ansible (Local) → Terraform → Kubernetes      │  │  │
│  │  └──────────────────────────────────────────────────┘  │  │
│  └────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────┘
```

---

## ✨ Features

### Application Features
- ✅ Create, Read, and Delete notes
- ✅ Automatic timestamp for each note
- ✅ Modern, responsive UI with gradient design
- ✅ Data persistence with PostgreSQL
- ✅ RESTful API backend

### DevOps Features
- ✅ **One-command deployment**: `vagrant up`
- ✅ **Infrastructure as Code**: Everything versioned in Git
- ✅ **High Availability**: 2 replicas for frontend and API
- ✅ **Auto-healing**: Kubernetes restarts failed pods automatically
- ✅ **Persistent Storage**: Data survives pod restarts
- ✅ **Load Balancing**: MetalLB + Kubernetes Services
- ✅ **External Access**: NGINX Ingress + nip.io DNS
- ✅ **Health Checks**: Liveness and Readiness probes

---

## 📦 Prerequisites

### Required Software

| Tool | Version | Download Link |
|------|---------|---------------|
| **Windows** | 10/11 | - |
| **VirtualBox** | 7.2.4+ | [Download](https://www.virtualbox.org/wiki/Downloads) |
| **Vagrant** | 2.4.9+ | [Download](https://www.vagrantup.com/downloads) |
| **WSL (Ubuntu 22.04)** | Optional | `wsl --install -d Ubuntu-22.04` |

### System Requirements

- **RAM**: 8 GB minimum (4 GB allocated to VM)
- **CPU**: 2+ cores
- **Disk Space**: 20 GB free
- **Network**: Internet connection for downloads

---

## 🚀 Quick Start

### 1️⃣ Clone the Repository
```bash
git clone https://github.com/RanyaLam/notesapp-vagrant.git
cd notesapp-vagrant
```

### 2️⃣ Deploy Everything (One Command!)
```bash
vagrant up
```

**That's it!** ☕ Grab a coffee while Vagrant:
1. Downloads Ubuntu 22.04 image (~600 MB, first time only)
2. Creates and configures the VM
3. Installs Docker, Minikube, Terraform, Helm
4. Starts the Kubernetes cluster
5. Deploys the NotesApp with all components

⏱️ **Total time**: ~25-30 minutes (first run)

### 3️⃣ Access the Application

Once deployment is complete, look for this message:
```
================================================
✅ DEPLOYMENT COMPLETE!
================================================
Access NotesApp at:
http://notes.192.168.49.2.nip.io
================================================
```

Open the URL in your browser! 🎉

---

## 📁 Project Structure
```
notesapp-vagrant/
├── Vagrantfile                          # VM definition and provisioning
├── README.md                            # This file
├── provisioning/
│   ├── site.yml                        # Main Ansible playbook
│   └── roles/
│       ├── base/                       # Base system packages
│       │   └── tasks/
│       │       └── main.yml
│       ├── docker/                     # Docker installation
│       │   └── tasks/
│       │       └── main.yml
│       ├── kubernetes/                 # Kubernetes tools setup
│       │   └── tasks/
│       │       └── main.yml
│       └── deploy/                     # Application deployment
│           ├── tasks/
│           │   └── main.yml
│           └── files/
│               ├── app/                # Application source code
│               │   ├── api/           # Flask API
│               │   │   ├── app.py
│               │   │   ├── Dockerfile
│               │   │   └── requirements.txt
│               │   ├── frontend/      # NGINX + HTML/CSS/JS
│               │   │   ├── index.html
│               │   │   ├── nginx.conf
│               │   │   └── Dockerfile
│               │   └── database/      # PostgreSQL init
│               │       └── init.sql
│               └── terraform/         # Kubernetes resources
│                   ├── provider.tf
│                   ├── variables.tf
│                   ├── namespace.tf
│                   ├── database.tf
│                   ├── api.tf
│                   ├── frontend.tf
│                   ├── ingress.tf
│                   └── outputs.tf
└── docs/                               # Documentation and screenshots
```

---

## 🛠️ Technologies Used

### Application Stack
- **Frontend**: HTML5, CSS3, JavaScript (Vanilla)
- **Web Server**: NGINX Alpine
- **Backend**: Python 3.9, Flask 2.3.0
- **Database**: PostgreSQL 15 Alpine

### DevOps Stack
- **Containerization**: Docker
- **Orchestration**: Kubernetes (Minikube 1.34)
- **IaC**: Terraform 1.6.0
- **Configuration**: Ansible 2.10+
- **Provisioning**: Vagrant 2.4.9
- **Hypervisor**: VirtualBox 7.2.4
- **Load Balancer**: MetalLB
- **Ingress**: NGINX Ingress Controller
- **DNS**: nip.io (dynamic DNS)
- **Package Manager**: Helm 3.19+

---

## 📖 Deployment Details

### What Happens During `vagrant up`?

#### Phase 1: VM Creation (5 min)
- Downloads `ubuntu/jammy64` box
- Creates VM: 4GB RAM, 2 CPUs
- Configures network and shared folders

#### Phase 2: Base Installation (3 min)
- Updates system packages
- Installs Python, curl, git, etc.
- Installs Docker Engine

#### Phase 3: Kubernetes Setup (8 min)
- Installs kubectl, Minikube, Terraform, Helm
- Starts Minikube cluster (Docker driver)
- Enables Ingress and MetalLB addons

#### Phase 4: Application Deployment (10 min)
- Copies application files
- Runs Terraform to create Kubernetes resources:
  - Namespace: `notesapp`
  - Deployments: frontend (×2), api (×2), database (×1)
  - Services: ClusterIP for internal communication
  - PersistentVolumeClaim: 1GB for PostgreSQL
  - Secrets: Database credentials
  - Ingress: External access via NGINX

#### Phase 5: Verification (2 min)
- Waits for all pods to be Ready
- Displays deployment status
- Shows final URL

---

## 🌐 Accessing the Application

### From Host Machine (Windows)

**Primary URL** (via nip.io):
```
http://notes.192.168.49.2.nip.io
```

**Alternative** (port forwarding):
```
http://localhost:8080
```

### From Inside the VM
```bash
vagrant ssh
curl http://notes.192.168.49.2.nip.io
```

### Testing the API Directly
```bash
# Health check
curl http://notes.192.168.49.2.nip.io/api/health

# Get all notes
curl http://notes.192.168.49.2.nip.io/api/notes

# Add a note
curl -X POST http://notes.192.168.49.2.nip.io/api/add \
  -H "Content-Type: application/json" \
  -d '{"content": "My first note!"}'
```

---

## 🔧 Troubleshooting

### Common Issues

#### Issue 1: `vagrant up` fails with "Timed out while waiting for the machine to boot"

**Solution**:
```bash
vagrant destroy -f
vagrant up
```

#### Issue 2: Application URL doesn't work

**Check Minikube IP**:
```bash
vagrant ssh
minikube ip
```

The URL should match: `http://notes.<MINIKUBE_IP>.nip.io`

#### Issue 3: Pods stuck in "Pending" state

**Check events**:
```bash
vagrant ssh
kubectl get events -n notesapp --sort-by='.lastTimestamp'
```

**Common causes**:
- Insufficient disk space
- Resource constraints (CPU/Memory)

**Solution**:
```bash
# Increase VM resources in Vagrantfile
vb.memory = "6144"  # 6GB instead of 4GB
vb.cpus = 4         # 4 cores instead of 2
```

#### Issue 4: Docker permission denied

This is handled automatically by the playbook, but if you encounter it manually:
```bash
vagrant ssh
sudo usermod -aG docker vagrant
newgrp docker
```

---

## 🔍 Useful Commands

### Vagrant Commands
```bash
# Start the VM and provision
vagrant up

# Stop the VM
vagrant halt

# Restart the VM
vagrant reload

# Re-run provisioning only
vagrant provision

# SSH into the VM
vagrant ssh

# Destroy the VM completely
vagrant destroy -f

# Check VM status
vagrant status
```

### Kubernetes Commands (Inside VM)
```bash
# Get all resources
kubectl get all -n notesapp

# Get detailed pod info
kubectl get pods -n notesapp -o wide

# Check pod logs
kubectl logs -n notesapp deployment/notes-api

# Describe a resource
kubectl describe ingress notesapp-ingress -n notesapp

# Restart a deployment
kubectl rollout restart deployment/notes-api -n notesapp

# Scale deployment
kubectl scale deployment/notes-api --replicas=3 -n notesapp

# Port forward (for debugging)
kubectl port-forward -n notesapp svc/notes-frontend 8080:80
```

### Minikube Commands
```bash
# Check cluster status
minikube status

# Get cluster IP
minikube ip

# SSH into Minikube node
minikube ssh

# Stop Minikube
minikube stop

# Delete cluster
minikube delete

# View dashboard
minikube dashboard
```

---

## 🎓 Learning Resources

This project demonstrates several DevOps concepts:

- **Infrastructure as Code**: All infrastructure defined in code
- **Configuration Management**: Automated setup with Ansible
- **Container Orchestration**: Kubernetes for container management
- **High Availability**: Multiple replicas with auto-healing
- **Declarative Infrastructure**: Terraform for Kubernetes resources
- **GitOps**: Version-controlled infrastructure

### Recommended Reading

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Terraform Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs)
- [Ansible Documentation](https://docs.ansible.com/)
- [Vagrant Documentation](https://www.vagrantup.com/docs)

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### How to Contribute

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👤 Author

**Ranya Laamari**

- GitHub: [@RanyaLam](https://github.com/RanyaLam)
- Project: [notesapp-vagrant](https://github.com/RanyaLam/notesapp-vagrant)
- Docker Hub: [souff1159](https://hub.docker.com/u/souff1159)

---

## 🙏 Acknowledgments

- Professor EL MENDILI for project guidance
- The open-source community for amazing tools
- Minikube and Kubernetes teams
- HashiCorp for Terraform and Vagrant

---

## 📊 Project Status

✅ **Completed**: Full deployment automation with Vagrant + Ansible + Terraform

**Future Enhancements**:
- [ ] CI/CD pipeline with GitHub Actions
- [ ] Monitoring with Prometheus + Grafana
- [ ] HTTPS with Let's Encrypt
- [ ] PostgreSQL High Availability
- [ ] Horizontal Pod Autoscaling

---

<div align="center">

**⭐ Star this repo if you find it helpful!**

Made with ❤️ for DevOps learning

</div>
