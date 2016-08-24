#!/usr/bin/env bash

#
# TODO: Replace lots of this with reading the config.json file via jq rather than
#       relying on arg being passed to the script
#



if [ $# -lt 1 ] ; then
	echo "You must specify at least 1 argument."
	exit 1
fi

case $(id -u) in
	0) 
		sudo -u vagrant -i $0 "$@" # script calling itself as the vagrant user
		;;
	*) 
		
		while getopts ":v:n:e:r:p:" opt; do
			case $opt in
				v) git_version="$OPTARG"
					;;
				n) git_name="$OPTARG"
					;;
				e) git_email="$OPTARG"
					;;
				r) registry="$OPTARG"
					;;
				p) proxy="$OPTARG"
					;;
				\?) echo "Invalid option -$OPTARG" >&2
					;;
			esac
		done
		if [ ! -z "$git_version" ]; then
			if ! git --version | grep -q $git_version; then
				echo "Installing git $git_version"
				(cd /tmp; wget –quiet https://www.kernel.org/pub/software/scm/git/git-$git_version.tar.gz; tar -zxf git-$git_version.tar.gz; cd git-$git_version; make prefix=/usr/local all; sudo make prefix=/usr/local install;)
			fi
		fi
		mkdir -p /home/$USER/.vim/

		if [ ! -z "$git_name" ]; then
			echo "Setting up Git config"
			git config --global user.name "$git_name"
			git config --global user.email "$git_email"
		fi
		
		if ! hash "git flow" 2>/dev/null; then
			echo "git flow"
			git clone --recursive git://github.com/nvie/gitflow.git
			(cd gitflow && sudo make prefix=/opt/local install)
			echo 'export PATH=$PATH:/opt/local/bin' >> $HOME/.profile
		fi

		if ! hash pip 2>/dev/null; then
			echo "Installing pip"
			wget https://bootstrap.pypa.io/get-pip.py
			sudo python get-pip.py
		fi

		if ! hash docker 2>/dev/null; then
			echo "Installing docker"
			curl -sSL https://get.docker.com/ | sudo sh
		fi

		if ! hash seige 2>/dev/null; then
			echo "Installing seige"
			sudo apt-get install siege
		fi

		if ! hash ansible 2>/dev/null; then
			echo "Installing ansible"
			sudo apt-get install ansible
		fi

		if ! hash go 2>/dev/null; then
			echo "Installing golang"
			VERSION="1.4"
			OS="linux"
			ARCH="amd64"

			FILE="go$VERSION.$OS-$ARCH.tar.gz"

			if [ ! -e $FILE ]
			then
				wget "https://storage.googleapis.com/golang/$FILE"
			fi

			sudo tar -C /usr/local -xzf "$FILE"
			echo 'export PATH=$PATH:/usr/local/go/bin' >> $HOME/.profile
			echo 'mkdir -p $HOME/go' >> $HOME/.profile
			echo 'export GOROOT=/usr/local/go' >> $HOME/.profile
			echo 'export PATH=$PATH:$GOROOT/bin' >> $HOME/.profile
			echo 'export GOPATH=$HOME/go' >> $HOME/.profile
			echo 'export PATH=$PATH:${GOPATH//://bin:}/bin' >> $HOME/.profile
		fi

		if ! hash dockercompose 2>/dev/null; then
			echo "Installing docker-compose"
			sudo pip install docker-compose --upgrade
		fi

		#Run Kafka Scripts		
		# if $kafka_useKafkaRest then
		 	echo "Running kafka Rest stack"
		 	cd /usr/src/dev/docker/kafka
		 	sudo docker-compose up -d
		 	echo "Finished installing kafka Rest stack"
		 	sudo docker ps
		# fi

		if ! hash ansiable 2>/dev/null; then
			echo "Installing aws-cli"
			sudo pip install awscli --ignore-installed six
		fi


		if ! hash awscli 2>/dev/null; then
			echo "Installing aws-cli"
			sudo pip install awscli --ignore-installed six
		fi

		if ! hash awsebcli 2>/dev/null; then
			echo "Installing awsebcli"
			sudo pip install --upgrade awsebcli
		fi

		if ! grep -qe "^export TERM='xterm-256color'$"~/.bashrc; then
			echo "export TERM='xterm-256color'" >> ~/.bashrc
		fi

		if ! hash nvm 2>/dev/null; then
			echo "Installing nvm"
			curl --silent https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash 2>/dev/null
			source ~/.nvm/nvm.sh
			if ! grep -qe "^source ~/.nvm/nvm.sh$" ~/.bashrc; then
				echo "source ~/.nvm/nvm.sh" >> ~/.bashrc
				echo "nvm use 4.4.6" >> ~/.bashrc
			fi
			nvm install 4.4.6 2>/dev/null
			nvm use 4.4.6
		fi

		if ! hash nodemon 2>/dev/null; then
			echo "Installing node modules"
			if [ ! -z "$registry" ]; then
				echo "Setting npm registry: $registry"
				npm config --global set registry $registry
			fi
			if [ ! -z "$proxy" ]; then
				echo "Setting npm proxy: $proxy"
				npm config --global set proxy $proxy
				npm config --global set https-proxy $proxy
			fi
			npm install --loglevel error -g nodemon mocha grunt-cli js-beautify grunt-init cucumber
		fi

		if [ ! -d /home/$USER/.grunt-init/ ]; then
			echo "Installing grunt-init-node"
			git clone https://github.com/gruntjs/grunt-init-node.git /home/$USER/.grunt-init/node
			chown -R $USER:$USER /home/$USER/.grunt-init/
		fi

		if ! hash wemux 2>/dev/null; then
			echo "Installing wemux"
			sudo git clone git://github.com/zolrath/wemux.git /usr/local/share/wemux
			sudo ln -s /usr/local/share/wemux/wemux /usr/local/bin/wemux
			sudo cp /vagrant/home/wemux.conf /usr/local/etc/wemux.conf
		fi

		if ! hash http 2>/dev/null; then
			echo "Installing HTTP (human readable version of CURL)"
			sudo pip install --upgrade httpie
			echo "Done - see https://github.com/jakubroztocil/httpie"
		fi
		;;
esac


echo "Done!"
echo "Your vagrant development environment is ready to use"
