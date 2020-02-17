# MISP 

## MISP cleaner

Delete invalid `domain` & `url` type attributes from MISP.

This script delete a domain / URL which has an invalid TLD. (E.g. `example.yoyodyne`)

## Install

```bash
git clone https://github.com/ninoseki/misc
bundle
```

## Configuration

Please set the following environmental variables:

- `MISP_API_ENDPOINT`: MISP API endpoint (E.g. https://misppriv.circl.lu)
- `MISP_API_KEY`: MISP API key

## Usage

```bash
$ cd misp
$ bundle exec ruby cleaner.rb
Do you want to delete attibute (value: example.yoyodyne, type: domain, event_id: 363)? [Y/n] Y
attibute (value: example.yoyodyne, type: domain, event_id: 363) is deleted.
```