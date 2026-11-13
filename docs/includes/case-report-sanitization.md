To protect against cross-site scripting (XSS) attacks, TheHive sanitizes HTML reports by removing JavaScript and some inline CSS when it displays them. As a result, a report preview can look different from the downloaded file.

Saved and downloaded files contain the full report and aren't sanitized.

!!! danger "Downloaded HTML reports"
    Any JavaScript in a downloaded HTML report runs when the file is opened in a browser. Open downloaded HTML reports in a hardened environment.
