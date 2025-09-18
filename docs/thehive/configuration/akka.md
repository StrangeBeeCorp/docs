# Akka Configuration (Version 5.3 and Earlier)

[Akka](https://akka.io/) is a powerful toolkit designed for building highly concurrent, distributed, and resilient message-driven applications in Java and Scala.

Akka plays a crucial role in enabling multiple nodes of TheHive to communicate with each other seamlessly, thereby enhancing the overall user experience.

This topic provides instructions for configuring Akka in your environment.

!!! note "Version compatibility"
    This documentation applies to TheHive versions earlier than 5.4. For version 5.4 and later, refer to the [Pekko Configuration](./pekko.md) topic.

## Basic configuration

For a reliable cluster setup, it's essential to have a minimum of three nodes for TheHive application. Configure each node with Akka as outlined below:

```yaml
## Akka server
akka {
  cluster.enable = on
  actor {
    provider = cluster
  }
  remote.artery {
    canonical {
      hostname = "<HOSTNAME OR IP_ADDRESS>"
      port = 2551
    }
  }
# seed node list contains at least one active node
  cluster.seed-nodes = [ "akka://application@HOSTNAME1:2551", "akka://application@HOSTNAME2:2551", "akka://application@HOSTNAME3:2551" ]
}
```

In this configuration:

- Set `remote.artery.hostname` to the host name or IP address of the node.
- Include the same list of Akka nodes in `cluster.seed-nodes` to ensure consistency across all nodes.

!!! Example "Configuration of a cluster with three nodes"

    === "Node 1"

        Akka configuration for node 1:

        ```yaml
        akka {
            cluster.enable = on
            actor {
              provider = cluster
            }
            remote.artery {
              canonical {
                  {==hostname = "10.1.2.1"==}
                  port = 2551
              }
            }
            # seed node list contains at least one active node
            cluster.seed-nodes = [ "akka://application@10.1.2.1:2551", "akka://application@10.1.2.2:2551", "akka://application@10.1.2.3:2551" ]
        }
        ```


    === "Node 2"

        Akka configuration for node 2:

        ```yaml
        akka {
            cluster.enable = on
            actor {
            provider = cluster
            }
            remote.artery {
            canonical {
                {==hostname = "10.1.2.2"==}
                port = 2551
            }
            }
            # seed node list contains at least one active node
            cluster.seed-nodes = [ "akka://application@10.1.2.1:2551", "akka://application@10.1.2.2:2551", "akka://application@10.1.2.3:2551" ]
        }
        ```

    === "Node 3"

        Akka configuration for node 3:

        ```yaml
        akka {
            cluster.enable = on
            actor {
            provider = cluster
            }
            remote.artery {
            canonical {
                {==hostname = "10.1.2.3"==}
                port = 2551
            }
            }
            # seed node list contains at least one active node
            cluster.seed-nodes = [ "akka://application@10.1.2.1:2551", "akka://application@10.1.2.2:2551", "akka://application@10.1.2.3:2551" ]
        }
        ```

## SSL/TLS support

Akka offers robust support for SSL/TLS encryption, guaranteeing secure communication between nodes. Below, you'll find a standard configuration to enable SSL/TLS support:

```yaml
## Akka server
akka {
  cluster.enable = on
  actor {
    provider = cluster
  }
  remote.artery {
    transport = tls-tcp
    canonical {
      hostname = "<HOSTNAME OR IP_ADDRESS>"
      port = 2551
    }

    ssl.config-ssl-engine {
      key-store = "<PATH TO KEYSTORE>"
      trust-store = "<PATH TO TRUSTSTORE>"

      key-store-password = "chamgeme"
      key-password = "chamgeme"
      trust-store-password = "chamgeme"

      protocol = "TLSv1.2"
    }
  }
# seed node list contains at least one active node
  cluster.seed-nodes = [ "akka://application@HOSTNAME1:2551", "akka://application@HOSTNAME2:2551", "akka://application@HOSTNAME3:2551" ]
}
```

!!! note "Remoting and security configuration"
    Note that `akka.remote.artery.transport` has changed and `akka.ssl.config-ssl-engine` needs to be configured.  
    
    For more details, refer to [Akka Remoting with Artery - Remote Security](https://doc.akka.io/docs/akka/current/remoting-artery.html#remote-security).


!!! warning "Certificate considerations"
    Ensure you use your internal PKI (Public Key Infrastructure) or keytool commands to generate certificates.  
    
    For detailed instructions, see [Using Keytool for X.509 Certificate Generation](https://lightbend.github.io/ssl-config/CertificateGeneration.html#using-keytool).  

    Your server certificates should include the following `KeyUsage` and `ExtendedkeyUsage` extensions for proper functioning:
        
    - _KeyUsage_ extensions
        - `nonRepudiation`
        - `dataEncipherment`
        - `digitalSignature`
        - `keyEncipherment`

    - _ExtendedkeyUsage_ extensions
        - `serverAuth`
        - `clientAuth`

!!! Example "Akka configuration with SSL/TLS for node 1"

    ```yaml
    ## Akka server
    akka {
      cluster.enable = on
      actor {
        provider = cluster
      }
      remote.artery {
        {==transport = tls-tcp==}
        canonical {
          hostname = "10.1.2.1"
          port = 2551
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
    # seed node list contains at least one active node
      cluster.seed-nodes = [ "akka://application@10.1.2.1:2551", "akka://application@10.1.2.2:2551", "akka://application@10.1.2.3:2551" ]
    }
    ```

    Be sure to apply the same configuration principles to all other nodes and restart all services afterward.

<h2>Next steps</h2>

* [Database and Index Configuration](database.md)
* [File Storage Configuration](file-storage.md)
* [TheHive Connectors](connectors.md)
* [Logs Configuration](logs.md)
* [Secret Configuration File](secret.md)
* [Configure JVM Trust for SSL/TLS Certificates](../configuration/ssl/configure-ssl-jvm.md)
* [Update TheHive Service Configuration](update-service-configuration.md)
* [GDPR Compliance in TheHive 5.x](gdpr.md)