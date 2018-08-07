# Classname finder

This project implements class finder functionality in a similar way to the Intellij IDEA Ctrl+N search.

### Usage:

```
./bin/class-finder <filename> '<pattern>'
```

where:

* `<filename>` refers to the file containing class names separated by line breaks.
* `<pattern>` must include class name camelcase upper case letters in the right order and it may contain lower case letters to narrow down the search results.

If the search pattern consists of only lower case characters then the search becomes case insensitive.

If the search pattern ends with a space `' '` then the last word in the pattern must also be the last word of the found class name.

The search pattern may include wildcard characters `'*'` which match missing letters.

The found class names are sorted in alphabetical order ignoring package names.

### Example usage:

```
./bin/class-finder data/classes.txt FooBar
```

## Tests

Code is covered with Rspec.
Tests are run with the following command:

```
bundle
rspec
```

where ```bundle``` installs rspec dependency.
