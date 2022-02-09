# WideSky-editor

This is a command line interface for the WideSky Server.

To get started, all you have to do is `clone` this repository to your local machine.
Then try out one of the following usage or do `./runners/widesky-editor.sh --help`.

It is also recommended that you periodically do a `docker pull wideskycloud/editor:latest`
to pull down the latest editor tool image from our [docker repository](https://hub.docker.com/repository/docker/wideskycloud/editor).

## Usage

The URI, client identifier and client secret must be given on the command line.
If the username or password is not given, it'll be prompted for on the terminal.

By default, the output is directed to the standard out however this can be
redirected to a file by using the using `--output` option. When doing so, it is
important that the output is targeted at the `./` current directory, otherwise
the output could be written to a location of the container where the volume
is not mapped to the local drive. Hence losing the file straight after the container
shuts down.

The two subcommands of the `widesky-editor` are `dump` and `load`.

### Dumping entities: `dump`

`dump` basically is an interface to the WideSky `read` command and outputs
the entities in a human-readable YAML format.  The output is suitable for
feeding back into `load` for updating entities' tags.

It takes `--id` and/or `--filter` arguments.  `--id` retrieves a single entity
by fully qualified ID whereas `--filter` accepts a filter expression.  Any
number or combination of these may be given.

The entities are dumped to the output as YAML "documents".

Example:
```
./widesky-editor.sh --output sites.yaml --uri https://me.on.widesky.cloud/widesky/ --client-id abcdefg --client-secret ssshh --username user100@widesky.cloud --password 123x456 --filter site 
```

This command will do a read operation base on the specified `filter` and write the output to a file (sites.yaml) containing the entities.

### Loading entities: `load`

`load` is actually a tool for performing updates, creations and deletions on
entities.  It can take any number of YAML files, each which contain one or more
"documents" that describe a single instruction to be performed on a set of
entities, which are described either by filter or by ID.

```
./widesky-editor.sh --uri https://me.on.widesky.cloud/widesky/ --client-id apple100 --client-secret ssshhh --username user100@widesky.cloud --password 123x456 --load create_sites.yaml 
```

This command will read the content of `create_sites.yaml` file and perform the required `create`, `update` or `delete` operations against the targeted WideSky server.

#### Common parameters

* `action`: Describes the action to be performed in this instruction. (Required)
* `id`: Specifies a single entity ID.
* `ids`: Specifies a list of entity IDs.
* `filter`: Specifies a single filter expression.
* `filters`: Specifies a list of filter expressions.

#### `create` action

This is used to create new entities.  The `id` parameter in this case *MUST* be
given.  `tags` describes what tags to apply to the entity on creation, the
values given as Project Haystack JSON-style scalars.

e.g. to create a new `equip`:
```
---
action: create
id: mysite.mynewequip
tags:
  dis: My Shiny New Meter
  siteRef: r:mysite
  tz: Brisbane
  equip: 'm:'
```

#### `update` and `set` actions

This is used to update existing entities.  `update` changes *just* the tags
specified in the action, whereas `set` will delete any tag that is not
explicitly listed in the instruction.  In the case where `ids`, `filter` or
`filters` are used, the same operations are applied to all matching entities.

Tags may be deleted using the "remove" singleton: `x:`

e.g. to update the display name on the above `equip`:
```
---
action: update
id: mysite.mynewequip
tags:
  dis: My Not So Shiny New Meter
  tz: 'x:'
```

#### `create_or_update` and `create_or_set` actions

These do a query based on the `ids` given, and for each entity found, perform a
`set` or `update` instruction.  For anything not found, a `create` instruction
is performed.

#### `delete` actions

This is used to delete entire existing entities.  In the case where `ids`,
`filter` or `filters` are used, the delete is applied to all matching entities.

e.g. to delete the above `equip`:
```
---
action: delete
id: mysite.mynewequip
```



