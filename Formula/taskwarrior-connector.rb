class TaskwarriorConnector < Formula
  desc "Local daemon behind the Send to Taskwarrior Hardened Firefox extension: turns a POSTed page into a `task add`."
  homepage "https://addons.mozilla.org/firefox/addon/cb7d03e975ee4c8fad4b/"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/alkaphreak/Taskwarrior-Connector/releases/download/v0.5.0/taskwarrior-connector-aarch64-apple-darwin.tar.xz"
      sha256 "ed94f05f12cde8414ea6dd0471e1127a584564765dc0b04b3f859c6b9b92dac4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/alkaphreak/Taskwarrior-Connector/releases/download/v0.5.0/taskwarrior-connector-x86_64-apple-darwin.tar.xz"
      sha256 "621d1c16bfc313f1a60613bbe4ed8afabe0281ae91cee1448eb2699acd7ba2ab"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/alkaphreak/Taskwarrior-Connector/releases/download/v0.5.0/taskwarrior-connector-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c42ebd40300fb513e00e9b0b6adef872e44938df33b05c1f33f00cf7df065a47"
    end
    if Hardware::CPU.intel?
      url "https://github.com/alkaphreak/Taskwarrior-Connector/releases/download/v0.5.0/taskwarrior-connector-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "474a915deb3586d4436d0110dc04e0f904baafb164abf77d0006c5ffb2ec7d9c"
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
