#!/bin/bash

# Function to generate a random password
generate_random_password() {
  local length=10
  local characters="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()_+-="
  local password=""
  
  for i in $(seq 1 "$length"); do
    password+=${characters:$(($RANDOM % ${#characters})):1}
  done

  echo "$password"
}

# Main script
echo "Creating users with usernames ending in a number..."

for num in {1..20}; do
  username="user${num}"
  password=$(generate_random_password)

  # Check if the user already exists, if not, create the user
  if ! id "$username" &>/dev/null; then
    useradd -m -s /bin/bash "$username"
    echo "$username:$password" | chpasswd
    echo "User $username created with password: $password"
  else
    echo "User $username already exists. Skipping..."
  fi
done

echo "User creation completed."

echo "Download and install kubectl..."
if [! -f "./kubectl" ]
then
  curl -LO https://dl.k8s.io/release/v1.26.6/bin/linux/amd64/kubectl
fi
mv kubectl /usr/local/bin
chmod +x /usr/local/bin/kubectl

echo "Download and install kubectl completed."

echo "Install python 3.11 and pip..."
yum install -y python3.11.x86_64
yum install -y python3.11-devel
yum install -y python3.11-pip
echo "Install python 3.11 and pip completed."
