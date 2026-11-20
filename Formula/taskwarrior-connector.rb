class TaskwarriorConnector < Formula
  desc "Local daemon behind the Send to Taskwarrior Hardened Firefox extension: turns a POSTed page into a `task add`."
  homepage "https://addons.mozilla.org/firefox/addon/cb7d03e975ee4c8fad4b/"
  version "0.5.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/alkaphreak/Taskwarrior-Connector/releases/download/v0.5.2/taskwarrior-connector-aarch64-apple-darwin.tar.xz"
      sha256 "16c24a6be6fae1beaed8f5eca1715784747ec72fa360ede2f7251eac6649fc6a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/alkaphreak/Taskwarrior-Connector/releases/download/v0.5.2/taskwarrior-connector-x86_64-apple-darwin.tar.xz"
      sha256 "20232f241663670fd62fa8996f563363c17edb0f740745e709efb2e53ccd2c57"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/alkaphreak/Taskwarrior-Connector/releases/download/v0.5.2/taskwarrior-connector-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fe1f190ed535ea8e00655ecc3871d0c42e9ed061c79ca58d53ef1a93300b4034"
    end
    if Hardware::CPU.intel?
      url "https://github.com/alkaphreak/Taskwarrior-Connector/releases/download/v0.5.2/taskwarrior-connector-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e432ed383256693d40bb8ffd92c6f19323864e4b1af26c96c02f8fa6cf92432a"
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
