# Openstack VM Module

This module is used to quickly spawns VMs on Openstack.

## Usage

```hcl
module "openstack" {

  source = "git::https://github.com/GridexX/openstack-vm-module.git?ref=1.0.0"


  instance_name = "my-vm"
  image_name = "Ubuntu 18.04"
  flavor_name = "m1.small"
  public_network_name = "public"
  keypair = "my-keypair"
  user_data = "echo 'Hello, World!' > /tmp/hello.txt"
}
```

>[!TIP]
> For the full list of available parameters, refer to the [variables.tf](./variables.tf) file.

## License

This module is licensed under the MIT License. See the [LICENSE](./LICENSE) file for more information.

## Authors

This module is maintained by [GridexX](https://github.com/GridexX).