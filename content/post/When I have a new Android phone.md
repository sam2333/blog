---
title: "When I Have a New Android Phone"
date: 2021-04-10T09:05:51+08:00
draft: true
tags:
  - "Android"
categories:
  - "HowTo"
summary: " "
---

# 名词解释

- Bootloader：引导程序，不解锁无法刷机
- Recovery：...恢复模式
- TWRP：Team Win Recovery Project，第三方的Recovery
- 刷机/卡刷/线刷

# 常用命令

    ```
    adb devices
    adb reboot
    adb reboot bootloader
    # power +vol down
    adb reboot fastboot
    adb reboot recovery
    adb sideload B2N-337A-0-00CN-B02-update.zip

    fastboot devices
    fastboot reboot recovery
    fastboot oem unlock
    ```

> Note: Not all devices support `unlock` command. Unlocking your bootloader may void your warranty and also wipe all your data.

# 刷入TWRP recovery

    ```
    fastboot flash recovery twrp_recovery.img
    fastboot boot twrp_recovery.img
    ```

# 发送文件到手机

    ```
    adb push xiaomi.eu_multi_MI10_V12.5.3.0.RJBCNXM_v12-11.zip /sdcard/
    adb push Magisk-v22.1.zip /sdcard/
    ```

> Note: Magisk 22.0以后，只需下载apk文件，然后将后缀改为zip即可卡刷

# See also

- [How to Unlock Honor 3C](https://www.carbontesla.com/2014/08/guide-unlock-honor-3c-h30-u10-bootloader-using-sp-flash-tool/)
- [Unbrick & Restore Honor 3C](https://www.carbontesla.com/2014/08/tutorial-unbrick-restore-honor-3c-h30-u10-b108-stock-jb-firmware-v100r001c900b108/)

# References

- [Xiaomi.eu Multilang MIUI ROMs](https://sourceforge.net/projects/xiaomi-eu-multilang-miui-roms/files/xiaomi.eu/MIUI-STABLE-RELEASES/)
- [Magisk Release](https://github.com/topjohnwu/Magisk/releases)
