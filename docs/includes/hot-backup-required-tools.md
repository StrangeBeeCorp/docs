Before we begin, let's make sure your system has all the necessary tools installed.

You'll need the following:

* [Cassandra nodetool](https://cassandra.apache.org/doc/latest/cassandra/troubleshooting/use_nodetool.html){target=_blank}: Command-line tool for managing Cassandra clusters, used for creating database snapshots
* [tar](https://www.gnu.org/software/tar/manual/html_node/index.html){target=_blank}: Utility for archiving backup files
* [cqlsh](https://cassandra.apache.org/doc/latest/cassandra/managing/tools/cqlsh.html){target=_blank}: Command-line interface for executing CQL queries against the Cassandra database
* [curl](https://curl.se/){target=_blank}: Tool for transferring data with URLs, useful for interacting with the Elasticsearch API
* [jq](https://jqlang.org/){target=_blank}: Lightweight command-line JSON processor for parsing and manipulating JSON data in scripts

{% include-markdown "includes/python-compatibility-cqlsh.md" %}

If any tools are missing, install them using your package manager. For example:

* `sudo apt install jq` for DEB-based operating systems
* `sudo yum install jq` for RPM-based operating systems