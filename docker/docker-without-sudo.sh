# https://docs.docker.com/engine/install/linux-postinstall
# Run docker commands without using sudo

# Create the docker group.

sudo groupadd docker

# Add your user to the docker group.

sudo usermod -aG docker $USER

# run the following command to activate the changes to groups:

newgrp docker

# verify that everything works as expected without sudo
sysuser@ubuntuprod:~/git/ldk (master -> origin/master)$ docker run hello-world
