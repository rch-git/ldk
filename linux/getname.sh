#! /bin/bash

# Interactive reading of a variable

# Stage this file in ~/temp directory
# Make it executable by running chmod +x ~/temp/getname.sh
# Run it ~/temp/getname.sh

echo 'Enter your name'

read name

# Display the variable value

echo 'The name entered: ' $name