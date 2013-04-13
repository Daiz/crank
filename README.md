# Crank - The Construct 2 Addon Build Tool

Crank is a command-line build tool written for [Node.js](http://nodejs.org/) with the goal of making addon development for Scirra's [Construct 2](http://scirra.com) nicer. The installation is simple (*however, it's not available just yet*):

```
npm install crank -g
```

After that, crank will be available globally with the following command-line interface:

```
  Usage: crank [options] [command]

  Commands:

    init [type]            Initialize an addon project. Possible types: plugin, behavior, effect
    build                  Build the current project into a .c2addon file.
    watch                  Watch files and update the addon in C2 on changes. Windows-only.
    devmode                Toggle C2 developer mode on or off. Windows-only.

  Options:

    -h, --help  output usage information
```

## Commands

### crank init [plugin/behavior/effect]

Initialize a new project in the current folder with the given template.

### crank build 

Builds the current project into a distributable .c2addon file. The output filename will be yourpluginid.c2addon.

### crank watch

This command will watch the project files for changes and automatically copy the changed files to `%AppData%\Construct2\`. No manual copying required to test your addon in Construct 2! Note that the developer mode (see below) needs to be turned on for runtime addons to be reloaded on every preview. Any changes to edittime properties will require restarting Construct 2.

### crank devmode

Running this command will turn Construct 2 developer mode on or off, depending on the current state. No more manual registry tweaking!