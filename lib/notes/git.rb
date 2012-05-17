require 'notes'

module Notes
  module Git

    # Scan a Git bare repository
    #
    # @param repo Path to the bare repository
    # @param ref tree-ish Git reference
    # @param block Callback to execute on each found note
    # @return an enum if no block is given
    def self.scan_bare(repo, ref = 'HEAD', &block)
      return enum_for(__method__, repo, ref, &block) if block.nil?
      scanner = Notes::Scanner.new
      files = {} # path => ref
      Dir.chdir repo do
        # equivalent of git-ls-files on a non-bare repository,
        # but also give objects id, type, and mode for the given ref.
        # The output is like:
        #   <mode> SP <type> SP <object> TAB <file>
        `git ls-tree -r #{ref}`.split.each_slice(4) { |e| files[e[-1]] = e[-2] }

        for path, hash in files
          content = `git cat-file blob #{hash}` # same as: git show -- <hash>
          scanner.callback = proc { |note| note.file = path; block.call(note) }
          scanner.scan(content)
        end
      end
    end
  end
end
