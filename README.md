# Pardot input plugin for Embulk

TODO: Write short description here and embulk-input-pardot.gemspec file.

## Overview

* **Plugin type**: input
* **Resume supported**: no
* **Cleanup supported**: no
* **Guess supported**: no

## Configuration

- **user_name**: Pardot's uesr name (string, required)
- **password**: Pardot's password (string, required)
- **uesr_key**: Pardot's user key (string, required)
- **object**: ojbect what you want to fetch. pelsae select (string, required)

## Object

- list_membership
- list
- prospect
- visitor_activity
- visitor 

## Example

```yaml
in:
  type: pardot
  user_name: <your user name>
  password: <your password>
  use_key: <your key>
  object: prospect
```


## Build

```
$ docker-compose run dev bash

$ bundle install
$ bundle exec rake

```

## Debug

```
$ docker-compose run dev bash

$ embulk bundle instal 
$ sh debug-run.sh


```


## install from local 

```
$ docker-compose run dev bash

$ embulk gem install ruby-pardot 
$ embulk gem install --local pkg/embulk-input-pardot-0.1.0.gem


```


