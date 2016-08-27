# Post-it

Sample app using [riot-crystal](https://github.com/crisward/riot-crystal/) as a starting point.

It creates multi-client websocket connected post-it
note canvas which updates in real time. Uses Sqlite to persist data.


## Installation

```
git clone git@github.com:crisward/postit.git
cd postit
crytal deps
npm install
```

## Usage

### During development

The below will run a server on `127.0.0.1:3000`
It will watch for changes in js and stylus files and recompile.
Livereload will refresh your browser on file change if a Livereload
plugin is installed.

```
crystal run src/app.cr 
```

In another terminal window run

```
npm run watch
```

### Build

The below will build and minify your css and js.
It will also create a optimised compiled binary for the server

```
npm run build && crystal build --release src/app.cr
```

The built server can then be run with `./app`
