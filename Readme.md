![Repository Logo](site-banner.png)
### Dockerized Sinatra / Mongoid App over Puma via Foreman

#### Requirements
* `docker` version 1.11.0 or newer
* `docker-compose` version 1.6.0 or newer
* On Mac OS X, the repository needs to be either checked out to a path under `/Users/$(whoami)/`, or you need to modify the docker-machine VirtualBox instance to allow further file permissions. Otherwise overlaying the ./app directory inside the docker container will fail. This is a known limitation for VirtualBox under Mac OS X.

#### Docker Installation of Mac OS X 10.11 (El Capitan)

##### Installation of Homebrew
Homebrew installation is easy, a single command:
```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

##### Installation of Docker
Once we have Homebrew available, we can install Docker with these commands:
```
brew update
brew install docker
brew install docker-compose
```

### Usage

#### Directory Layout
```
app
├── Gemfile
├── Gemfile.lock
├── Procfile
├── app.rb
├── conf
│   ├── app_config.rb
│   ├── init.rb
│   └── mongoid.yml
├── config.ru
├── logs
│   └── app.log
├── models
│   ├── init.rb
│   ├── sample_data.rb
│   └── user.rb
├── public
│   └── css
│       └── app.css
├── routes
│   ├── diag.rb
│   └── init.rb
└── views
    └── index.erb
```

#### Basic Usage
The skeleton is straightforward to use.

* Set a `session_secret` value in `conf/app_config.rb`.
* Configure additional Mongoid settings in `conf/mongoid.yml`.
* Add your views to `views/`.
* Put you static assets into `public/` folder.
* Add your controllers to `routes/` (don't forget to add a `require_relative` to `routes/init.rb`).
* Add Mongoid data models to `models/` (don't forget to add a `require_relative` to `models/init.rb`).
* Run via `docker-compose up`.
* Access the application at `http://192.168.99.100:5678`

#### Diagnostic URLs
By default, the application skeleton includes some diagnostic routes:
* `http://192.168.99.100:5678/memory` will print memory information
* `http://192.168.99.100:5678/disk` will print disk information
* `http://192.168.99.100:5678/env` will print environment information

#### App Shutdown
You can gracefully shutdown the app using the `http://192.168.99.100:5678/exit` URL.

#### Disabling Diagnostic URLs
If you do not desire these diagnostic URLs, uncomment the line `require_relative 'diag'` in `routes/init.rb`
