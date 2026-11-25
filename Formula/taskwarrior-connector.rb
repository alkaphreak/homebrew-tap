class TaskwarriorConnector < Formula
  desc "Local daemon behind the Send to Taskwarrior Hardened Firefox extension: turns a POSTed page into a `task add`."
  homepage "https://addons.mozilla.org/firefox/addon/cb7d03e975ee4c8fad4b/"
  version "0.5.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/alkaphreak/Taskwarrior-Connector/releases/download/v0.5.3/taskwarrior-connector-aarch64-apple-darwin.tar.xz"
      sha256 "5cf0776d08428eda61a3263ac18980a9a1545d981f6a721af9ae8033332dda24"
    end
    if Hardware::CPU.intel?
      url "https://github.com/alkaphreak/Taskwarrior-Connector/releases/download/v0.5.3/taskwarrior-connector-x86_64-apple-darwin.tar.xz"
      sha256 "a69c6fa1d34fcf51e13bf1da485cbb2a1bd89af5c8cb73990e1de468cfa59b57"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/alkaphreak/Taskwarrior-Connector/releases/download/v0.5.3/taskwarrior-connector-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ed24038cbd0ae994653fa1dbf43588709887d961b582c59a6ba3b7d51a6df987"
    end
    if Hardware::CPU.intel?
      url "https://github.com/alkaphreak/Taskwarrior-Connector/releases/download/v0.5.3/taskwarrior-connector-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d937e5442a2db69b1051d9ef6e053dacda7e3e05d7604bc848cac89e37363c69"
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
