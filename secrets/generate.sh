#!/bin/bash

filenames="_file-list.txt"
password_length=16
output_directory="output/"

load_file_list() {

    if [ ! -f "$filenames" ]; then
        echo "File $filenames not found."
        exit 1
    fi

    file_list=()

    mapfile -t file_list < "$filenames"
}


generate_password() {

    password=$(openssl rand -base64 $((password_length + 24)) | tr -dc 'a-zA-Z0-9' | head -c $password_length)

    echo "$password"
}

create_output_directory() {

  mkdir -p $output_directory
}



generate_files() {

  for file in "${file_list[@]}"; do

    file=$( tr -d '\n\t\r ' <<<"$file" )
    file_path=$output_directory$file

      if [ -e "$file_path" ] && [  -s "$file_path" ]; then
          echo "File $file_path exists and its not empty"
          read -p "WARNING!!! Do you want to generate a password for: $file_path? (yes/no): " response

          case "$response" in
              [Yy][Ee][Ss]|[Yy])
                  password=$(generate_password)
                  echo -n $password > "$file_path"
                  echo -e "New password generated for: './$file_path'\n"
                  ;;
              *)
                  echo -e "Skipping './$file_path'\n"
                  ;;
          esac
      else
          password=$(generate_password)
          echo -n "$password" > "$file_path"
          echo -e "File created and new password generated for: './$file_path'\n"
      fi
  done
}


load_file_list
create_output_directory
generate_files
