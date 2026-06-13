#!/bin/bash

echo "Starting Minikube..."
minikube start --driver=docker

echo "Deploying application..."
kubectl apply -f k8s-specifications/

echo "Waiting for pods..."
kubectl wait --for=condition=Ready pods --all --timeout=300s

echo "Application deployed successfully"

echo "Vote URL:"
minikube service vote --url

echo "Result URL:"
minikube service result --url

