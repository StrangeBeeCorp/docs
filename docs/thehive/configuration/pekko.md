# Pekko Configuration (Version 5.4+)

With the release of version 5.4, TheHive transitioned from the Scala framework Akka to [Apache Pekko](https://pekko.apache.org/). This change enhances performance and introduces several updates that may require modifications to your `application.conf` file.

This topic provides instructions on updating your configuration to support this change.

!!! note "Version compatibility "
    This documentation applies to TheHive version 5.4 and later. For instructions related to earlier versions, refer to the [Akka Configuration](./akka.md) topic.

## Basic configuration

For a reliable cluster setup, it's essential to have a minimum of three nodes for TheHive application. Configure each node with Pekko as outlined below:

```yaml
## Pekko server
pekko {
  cluster.enable = on
  actor {
    provider = cluster
  }
  remote.artery {
    canonical {
      hostname = "<HOSTNAME OR IP_ADDRESS>"
      port = 7355
    }
  }

  cluster.seed-nodes = [ 
    "pekko://application@HOSTNAME1:7355", 
    "pekko://application@HOSTNAME2:7355", 
    "pekko://application@HOSTNAME3:7355" 
  ]

  cluster.min-nr-of-members = 2  # Set to the minimum number of nodes required
}
```

In this configuration:

- Set `remote.artery.canonical.hostname` to the host name or IP address of the node.
- Include the same list of Pekko node addresses in `cluster.seed-nodes` to ensure the nodes start consistently. If you want a specific node to initiate the cluster, place its address at the top of the seed-nodes list. The order can vary across nodes, as long as each node contains the full list of cluster addresses.

!!! Example "Configuration of a cluster with three nodes"

    === "Node 1"

        Pekko configuration for node 1:

        ```yaml
        pekko {
          cluster.enable = on
          actor {
            provider = cluster
          }
          remote.artery {
            canonical {
              hostname = "10.1.2.1"
              port = 7355
            }
          }
          cluster.seed-nodes = [
            "pekko://application@10.1.2.1:7355",
            "pekko://application@10.1.2.2:7355",
            "pekko://application@10.1.2.3:7355"
          ]

          cluster.min-nr-of-members = 2
        }
        ```

    === "Node 2"

        Pekko configuration for node 2:

        ```yaml
        pekko {
          cluster.enable = on
          actor {
            provider = cluster
          }
          remote.artery {
            canonical {
              hostname = "10.1.2.2"
              port = 7355
            }
          }
          cluster.seed-nodes = [
            "pekko://application@10.1.2.1:7355",
            "pekko://application@10.1.2.2:7355",
            "pekko://application@10.1.2.3:7355"
          ]

          cluster.min-nr-of-members = 2
        }
        ```

    === "Node 3"

        Pekko configuration for node 3:

        ```yaml
        pekko {
          cluster.enable = on
          actor {
            provider = cluster
          }
          remote.artery {
            canonical {
              hostname = "10.1.2.3"
              port = 7355
            }
          }
          cluster.seed-nodes = [
            "pekko://application@10.1.2.1:7355",
            "pekko://application@10.1.2.2:7355",
            "pekko://application@10.1.2.3:7355"
          ]

          cluster.min-nr-of-members = 2
        }
        ```

---

## SSL/TLS support

Pekko offers robust support for SSL/TLS encryption, ensuring secure communication between nodes. Below is a standard configuration to enable SSL/TLS support:

```yaml
## Pekko server with SSL/TLS
pekko {
  cluster.enable = on
  actor {
    provider = cluster
  }
  remote.artery {
    transport = tls-tcp
    canonical {
      hostname = "<HOSTNAME_OR_IP_ADDRESS>"
      port = 7355
    }
    ssl.config-ssl-engine {
      key-store = "<PATH_TO_KEYSTORE>"
      trust-store = "<PATH_TO_TRUSTSTORE>"
      key-store-password = "change_me"
      key-password = "change_me"
      trust-store-password = "change_me"
      protocol = "TLSv1.2"
    }
  }
  cluster.seed-nodes = [
    "pekko://application@HOSTNAME1:7355",
    "pekko://application@HOSTNAME2:7355",
    "pekko://application@HOSTNAME3:7355"
  ]

  cluster.min-nr-of-members = 2
}
```

!!! warning "Certificate considerations"
    Ensure you use your internal PKI (Public Key Infrastructure) or keytool commands to generate certificates.
    
    For detailed instructions, see: [Using keytool for Certificate Generation](https://lightbend.github.io/ssl-config/CertificateGeneration.html#using-keytool).

    Your server certificates should include the following _KeyUsage_ and _ExtendedkeyUsage_ extensions for proper functioning:
        
    - _KeyUsage_ extensions
        - `nonRepudiation`
        - `dataEncipherment`
        - `digitalSignature`
        - `keyEncipherment`
    - _ExtendedkeyUsage_ extensions
        - `serverAuth`
        - `clientAuth`

!!! Example "Pekko configuration with SSL/TLS for node 1"

    ```yaml
    ## Pekko server
    pekko {
      cluster.enable = on
      actor {
        provider = cluster
      }
      remote.artery {
        transport = tls-tcp
        canonical {
          hostname = "10.1.2.1"
          port = 7355
        }

        ssl.config-ssl-engine {
          key-store = "/etc/thehive/application.conf.d/certs/10.1.2.1.jks"
          trust-store = "/etc/thehive/application.conf.d/certs/internal_ca.jks"

          key-store-password = "chamgeme"
          key-password = "chamgeme"
          trust-store-password = "chamgeme"

          protocol = "TLSv1.2"
        }
      }
      
      cluster.seed-nodes = [ 
        "pekko://application@10.1.2.1:7355", 
        "pekko://application@10.1.2.2:7355", 
        "pekko://application@10.1.2.3:7355" 
      ]

      cluster.min-nr-of-members = 2
    }
    ```

    Ensure to apply the same principle for configuring other nodes, and remember to restart all services afterward.

---

!!! note "Session security key requirement"
    Starting with version 5.4, the `secret.conf` file must include a secret key of at least 32 characters for session security, as required by Play Framework 3. In clustered environments, all nodes must use the same key to maintain consistency across the deployment.

<h2>Next steps</h2>

* [Database and Index Configuration](database.md)
* [File Storage Configuration](file-storage.md)
* [TheHive Connectors](connectors.md)
* [Logs Configuration](logs.md)
* [Proxy Settings](proxy.md)
* [Secret Configuration File](secret.md)
* [SSL Configuration](ssl.md)
* [Service Configuration](service.md)
* [GDPR Compliance in TheHive 5.x](gdpr.md)
