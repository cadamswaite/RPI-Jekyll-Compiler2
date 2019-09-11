#!/bin/bash

echo "Beginning install script.."

echo "Performing updates"
apt-get update && apt-get upgrade -y
