# TheHive Release Versioning and Maintenance Policy

Look up how TheHive version numbers are structured, what each release type contains, how often each type ships, and how long a version keeps receiving fixes and support.

## Version numbering

Since April 2024, TheHive follows a three-part `X.Y.Z` version scheme.

| Segment | Name | Covers |
| --- | --- | --- |
| `X` | Major version | Major structural changes, including breaking changes. |
| `Y` | Minor version | Smaller or intermediate features without major breaking changes. A breaking change only appears here if unavoidable, with a rollback path always provided. |
| `Z` | Patchfix and hotfix | Bug fixes. A hotfix specifically addresses a critical bug or a critical-severity security issue. |

## Maintenance windows

A maintained version keeps receiving corrections for bugs and security issues, along with support from the StrangeBee Support Team.

!!! note "Backporting"
    TheHive backports bugs rated Critical or High priority with customer impact, and security fixes of any severity, to older still-maintained versions. Each backport decision is made individually, prioritizing customer stability and security.

How long a version stays maintained depends on its type and its position in the release history.

Every minor version is maintained for a minimum amount of time from its release date, regardless of what happens next:

* 12 months for versions released before 6.0
* 6 months from 6.0 onward

This is a floor: the rules below can extend a version's maintenance window, but never shorten it below that minimum.

On top of that floor, TheHive always keeps three versions maintained at any given time, but which three depends on what just shipped:

* At each new major release, the maintained set is the previous major's last two minors, plus the new major itself.
* At each new minor release, the maintained set is the previous major's last minor, plus the two most recent minors of the current major. The major's own `.0` release counts as one of those minors.

Each release shifts this set forward, which is what extends some versions' maintenance beyond the minimum. The table below shows how this plays out release by release.

### End of maintenance table

| Version | Initial release | End of maintenance and support |
| --- | --- | --- |
| [5.0](../release-notes/release-notes-5.0.md) | March 15, 2022 | No longer maintained or supported |
| [5.1](../release-notes/release-notes-5.1.md) | March 1, 2023 | No longer maintained or supported |
| [5.2](../release-notes/release-notes-5.2.md) | July 6, 2023 | No longer maintained or supported |
| [5.3](../release-notes/release-notes-5.3.md) | April 24, 2024 | No longer maintained or supported |
| [5.4](../release-notes/release-notes-5.4.md) | September 26, 2024 | No longer maintained or supported |
| [5.5](../release-notes/release-notes-5.5.md) | April 22, 2025 | 5.8 ships |
| [5.6](../release-notes/release-notes-5.6.md) | February 2, 2026 | 6.0 ships |
| [Latest] [5.7](../release-notes/release-notes-5.7.md) | April 9, 2026 | 6.1 ships |
| 5.8 | — | 7.0 ships |
| 6.0 | — | 6.2 ships |
| 6.1 | — | 6.3 ships |

The same pattern repeats at every later major and minor release.

A version no longer maintained or supported receives no further fixes, including security fixes, and no assistance from the StrangeBee Support Team. Upgrade to a maintained version as soon as possible.

Within a maintained version, always upgrade to the latest patch release to benefit from all bug corrections and security fixes.

<h2>Next steps</h2>

* [Upgrade from version 5.x](upgrade-from-5.x.md)
