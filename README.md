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
- **timezone**: Pardot's timezone (string, required)
- **object**: Object what you want to fetch. Please select an object from Object section.(string, required)
- **skip_columns**: Columns what you want to skip. Pleae see the following section for the detail. (Array)
- **columns**: Columns what you want to select. If nothing, the default is all columns.(Array)  

## Object

- list_membership
- list
- prospect
- visitor_activity
- visitor 

## Skip column

Skip column is working without **columns** field. If it is not blank, it will not work.
Skip column supports Ruby regex syntax.

```yaml
in:
  skip_columns:
    - {pattern: .*name}
    - {pattern: email}
```

## Example

```yaml
in:
  type: pardot
  user_name: <your user name>
  password: <your password>
  use_key: <your key>
  timezone: Asia/Tokyo
  object: prospect
  skip_columns:
    - {pattern: .*name}
    - {pattern: email}
```

```yaml
in:
  type: pardot
  user_name: <your user name>
  password: <your password>
  use_key: <your key>
  timezone: Asia/Tokyo
  object: prospect
  columns:  
    - {name: email, type: string}
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

$ embulk bundle install
$ sh debug-run.sh
```

## install from local 

```
$ docker-compose run dev bash

$ embulk gem install ruby-pardot 
$ embulk gem install tzinfo 
$ embulk gem install --local pkg/embulk-input-pardot-0.1.0.gem
```