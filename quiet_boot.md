# remove plymouth

run

```bash
sudo apt purge plymouth
sudo apt autoclean
```

# silent kernel print

in /etc/sysctl.conf

```bash
kernel.printk = 0 0 0 0
sysctl --system
```

# silence systemd boot loader

in /etc/kernel/kernel/cmdline append

```
quiet loglevel=0 rd.systemd.show_status=false rd.udev.log_level=0 console=tty2
```

then run

```bash
sudo mkinitcpio -P
```

# clear tty on logout

run

```bash
sudo systemctl edit getty@tty1
```

replace with

```
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty %I $TERM
TTYVTDisallocate=yes
```

then run

```bash
sudo systemctl daemon-reload
sudo systemctl restart getty@tty1
```

# silence grub

in /etc/default/grub set

```bash
GRUB_DEFAULT=0
GRUB_TIMEOUT=0
GRUB_FORCE_HIDDEN_MENU="true"
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=0 console=tty2"
GRUB_CMDLINE_LINUX=""
```

# remove grub wp

```bash
sudo mv /usr/share/images/desktop-base/desktop-grub.png /usr/share/images/desktop-base/desktop-grub.png_bak
sudo update-initramfs -u
sudo update-grub
```



