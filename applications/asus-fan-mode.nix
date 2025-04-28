_: {
  systemd.services.asus-fan-mode = {
    description = "Set Asus Laptop Fan Mode to Performance Mode";
    wantedBy = [ "multi-user.target" ];
    script = ''
      echo "0x00110019" > /sys/kernel/debug/asus-nb-wmi/dev_id &&
      echo "2" > /sys/kernel/debug/asus-nb-wmi/ctrl_param &&
      cat /sys/kernel/debug/asus-nb-wmi/devs || true
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = false;
    };
  };
}
