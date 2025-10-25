{ lib, ... }:
{
    # Random machine ID used by ZFS to ensure mounts are on the correct machine.
    networking.hostId = lib.mkDefault "600bf725";

    # Store Wireguard keys in the persistant store
    systemd.tmpfiles.rules = [
        "d /persist/etc/wireguard/ 0777 root root -"

        # Set up a link so ACME certificates are stored in the persistant store
        "d /persist/var/lib/acme/ 0777 root root -"
        "L /var/lib/acme - - - - /persist/var/lib/acme"

        "d /persist/etc/NetworkManager/system-connections 0777 root root -"

        "d /persist/var/lib/bluetooth/ 0777 root root -"
        "L /var/lib/bluetooth - - - - /persist/var/lib/bluetooth"

        "d /persist/etc 0777 root root -"
        "L /etc/passwd - - - - /persist/etc/password"
        "L /etc/shadow - - - - /persist/etc/shadow"
    ];

    networking.wireguard.interfaces.wg0 = {
        generatePrivateKeyFile = true;
        privateKeyFile = "/persist/etc/wireguard/wg0";
    };

    # Set up OpenSSH to store keys in the persistant store
    services.openssh = {
        enable = true;
        hostKeys = [
        {
            path = "/persist/etc/ssh/ssh_host_ed25519_key";
            type = "ed25519";
        }
        {
            path = "/persist/etc/ssh/ssh_host_rsa_key";
            type = "rsa";
            bits = 4096;
        }
        ];
    };
    
    # Set up a link for persisting network manager connections
    environment.etc."NetworkManager/system-connections" = {
        source = "/persist/etc/NetworkManager/system-connections/";
    };

    boot.initrd.systemd.enable = lib.mkDefault true;
    boot.initrd.systemd.services.rollback = {
        description = "Rollback root filesystem to a pristine state on boot";
        wantedBy = [
        # "zfs.target"
        "initrd.target"
        ];
        after = [
        "zfs-import-rpool.service"
        ];
        before = [
        "sysroot.mount"
        ];
        # path = with pkgs; [
        #   zfs
        # ];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = ''
        zfs rollback -r rpool/local/root@blank && echo "  >> >> rollback complete << <<"
        '';
    };
}
