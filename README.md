# Credits

A viewable auto-generated credits page based on FXManifest entries

![](https://cdn.tycoon.community/rrerr/t75im.png)

## Usage

Navigate to the servers `/credits/` endpoint, usually found by going to `<servers-ip>:<servers-port>/credits/` or `<servers-cfx-url>/credits`

## Installation

1. Place the included `credits` folder in your FXServer's resources folder
2. Add `ensure credits` to your server config, usually before everything else.

## Valid FXManifest Entries

This resource supports all built-in manifest entries, and adds some additional valid ones:

| Entry       | Description                                | Custom |
|-------------|--------------------------------------------|--------|
| name        | Resource name                              | Yes    |
| author      | Author name                                |        |
| contact     | Contact link or email                      | Yes    |
| version     | Resource version                           |        |
| download    | Download link, like forum thread or github | Yes    |
| description | Short description of the resource          |        |
| details     | Long description of the resource           | Yes    |
| usage       | Details on usage for developers            | Yes    |