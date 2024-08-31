{
  services.ollama = {
    enable = false;
    host = "127.0.0.1";
    port = 11434;
    acceleration = "rocm";
  };
  # nginx by default runs with ProtectHome = true
  environment.persistence."/persist" = {
    directories = ["/var/lib/ollama"];
  };
}
