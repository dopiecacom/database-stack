#!/bin/bash

password_length=16

load_file_list() {
    # Define the filename
    filenames="_file-list.txt"

    # Check if the file exists
    if [ ! -f "$filenames" ]; then
        echo "File $filename not found."
        exit 1
    fi

    # Initialize an empty array
    file_list=()

    # Read the file line by line and populate the array
    while IFS= read -r file; do
        # Add each line (record) to the array
        file_list+=( $(echo "$file" | sed 's/\r$//') )
    done < "$filenames"

    # Return the array elements
    #echo $file_list
    #echo "${file_list[@]}"
}

# Function to generate a random password
generate_password() {
    # Generate a random 16-character password
    password=$(openssl rand -base64 $(($password_length + 24)) | tr -dc 'a-zA-Z0-9' | head -c $password_length)
    echo "$password"
}

# List of files to check
#file_list=("file1.txt" "file2.txt" "file3.txt")
load_file_list

# Check if each file exists
for file in "${file_list[@]}"; do
    if [ -e "$file" ] && [  -s "$file" ]; then
        echo "File $file exists and its not empty"
        read -p "WARNING!!! Do you want to generate a password for: $file? (yes/no): " response

        case "$response" in
            [Yy][Ee][Ss]|[Yy])
                password=$(generate_password)
                echo -n $password > $file
                echo -e "New password generated for: './$file'\n"
                ;;
            *)
                echo -e "Skipping './$file'\n"
                ;;
        esac
    else
        password=$(generate_password)
        echo -n $password > $file
        echo -e "File created and new password generated for: './$file'\n"
    fi
done

