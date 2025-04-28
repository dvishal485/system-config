_: {
  specialisation = {
    ollama.configuration = {
      system.nixos.tags = [ "ollama" ];
      environment.etc."specialisation".text = "ollama";
      services.ollama = {
        enable = true;
        acceleration = "cuda";
      };
    };
  };
}
