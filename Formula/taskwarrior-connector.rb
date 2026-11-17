class TaskwarriorConnector < Formula
  desc "Local daemon behind the Send to Taskwarrior Hardened Firefox extension: turns a POSTed page into a `task add`."
  homepage "https://addons.mozilla.org/firefox/addon/cb7d03e975ee4c8fad4b/"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/alkaphreak/Taskwarrior-Connector/releases/download/v0.4.0/taskwarrior-connector-aarch64-apple-darwin.tar.xz"
      sha256 "1c56167f539ed9db431ca681040c7563188f4f0ef2d04f31a5fae79ab903ef78"
    end
    if Hardware::CPU.intel?
      url "https://github.com/alkaphreak/Taskwarrior-Connector/releases/download/v0.4.0/taskwarrior-connector-x86_64-apple-darwin.tar.xz"
      sha256 "af39d345b598f29bfe782da01d22754d0e7f8b4a04e1c7b2426727ab5461486d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/alkaphreak/Taskwarrior-Connector/releases/download/v0.4.0/taskwarrior-connector-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0b43b5ffc646a9259be144754539ec0d70635ae62f238e01b8bd854cea98ce8b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/alkaphreak/Taskwarrior-Connector/releases/download/v0.4.0/taskwarrior-connector-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4b7e82b67ff411f0106269bbacf5dd9ac3cbf7acc008180c2621c2f33a17a56b"
    end
  end
  license "GPL-3.0-only"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "taskwarrior-connector"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "taskwarrior-connector"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "taskwarrior-connector"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "taskwarrior-connector"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
