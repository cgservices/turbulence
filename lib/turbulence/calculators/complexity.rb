require 'stringio'
require 'flog'

class Ruby19Parser < RubyParser
  def process(ruby, file)
    ruby.gsub!(/(\w+):\s+/, '"\1" =>')
    super(ruby, file)
  end
end unless defined?(:Ruby19Parser)

class Flog19 < Flog
  def initialize option = {}
    super(option)
    @parser = Ruby19Parser.new
  end
end

class Turbulence
  module Calculators
    class Complexity
      attr_reader :config, :type

      def initialize(config = nil)
        @config = config || Turbulence.config
        @type = :complexity
      end

      def flogger
        @flogger ||= Flog19.new(:continue => true)
      end

      def for_these_files(files)
        files.each do |filename|
          yield filename, score_for_file(filename)
        end
      end

      def score_for_file(filename)
        flogger.reset
        flogger.flog filename
        flogger.total_score
      end
    end
  end
end
