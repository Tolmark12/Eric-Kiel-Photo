require 'tempfile'

module BentoBox
  module TempfileExt
    Tempfile.class_eval do
      def make_tmpname(basename, n)
        ext = File::extname(basename)
        "#{basename}-#{$$}-#{n}.#{ext}"
      end
    end
  end
end