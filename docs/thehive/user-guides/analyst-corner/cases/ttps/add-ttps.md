# Add Tactics, Techniques and Procedures

Add [tactics, techniques and procedures (TTPs)](about-ttps.md) to a [case](../about-cases.md) in TheHive.

TTPs describe the behaviors and methods commonly used by specific threat actors or groups.

{!includes/access-ttps.md!}

<h2>Procedure</h2>

1. [Find the case](../search-for-cases/find-a-case.md) where you want to add TTPs.

2. {!includes/ttps-tab-go-to.md!}

3. Select :fontawesome-solid-plus:.

4. In the **Add TTP** drawer, enter the following information:

    **-Catalog \***

    The MITRE catalog to use. By default, the Enterprise Attack catalog is installed with TheHive and includes all standard techniques. [Additional catalogs can be added](../../../../administration/ttps/add-a-catalog.md).

    **-Occur date \***

    The date when the attack occurred.

    **-Technique \***

    The technique used in the attack—describing how the attacker achieved their objective.

    **-Procedure**
    
    Turn on the toggle to add a detailed description of how the technique was carried out—the specific procedure used.

5. Select **Confirm**.

<h2>Next steps</h2>

* [Export TTPs](export-ttps.md)
* [Remove TTPs](remove-ttps.md)