# Raspberry Pi

## Initial Setup

1. Download the .zip for the desired image. Place the .info and .zip.sha256 into the image/ folder.
2. Extract the .img from the .zip.
3. Insert the MicroSD card which is in the Raspberry Pi into a PC, likely using a MicroSD -> USB or MicroSD -> SD converter.
4. Using [Rufus](https://rufus.ie/en/) install the .img onto the MicroSD card.
5. Create an empty file named `ssh` in the root of the MicroSD card's "boot" volume.
6. Insert the MicroSD card back into the Raspberry Pi and plug it in.
7. Connect to the server via `ssh pi@raspberrypi.local` with the password "raspberry"
   Now that you're on the server perform the following:
   1. Change the password to the standard one via `passwd`
   2. Follow the instructions here to mount the external drive to /mnt/external: <https://www.shellhacks.com/raspberry-pi-mount-usb-drive-automatically/>
      The commands that I used last time were:

      ```bash
      # Create the mountpoint
      $ sudo mkdir /mnt/external

      # Get the UUID for the for the drive
      $ sudo blkid

      # Backup fstab just incase
      $ sudo cp /etc/fstab /etc/fstab.back

      # Add the following line to fstab (change the UUID if necessary)
      # UUID=e518d1a7-0bcb-41d3-9542-0e61185cb931 /mnt/external ext4 defaults,auto,users,exec,rw,nofail 0 0
      # TODO: Just use echo "" >> to append this in the future.
      $ sudo nano /etc/fstab

      # Validate that the line added to fstab is valid
      $ sudo findmnt --verify --verbose

      # Just to validate that mounting works
      $ sudo mount /mnt/external/

      # Just to validate that the files are mounted
      $ ls /mnt/external/

      # Always reboot to test it at this point (Only if findmnt --verify --verbose and mount /mnt/external worked!)
      $ reboot
      ```

8. Run `./sync.sh` to copy the initial set of files over.
9. Reconnect to the server via ssh as before.
   On the server run the following:

   ```bash
   # Navigate to the primary location for all of this stuff
   $ cd /mnt/external/

   # Run the install.sh script
   $ sudo ./install.sh

   # Navigate to the services directory
   $ cd services

   # Run the run.sh script
   $ ./run.sh

   # Disconnect from ssh
   $ exit
   ```

10. Update the router's "Primary DNS" under Network Center -> Local Network to `192.168.1.100`, and click Apply.

## Extras

### Automatically connect via SSH

To automatically login with the correct user and private key, add the following to your `~/.ssh/config` file.

```bash
Host raspberrypi.local
  Hostname raspberrypi.local
  IdentityFile ~/.ssh/id_rsa_raspberrypi
  User pi
```
