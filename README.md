# docker-thelia

### 1. Introduction

Docker file on a Debian Jessie with :

- Apache 2.4
- PHP 7.0
- mySQL 5.5
- and all dependencies for Thelia

It does not respect the single process docker style but this is the best way to make dev happy 😄

### 2. Run

You need first to pull the image via `docker pull acrimed/thelia`, then run the image :

```
docker run \
	-v /path/to/your/laravel/app:/app \
	-v mysql:/var/lib/mysql \
	-p 2780:80 \
	-p 2722:22 \
	-p 2790:1080 \
	-ti \
	acrimed/thelia
```

Finally go to <http://localhost:2780> on your computer.

Tools are :

- [PHPmyAdmin](http://localhost:2780/app_tools/phpmyadmin/)
- [PHPinfo](http://localhost:2780/app_tools/php_info.php)
- [MailDev](http://localhost:2790)

> On Windows, run 
>
> `docker run --rm -v /c/Users/path/to/your/thelia/folder:/app -v mysql:/var/lib/mysql -p 2780:80 -p 2722:22 -p 2790:1080 -ti acrimed/thelia`

#### 2.1 Quit container

Simply `exit` from the shell to stop the container.

#### 2.2 xDebug

On MacOS, the default docker host IP address is `192.168.65.1`. On other systems, you should set your computr address in file `/etc/php/7.0/apache2/conf.d/20-xdebug.ini` to use xdebug. - TO COMPLETE

### 3. Thelia Development

#### 3.1 Database

A test database is automatically loaded at first launch (cf command lines in run.sh file) - based on thelia/database/full_test_import.sql

If needed to restore default test database : run following command : $ mysql -s -u root --host=localhost < /app/database/full_test_import.sql.

If needed to commit database changes : 
  * Create a specific file in database/folder
  * Run it on your database
  * Run following command to update full_test_import.sql file : $ mysqldump -u root --databases acrimed_thelia2 > /app/database/full_test_import.sql

#### 3.2 Thelia web-site

Main thelia web-site will acessible on http://ADDRESS:2780/

Back office will be on http://ADDRESS:2780/admin/login

At first launch, you will need to disactivate/reactivate all needed modules.
  
#### 3.3 Thelia commands

To create a new administrator account : $ php thelia admin:create

To reset admninistrator account password : $ php thelia admin:UpdatePassword

To list all other commands : $ php thelia list

If strange errors where your changes do not seem to be taken into account, do not forget to clean the cache : $ php thelia cache:clear
  
### 4. Connect

#### 4.1 MySQL

1. Root account has no password and login is `root`.
2. Thelia account is :
	- login `thelia`
	- password ``
	- database `acrimed_thelia2`

If you run the image in a container without the `-v mysql:/var/lib/mysql` option, then the volume will not persist between two runs.

If you run the image with the `-v mysql:/var/lib/mysql` option, the database will persist between two runs. To remove the storage, just execute `composer volume rm mysql`.
 
If you have deleted all containers, run `docker volume prune` to remove all orphan volumes.

#### 4.2 SMTP

To test and complete

#### 4.3 SSH

```
ssh -l root -p 2722 localhost
```

Default root password is `root`.


#### 4.4 Ngrok

Simply run `ngrok http 80` and copy the forward address <http://xxxxxxxx.ngrok.io>. Give it to someone externaly and it will access to your webserver live.


### 5. Dev on this image

After locally retrieved the image with docker pull, Build the new image :

```
docker build -t my_thelia .
```

Run the dev image

```
docker run --rm -v /path/to/your/laravel/app:/app -v mysql:/var/lib/mysql -i -p 2780:80 -p 2722:22 -t my_thelia
```

Find running images

```
docker images
```

Commit changes

```
docker commit image_hash acrimed/thelia
```

Login to docker hub :

```
docker login
```

Push changes (needs to ask to be set as collaborator before) :

```
docker push acrimed/thelia
```

### 6. Known issues

Some issues have not been solved yet with this docker, please update documentation if you do them :
* Product images are not displayed
* Some payments have not yet been tested
* Tests of e-mail sendings with MailDev have not been done yet.
* Debugging with xDebug has not yet been tried

---
