# Шпаргалка ansible

---

## Ссылки

[Пособие по Ansible. Habr, 2016](https://habr.com/ru/post/305400/)

[памятка по MD](https://gist.github.com/Jekins/2bf2d0638163f1294637)

[Курс в одном видео](https://www.youtube.com/watch?v=YYjCwLs-1hA)

[Документация Ansible](https://docs.ansible.com/ansible/latest/)

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
### Переменные в плейбуке

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