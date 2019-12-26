# TheHive

## Merge alerts into a case

Do a bulk merge of alerts into a case based on a description of an alert.

```bash
bundle exec ruby thehive/bulk_alert_merge.rb DESCRIPTION CASE_ID
```

```bash
$ bundle exec ruby thehive/bulk_alert_merge.rb "foo bar" 111111
Merge 2 alerts(artifacts: x.x.x.x, y.y.y.y, z.z.z.z) into Test(111111)? [Y/n] y
Merged.
```
