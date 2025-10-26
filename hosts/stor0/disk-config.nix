# See (https://grahamc.com/blog/erase-your-darlings/) for details
{ lib, ... }:
{
  disko.devices = {
    disk = {
      disk1 = {
        device = lib.mkDefault "/dev/disk/by-id/ata-Lexar_256GB_SSD_MBN625W106329";
        type = "disk";
        content = {
            type = "gpt";
            partitions = {
            esp = {
                size = "500M";
                type = "EF00";
                content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions =  [ "umask=0077" ];
                };
            };
            zfs = {
                size = "100%";
                content = {
                type = "zfs";
                pool = "rpool";
                };
            };
            };
        };
      };
      array_11 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-HGST_HDN724040ALE640_PK1334PEKDVLBS";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "stor";
              };
            };
          };
        };
      };
      array_12 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-HGST_HDN724040ALE640_PK2338P4HANSYC";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "stor";
              };
            };
          };
        };
      };
      array_13 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-HGST_HDN724040ALE640_PK2334PCG4HVXB";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "stor";
              };
            };
          };
        };
      };
    };
    zpool = {
      rpool = {
        type = "zpool";
        options.cachefile = "none";
        rootFsOptions = {
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
        };
        postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^rpool/local/root@blank$' || zfs snapshot rpool/local/root@blank";

        datasets = {
          local = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };
          "local/root" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/";
          };
          "local/nix" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/nix";
          };
          safe = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };
          "safe/home" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/home";
          };
          "safe/persist" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/persist";
          };
        };
      };
      stor = {
        type = "zpool";
        options.cacheFile = "none";
        mode = {
          topology = {
            type = "topology";
            vdev = [
              mode = "mirror";
              members = [
                "array_11"
                "array_12"
                "array_13"
              ]
            ];
          };
        };
        rootFsOptions = {
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
        };
      };
    };
  };
}
