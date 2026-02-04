#! /bin/bash

ogdir=$(pwd)

echo "Enter directory name: "
read -r dirname

if [ -d "$dirname" ]; then
    echo "$dirname already exists."
else
    mkdir -p $dirname
    echo "Created directory: $dirname"
fi

cd $dirname 
pwd


for n in 1 2 3 4
do
    touch file$n.txt
done

# touch file1.txt file2.txt file3.txt

ls file*

for names in file*
do
    echo "This file is named $names" > $names
done

cat file*

cd $ogdir

#rm -rf $dirname

echo "Done."

#msg="This file was empty and has been initialized."

#find . -maxdepth 1 -type f -name '*file*' -empty -print0 |
#while IFS= read -r -d '' f; do
#  echo "$msg" > "$f"
#done

