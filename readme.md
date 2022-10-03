# Шпаргалка ansible

## Содержимое репозитория: Файлы и папки

+ first_setup - папка роли для запуска на голой системе Debian/Ubuntu
+ demo-site - демонстрационный статический сайт для примера
+ web_server - плейбук для деплоя nginx с demo-site
+ cheat_sheet_ansible-k8s.pdf - шит по модулю k8s

---

## Ссылки

[Документация Ansible](https://docs.ansible.com/ansible/latest/)

[Пособие по Ansible. Habr, 2016](https://habr.com/ru/post/305400/)

[Рекомендации по Ansible. Habr, 2021](https://habr.com/ru/company/otus/blog/540716/)

[Курс в одном видео](https://www.youtube.com/watch?v=YYjCwLs-1hA)

[памятка по MD](https://gist.github.com/Jekins/2bf2d0638163f1294637)

---

## Конфиг, переменные

При запуске команд ansibe и ansible-playbook по умолчанию в рабочей дериктории должен лежать ansible.cfg, пример:

```
[defaults]
inventory = /etc/ansible/hosts
host_key_cheking = false
ansible_python_interpreter = /usr/bin/python3

```
### Синтаксис файла hosts, составные группы
```
[local_oracle]
local_oracle01 ansible_host=192.168.122.200

[vps_oracle]
smartdiet ansible_host=45.80.71.138

[vps_ubuntu]
aa-bb.ru ansible_host=5.189.204.201

[vps:children]
vps_oracle
vps_ubuntu

[oracle:children]
local_oracle
vps_oracle
```
### Переменные группы для hosts

папка group_vars, в ней фалы по названию групп. синтаксис в файлах:

```
ansible_user: admin
ansible_ssh_private_key_file: /home/romess/.ssh/id_rsa
```

Если host_key_cheking в конфиге не прописан, то в команде его необнодимо указать: "-i /etc/hosts
"
## Простые команды, синтаксис

### Выполнить с sudo

в плейбуке:

```
become: yes
```

при запуске команды - ключ -b
предварительно необходимо на целевом хосте выполнить vsudo:

```
%sudo ALL=(ALL:ALL) NOPASSWD: ALL
# или аналогично для одного юзера:
admin ALL=(ALL:ALL) NOPASSWD: ALL
```

### Версия ОС

```
ansible host -i hosts -m setup | grep ansible_os_family
```
или

```
ansible host -i hosts -m setup | grep ansible_distribution
```

## Факты (Facts)

Выше мы использовали факты (facts) из модуля setup напрямую, они представляют из себя словарь ansible_facts

Позже будем использовать это использовать в плейбуках, например ansible_facts['distribution'] 

### Копировать файл с правами 600

```
ansible host -i hosts -m copy -a "src=sourse_file dest=destination_file mode=600"
```

## Плейбуки

Основа плейбука, запуск с sudo:

```
- name: Ping Servers
  hosts: local_oracle
  become: yes
  ```

### Установка паектов, апгрейд

##### RHEL, CentOS, Oracle:

```
  tasks:
  - name: Update cache
    dnf:
      update_cache: yes

  - name: Upgrade all
    ansible.builtin.dnf:
      name: "*"
      state: latest

  - name: Install htop
    ansible.builtin.dnf:
      name: htop
      state: latest
```
> Вместо ansible.builtin.dnf можно просто писать dnf.

> !!! Модуль yum только для python2 !!!

##### Ubuntu, Debian:

```
  tasks:
  - name: Update cache
    apt:
      update_cache: yes

  - name: Upgrade all
    apt:
      upgrade: yes

  - name: Install htop
    apt:
      pkg: htop
      state: latest
```

##### Для установки списка пакетов:
```
  - name: Install pkgs
    apt:
      pkg: 
	  	- htop
		- nginx
		- tree
      state: latest
```

### Копирование файлов

тоже самое, что и командой, только в формате yml:

```
  - name: Copy test file
    copy:
      src: ./test_file.txt
      dest: /home/
      mode: 0777
```
## Переменные в плейбуке

Объявление переменной packages и использование ее для установки пакетов:
```
  vars:
    packages:
      - wget
      - htop
      - nginx
  tasks:
  - name: Update all pkgs
    apt:
      pkg: "{{ packages }}"
```

Переменные можно вставлять из внешнего yaml файда:

```
  tasks:
  - name: Update all pkgs
  include_vars: "required_packages.yml"
    apt:
      pkg: "{{ packages }}"
```

### Циклы

##### создания папок через цикл

```
	- name: Create folders
	  file:
	  	path: "/home/{{ item }}"
		state: directory
	  loop:
	  	- dir1
		- dir2
```

##### Cоздание групп и пользователей
Используем циклы loop и with_items

```
  - name: create groups
    group:
      name: "{{ item }}"
      state: present
    loop:
      - dev
      - test

  - name: Create user
    user:
      name: "{{ item.name }}"
      shell: /bin/bash
      groups: dev,test
      append: yes
      home: "/home/{{ item.dir }}"
    with_items:
      - {name: user1, dir: user1}
      - {name: user2, dir: user2}
```

## Модули debug, shell

##### debug позволяет выводить в консоль сообщения и значения переменных

```
  vars:
    var1: "This is printing var"
    var2: "This var in message"

  tasks:
  - name: Print message
    debug:
      var: var1
  - debug:
      msg: "Hello, {{ var2 }}"
```
Вывести версию linux:
```
  - debug:
      msg: "Linux: {{ ansible_distribution }} Version: {{ ansible_distribution_version }}"
```
#### shell выполняет команду в command line
Прочитать списког групп пользователя user01 в переменную и вывести в консоль:
```
  tasks:
  - shell: id user01
    register: user01_groups
  - debug:
      msg: "user01 in groups: {{ user01_groups }}"
```


## Условия и facts из модуля [setup](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/setup_module.html)

Можно добавлять условия when к таску или блоку, удобвно вместе с параметрами из модуля setup

```
- name: Установка пакетов на Ubuntu
    apt: 
      pkg: "{{ item }}"
      state: latest
      with_items:
        - rsync
        - wget
        - nano
        - htop
    when: ansible_distribution == 'Debian' or ansible_distribution == 'Ubuntu'
```

К переменным из setup также можно обращаться как к словарю, например: ansible_facts['distribution']

Использование include_vars для вставки переменных из отдельного файла, специфичного для версии линукса, например os_Ubuntu.yml:

```
- hosts: all
  tasks:
    - name: Set OS distribution dependent variables
      include_vars: "os_{{ ansible_facts['distribution'] }}.yml"
    - debug:
        var: var_from_yml
```

## Шаблоны

В Ansible работает шаблонизатор Jinja, такой же, как в Django.
Используется для подстановки переменных в файл. 

#### Например, при копировании конфига nginx

Шаблон nginx.conf.j2:

```
server {
	listen 80;	
	root {{ document_root }}/{{ app_root }};
	index index.html index.htm;	
	server_name {{ server_name }};

	location / {
		default_type "text/html";
		try_files $uri.html $uri $uri/ =404;
	}
}
```

таск, после установки nginx:

```
    app_root: ./demo-site
    server_name: "{{ ansible_default_ipv4.address }}"
    document_root: /var/www
	...
  - name: Apply Nginx template
    template:
      src: ./nginx/nginx.conf.j2
      dest: /etc/nginx/sites-available/default
```

## Handlers

Удобно использовать для перезапуски сервисов, после изменения его конфига

```
  - name: Apply Nginx template
    template:
      src: "{{ nginx_config }}"
      dest: /etc/nginx/sites-available/default
    notify: Restart Nginx

  handlers:
    - name: Restart Nginx
      service:
        name: nginx
        state: restarted
```

## Роли ([документация](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html))

Для настройки отдельных ролей серверов, можно разделять задачи для разных ролей по отдельным файлам

Например, роли first_setup, web_server, proxy_server

Создание роли first_setup командой:

```
ansible-galaxy init first_setup
```
после выполнения будет создана одноименная папка с подпапками:

+ defaults - переменные по умолчанию
+ files - файлы, которые переносим на клиенты
+ handlers
+ meta
+ tasks - таски для роли
+ templates
+ vars
+ README.md

В каждой папке, кроме files есть main.yml, в него и нужно записывать соответствующие части (tasks, handlers, vars, templates)