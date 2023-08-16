#!/bin/bash

# Check for "temp" folder.
temp_folder="/mnt/c/temp"
[ ! -d "$temp_folder" ] && mkdir -p "$temp_folder"

# Display choices
choices=("Alma Linux" "Alpine Linux" "Amazon Linux" "Arch Linux" "CentOS" "Clear Linux" "Debian" "Fedora" "Neuro Debian" "Oracle Linux" "openSUSE" "Red Hat" "Rocky Linux" "Ubuntu")

codeNames=("almalinux" "alpine" "amazonlinux" "archlinux" "dokken/centos-stream-9" "clearlinux" "debian" "fedora" "neurodebian" "oraclelinux" "opensuse/leap" "redhat/ubi9" "rockylinux" "ubuntu")

echo
echo -e "\e[37;46m  Select an OS to install \e[0m"
echo
for ((i=0; i<${#choices[@]}; i++)); do
	echo "$(($i + 1)): ${choices[$i]}"
done

echo
read -p "Enter your choice [1-14]:  " choice

if ((choice >= 1 && choice <= 14)); then
	index=$(($choice - 1))
	OsName=${codeNames[$index]}
	#echo "$index selected." # Index is one less than choice.
	echo -e "\e[37;46m  ${choices[$index]} selected.\e[0m"
	echo
	if [[ $index -eq 4 ]]; then
		mkdir -p /mnt/c/temp/dokken
		elif [[ $index -eq 10 ]]; then
		mkdir -p /mnt/c/temp/opensuse
		elif [[ $index -eq 11 ]]; then
		mkdir -p /mnt/c/temp/redhat
	fi

	echo -e "\e[37;46m  System has started to download ${choices[$index]} \e[0m"
	docker run -t $OsName bash ls /
	dockerContainerID=$(docker container ls -a | grep -i $OsName | awk '{print $1}')
	docker export $dockerContainerID > /mnt/c/temp/$OsName.tar
	echo -e "\e[37;46m  $OsName has been downloaded and placed in C:/temp folder  \e[0m"

	if [ -e "/mnt/c/temp/dokken/centos-stream-9.tar" ]; then
		mv /mnt/c/temp/dokken/centos-stream-9.tar /mnt/c/temp/centos-stream-9.tar
		rm -rf /mnt/c/temp/dokken
	fi
	
	if [ -e "/mnt/c/temp/redhat/ubi9.tar" ]; then
		mv /mnt/c/temp/redhat/ubi9.tar /mnt/c/temp/ubi9.tar
		rm -rf /mnt/c/temp/redhat
		mv /mnt/c/temp/ubi9.tar /mnt/c/temp/redhat.tar
	fi
	
	if [ -e "/mnt/c/temp/opensuse/leap.tar" ]; then
		mv /mnt/c/temp/opensuse/leap.tar /mnt/c/temp/leap.tar
		rm -rf /mnt/c/temp/opensuse
		mv /mnt/c/temp/leap.tar /mnt/c/temp/opensuse.tar
	fi

else
	echo "Invalid choice. Tun the script again and enter a number between 1 and 14."
fi
