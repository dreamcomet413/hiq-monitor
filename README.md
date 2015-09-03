Hiq Monitor
================

[![Deploy to Heroku](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

Ruby on Rails
-------------

This application requires:

- Ruby 2.2.2
- Rails 4.2.2

Learn more about [Installing Rails](http://railsapps.github.io/installing-rails.html).

Getting Started
---------------
- clone .env from .env.example
- clone database.yml from database.example
- run below commands
```
rake db:create
rake db:migrate
rake db:seed
```
- run ```rake hockeyapp:pull_crashes notify_slack=false``` after you deploy

Documentation and Support
-------------------------
```
username: user@example.com
password: changeme
```

Issues
-------------

Similar Projects
----------------

Contributing
------------

Credits
-------

License
-------
