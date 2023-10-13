# Vault managed Consul ACLs
This article gives explanation on Why is Vault is being considered as a candidate for managing Consul’s ACLs, and How, by using some illustrations and technical use case.

## Agenda:
Why choose Vault to manage Consul ACLs
Understanding the Work Flow.
Hands-on Demo
The Challenges


## Why choose Vault to manage Consul ACLs
* Central and secure management of ACL secrets
* Easy management of bulk of secrets for large infrastructure organisations.


## Understanding the Work Flow.

![Vault_Consul_ACLs](https://github.com/amitchahalgits/Vault_managed_Consul_ACLs/assets/109494649/80901191-06e4-4c68-bdda-b62c40593832)



## Demo Steps:

### Spin consul and vault using docker-compose
** Note: Consul ACL subsystem is auto bootstrapped with `initial_management = true` in configuration.
** Also the consul/service/sidecar configs may be populated with Old tokens. Please replace them with newly generated tokens from Vault.

* Download the lab from git repo : 
`git clone https://github.com/amitchahalgits/Vault_managed_Consul_ACLs.git`

* `cd Vault_managed_Consul_ACLs`

* Run Docker-compose: 
`docker-compose up -d`


* Jump to server, and validate health : 
`consul members` , `consul acl token read -self`


* Create a policy for ACL tokens to be used by nodes and services : 
```
node_prefix "" {
  policy = "write"
  }
service_prefix "" {
  policy = "write"
}
```

* Write Policy to Consul: 
`consul acl policy create -name consul-servers -rules @server_policy.hcl`


* Validate Vault is running okay and is unsealed: 
`vault status` , `vault login <root_token>`


* Enable secrets engine on Vault : 
`vault secrets enable consul`.


* Allow Vault communication to Consul : 
`vault write consul/config/access address=${CONSUL_HTTP_ADDR} token=${CONSUL_HTTP_TOKEN}`


* Creating a Vault role, and Validating vaults policy and roles :
`vault write consul/roles/consul-server-role policies=consul-servers`, 
`vault list consul/roles`,
`vault read consul/roles/consul-server-role`,
`vault policy list`


* Generating Tokens from Vault:
`vault read consul/creds/consul-server-role`


* Validate the Vaults generated token got sync'd to Consul:
`consul acl token read -id <Accessor_id>`


* Creating a token from vault and use it as Agent token consul nodes.
** Note: The tokens can be generated and be configured in Consul based on resources/privileges requirement.

* On Vault : `vault read consul/creds/consul-server-role`

* On consul nodes: Set the agent token on each consul node by either modifying configuration file/CLI/API:
On Consul nodes: `consul acl set-agent-token agent <token>`

OR
```
tokens {
     agent = "2ab9800f-3b6e-f557-1642-76e9480d03b4"
  }
```
Also, we need more tokens from vault to configure on :
- service definitions
- Envoy Proxy sidecars(if the service are in service mesh)

Follow the similar process for generating tokens from vault and applying on service definitions config, and set the Environment variable, CONSUL_HTTP_TOKEN on service nodes/envoy systemd config, or by using `-token` in `consul connect envoy` command.

Example : Service definition config :

```
service {
  name = "counting"
  port = 9003
  token = "9c15510e-3820-2054-b58f-b3bbfd77b752"
  connect {
    sidecar_service {}
  }

  check {
    id       = "counting-check"
    http     = "http://localhost:9003/health"
    method   = "GET"
    interval = "10s"
    timeout  = "1s"
  }
}
```


And Envoy command example: `consul connect envoy -sidecar-for=counting -token <TOKEN> -- -l debug`

** We may need to re-register the service to get this working.**


## The Challenges :
* ACL tokens rotation needs to be done by operator by generating new tokens from Vault, Automated rotation is not available in Vault at the moment

* ACL tokens TTL is not modifiable in present situation.



## Ref: 
* https://developer.hashicorp.com/consul/tutorials/vault-secure/vault-consul-secrets
* Base Lab from : https://github.com/Ranjandas/learn-consul-connect
