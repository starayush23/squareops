# SquareOps DevOps Assignment

## Overview

This repository contains my solution for the SquareOps DevOps assignment based on the Example Voting Application.

The application has five components:

* Vote Service (Flask)
* Redis
* Worker Service (.NET)
* PostgreSQL
* Result Service (Node.js)

The main goal of the assignment was to improve the Kubernetes deployment, make the database persistent, expose the application through Ingress, and build a CI/CD pipeline for the vote service.

---

## Architecture

![Architecture](architecture.png)

A user submits a vote through the Vote application. The vote is stored in Redis and picked up by the Worker service. The Worker writes the vote into PostgreSQL, and the Result application reads from PostgreSQL to display the latest results.

The application runs on Minikube and is exposed through NGINX Ingress.


For CI/CD, I used GitHub Actions. Whenever changes are made under the vote/ directory, the workflow lints the application, builds a Docker image, pushes it to Docker Hub, creates a temporary Kind cluster, deploys the application, and runs a smoke test against the Vote service.

---

## What Changed

The original manifests worked, but there were a few areas that I wanted to improve.

### PostgreSQL StatefulSet

The original setup used a Deployment for PostgreSQL. I replaced it with a StatefulSet because PostgreSQL is a stateful application and should keep its identity and storage across restarts.

### Persistent Storage

A PersistentVolumeClaim was added for PostgreSQL.

To make sure persistence was working correctly, I deleted the PostgreSQL pod and verified that the data was still available after Kubernetes recreated it.

### Secrets

Database credentials were moved into a Kubernetes Secret instead of being stored directly inside the manifests.

### Health Checks

Readiness and liveness probes were added to all workloads so Kubernetes can determine when a container is healthy and ready to receive traffic.

### Resource Limits

CPU and memory requests/limits were added to every workload.

### Ingress

An NGINX Ingress resource was added for the Vote and Result applications.

### CI/CD Pipeline

A GitHub Actions workflow was created specifically for the Vote service.

The workflow:

* Lints the application code
* Validates Kubernetes manifests
* Builds a Docker image
* Pushes the image to Docker Hub
* Creates a temporary Kind cluster
* Deploys the application
* Runs a smoke test against the Vote service

---

## Running the Application

### Prerequisites

Install:

* Docker
* Minikube
* kubectl

### Clone the Repository

```bash
git clone https://github.com/starayush23/squareops.git
cd example-voting-app
```

### Deploy

```bash
./bootstrap.sh
```

The script starts Minikube, deploys all Kubernetes resources, waits for the pods to become ready, and prints the application URLs.

### Verify

```bash
kubectl get pods
kubectl get svc
kubectl get ingress
```

### Access the Application

Vote application:

```bash
minikube service vote --url
```

Result application:

```bash
minikube service result --url
```

Submit a vote and verify that the Result application updates within a few seconds.

---

## Troubleshooting

### Pods Are Not Starting

Check pod status:

```bash
kubectl get pods
```

Describe the pod:

```bash
kubectl describe pod <pod-name>
```

Check logs:

```bash
kubectl logs <pod-name>
```

---

### Vote Does Not Appear In The Result Application

The first place I would look is the Worker service because it moves votes from Redis into PostgreSQL.

```bash
kubectl logs deployment/worker
```

Also verify that Redis and PostgreSQL are running:

```bash
kubectl get pods
```

---

### Unable To Reach The Application Through Ingress

Check the ingress resource:

```bash
kubectl get ingress
```

For Minikube:

```bash
minikube tunnel
```

Also verify that the ingress addon is enabled.

---

## Trade-offs

A couple of trade-offs I made during the assignment:

* I used Minikube because it is easy to set up and reproduce locally.
* I considered using Helm, but since the assignment only required improving the existing manifests, I decided to keep the deployment in plain Kubernetes YAML.
* The CI/CD workflow only targets the Vote service because that was the requirement.

---

## What I Would Do Next

If I had more time, I would:

* Convert the manifests into a Helm chart
* Add monitoring with Prometheus and Grafana
* Add end-to-end integration tests
* Add TLS for ingress traffic
* Explore GitOps deployment using ArgoCD

---

## Demo Video

Loom Recording:

ADD_LINK_HERE

