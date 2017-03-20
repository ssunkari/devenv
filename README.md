# devenv

A base development environment

## Vagrant Plugins

The following Vagrant plugins are required. Install with `vagrant plugin install <plugin name>`

```
vagrant-hosts (2.2.0)
vagrant-proxyconf (1.3.2)
ventriloquist (0.6.0)     
```

## config.json

You can specify a config file to use, or it will default to `config.json`. The options supported are:

option               | required | comments
-------------------- |:--------:|---------
git.user.name        | yes      |  
git.user.email       | yes      |  
git.version          | no       | The version of git to install from source (recommend `2.1.2`)
syncedFolders        | no       | An array of `{source, dest}`
proxy.useSystemProxy | no       |
npm.useSystemProxy   | no       |
npm.registry         | no       | Use if you host your own (internal) npm registry
hosts                | no       | An array of `{ip, names}` where `names` is an array of string

### Example `config.json`

```json
{
    "syncedFolders": [{
        "source": "../dev",
        "dest": "/usr/src/dev"
    }, {
        "source": "../dev/test-project",
        "dest": "/usr/src/test"
    }],
    "git": {
        "version": "2.1.2",
        "user": {
            "name": "James Allen",
            "email": "someone@somewhere.com"
        }
    },
    "proxy": {
        "useSystemProxy": true
    },
    "npm": {
        "useSystemProxy": true,
        "registry": "http://mynpmregistry.org/"
    },
    "hosts": [{
        "ip": "192.168.1.25",
        "names": ["somednsname.local", "somednsname"]
    }]
}
`
Running Kafka Within the Box
Once the instance is running you can ssh to the box: vagrant ssh
Then, inside the box, create folder kafka and paste there attached docker-compose.yml
Run sudo -i
curl -L https://github.com/docker/compose/releases/download/1.2.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
Go to the folder where you saved docker-compose.yml and run following command: docker-compose up -d
This should run kafka instances, you can see the list of running instances with following command: docker-compose ps``

## TODOs

- [x] Configure using a json file
- [x] Add SyncedFolders to config
- [x] Add Host entries to config
- [ ] Test different configurations 


