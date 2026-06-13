#!/bin/bash

echo "Starting Minikube..."
minikube start --driver=docker

echo "Deploying application..."
kubectl apply -f k8s-specifications/

echo "Waiting for pods..."
kubectl wait --for=condition=Ready pods --all --timeout=300s

echo ""
echo "Application deployed successfully!"
echo ""
echo "To access the application, run:"
echo "minikube service vote --url"
echo "minikube service result --url"
echo ""
echo "To access Ingress (if using ingress):"
echo "minikube tunnel"