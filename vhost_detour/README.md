# Virtual Host direct IP access blocking detour

Detour a direct IP access blocking by using [curl --resolve](https://curl.haxx.se/docs/manpage.html#--resolve).

## Usage

```bash
bundle exec ruby vhost_detour/detour.rb 1.1.1.1 8.8.8.8 ...
```
