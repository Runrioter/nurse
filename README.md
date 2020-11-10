# nurse

A Toy for learning Swift programming language.


## Usage

```
$ nurse -h
OVERVIEW: 🏥 Nurse

  A Toy for learning Swift programming language.


USAGE: nurse <subcommand>

OPTIONS:
  -h, --help              Show help information.

SUBCOMMANDS:
  location                Search locations using MetaWeather API
  weather                 Search weather using MetaWeather API

  See 'nurse help <subcommand>' for detailed help.
```

## Build from source code

### Build

Build sources into binary products

```shell
make build
```

### Format

Lint sources

```shell
make format
```

### Run

Build and run an executable product

```shell
swift run nurse location -q <location text>
```

### Test

Build and run tests

```shell
make test
```
