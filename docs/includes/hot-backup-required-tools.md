Before performing a hot backup, ensure the following tools are available on your system:

* [Cassandra nodetool](https://cassandra.apache.org/doc/latest/cassandra/troubleshooting/use_nodetool.html): Command-line tool for managing Cassandra clusters, used for creating database snapshots
* [tar](https://www.gnu.org/software/tar/manual/html_node/index.html): Utility for archiving backup files
* [cqlsh](https://cassandra.apache.org/doc/latest/cassandra/managing/tools/cqlsh.html): Command-line interface for executing CQL queries against the Cassandra database
* [curl](https://curl.se/): Tool for transferring data with URLs, useful for interacting with the Elasticsearch API
* [jq](https://jqlang.org/): Lightweight command-line JSON processor for parsing and manipulating JSON data in scripts

If any tools are missing, install them using your package manager, for example:

* `apt install jq` for DEB-based operating systems
* `yum install jq` for RPM-based operating systems