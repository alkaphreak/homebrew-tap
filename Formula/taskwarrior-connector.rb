class TaskwarriorConnector < Formula
  desc "Local daemon behind the Send to Taskwarrior Hardened Firefox extension: turns a POSTed page into a `task add`."
  homepage "https://addons.mozilla.org/firefox/addon/cb7d03e975ee4c8fad4b/"
  version "0.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/alkaphreak/Taskwarrior-Connector/releases/download/v0.5.1/taskwarrior-connector-aarch64-apple-darwin.tar.xz"
      sha256 "a01d8470b9b5be5bff33e78883be6a3e990946f717e6c7368af827339d1b1306"
    end
    if Hardware::CPU.intel?
      url "https://github.com/alkaphreak/Taskwarrior-Connector/releases/download/v0.5.1/taskwarrior-connector-x86_64-apple-darwin.tar.xz"
      sha256 "1f9bc6bebadac3cef457834589161ee89972a09e2740f25a932a80753fb95c5b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/alkaphreak/Taskwarrior-Connector/releases/download/v0.5.1/taskwarrior-connector-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9b085daf8d6c1b0c46bbbe0c05d66d85e958dde528c0edc554092b34dd9fc6cb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/alkaphreak/Taskwarrior-Connector/releases/download/v0.5.1/taskwarrior-connector-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3e9a340558c498f98650301d636ce5fd0daa6206721c1b4ddd6229457f23a869"
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
