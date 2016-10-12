#! /bin/bash

echo "print the years from the albums file"

cut -f4 -d\| albums #task 4-5

echo "---------------"

echo "print the years from the albums file using a variable"

fieldname=4
cut -f$fieldname -d\| albums #I wasn't sure how to write a function for getfield, so I just passed the name of the variable fieldname in as a variable

echo "---------------"

echo "print the users currently logged in using the who and cut commands"

who | cut -d' ' -f1 #task 4-6
#third example (install mail if necessary)
#sudo yum -y install mailx
#mail $(who | cut -d' ' -f1)
echo "---------------"

echo "print the files in the current directory, sorted by date"

function lsd #task 4-7
{
    date=$1
    ls -l | grep -i "^.\{42\}$date" | cut -c55-
}

lsd

#using command substitution with print command
#lpr $(lsd 'jan 15')

