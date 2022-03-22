# intro

This doc is purpose on deploy es-cluster base on shell script 

with ansible like architecture :)

# architecture
the overview of folder architecture, includes config file in `./config` and related role installation in `roles`

also, any environment variables would be stored in `env` file.
```
├── config
│   ├── elasticsearch_C1.yml
│   ├── elasticsearch_D1.yml
│   ├── elasticsearch_D2.yml
│   ├── elasticsearch_D3.yml
│   ├── elasticsearch_I1.yml
│   ├── elasticsearch_M1.yml
│   ├── elasticsearch_M2.yml
│   ├── elasticsearch_M3.yml
│   ├── elasticsearch_T1.yml
│   ├── ins_es.sh
│   └── jvm.options
├── main.sh
└── roles
    ├── env
    ├── es-c1
    │   └── role.sh
    ├── es-d1
    │   └── role.sh
    ├── es-d2
    │   └── role.sh
    ├── es-d3
    │   └── role.sh
    ├── es-i1
    │   └── role.sh
    ├── es-m1
	...
```


# refer:
### bash loop over folder files
- https://www.cyberciti.biz/faq/bash-loop-over-file/

### sudo cat processing ...
- https://stackoverflow.com/questions/18836853/sudo-cat-eof-file-doesnt-work-sudo-su-does

### process sudo with `ssh`
- https://stackoverflow.com/questions/10310299/proper-way-to-sudo-over-ssh

### ssh without interactive mode
- https://stackoverflow.com/questions/17089808/how-to-do-remote-ssh-non-interactively
