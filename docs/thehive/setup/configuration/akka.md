# Akka

!!! Quote ""
    Akka is a powerful toolkit designed for building highly concurrent, distributed, and resilient message-driven applications in Java and Scala. 

    [https://akka.io/](https://akka.io/)

Akka plays a crucial role in enabling multiple nodes of TheHive to communicate with each other seamlessly, thereby enhancing the overall user experience. 


## Basic Configuration

For a reliable cluster setup, it's essential to have a minimum of three nodes for TheHive application. Each node should be configured with Akka as outlined below: 

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

- `remote.artery.hostname` should be set to the hostname or IP address of the node.
- `cluster.seed-nodes` should contain the same list of Akka nodes, ensuring consistency across all nodes.


!!! Example "Configuration of a Cluster with 3 Nodes"

    === "Node 1"

        Akka configuration for Node 1:

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

        Akka configuration for Node 2:

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

        Akka configuration for Node 3:

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


## SSL/TLS Support

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

!!! Note
    Note that `akka.remote.artery.transport` has changed and `akka.ssl.config-ssl-engine` needs to be configured.
    
    **For more details, refer to**: [Akka Remoting with Artery - Remote Security](https://doc.akka.io/docs/akka/current/remoting-artery.html#remote-security)


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





!!! Example "Akka Configuration with SSL/TLS for Node 1"

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

    Ensure to apply the same principle for configuring other nodes, and remember to restart all services afterward.