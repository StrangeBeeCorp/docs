
# Pekko Configuration (TheHive 5.4+)

!!! Note
    This documentation applies to TheHive version 5.4 and later. For earlier versions, please refer to the [Akka Configuration](./akka.md).

## Introduction

With the release of TheHive version 5.4, we have transitioned from the Scala framework **Akka** to **Apache Pekko**. This change enhances performance and introduces several updates that may require modifications to your `application.conf` file.

This guide provides instructions on updating your configuration to support this change.

---

## Basic Configuration

For a reliable cluster setup, it's essential to have a minimum of three nodes for TheHive application. Each node should be configured with Pekko as outlined below:

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

- `remote.artery.canonical.hostname` should be set to the hostname or IP address of the node.
- `cluster.seed-nodes` should contain the same list of Pekko nodes, ensuring consistency across all nodes.

!!! Example "Configuration of a Cluster with 3 Nodes"

    === "Node 1"

        Pekko configuration for Node 1:

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

        Pekko configuration for Node 2:

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

        Pekko configuration for Node 3:

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

## SSL/TLS Support

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

!!! Warning "Certificate Considerations"
    Ensure you use your internal PKI (Public Key Infrastructure) or keytool commands to generate certificates.
    
    **For detailed instructions, see**: [Using keytool for Certificate Generation](https://lightbend.github.io/ssl-config/CertificateGeneration.html#using-keytool)

    Your server certificates should include the following _KeyUsage_ and _ExtendedkeyUsage_ extensions for proper functioning:
        
    - _KeyUsage_ extensions
        - `nonRepudiation`
        - `dataEncipherment`
        - `digitalSignature`
        - `keyEncipherment`
    - _ExtendedkeyUsage_ extensions
        - `serverAuth`
        - `clientAuth`

!!! Example "Pekko Configuration with SSL/TLS for Node 1"

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

!!! Note
    From version 5.4 onwards, the `secret.conf` file must include a secret key of at least 32 characters for session security, as required by Play Framework 3. For clustered setups, all nodes must share the same key, ensuring consistency across the deployment.

&nbsp;
