require 'rubygems'
require "exif-date-sorter/version"
require "exifr"
require "fileutils"

class ExifDateSorter
  def initialize(source=false, target=false)
    @source = source || Dir.pwd
    @target = target || Dir.pwd
  end

  def move
    Dir[@source + '/**/*.{jpg,JPG}'].each do |image|
      target_dir = dir(image)
      FileUtils.mkdir_p(target_dir) unless File.directory? target_dir
      if File.dirname(image) != target_dir
        FileUtils.move image, target_dir
      end
    end
  end

  def date(image)
    EXIFR::JPEG.new(image).date_time_original
  end

  def dir(image)
    date = date(image)
    if date.nil?
      "#{@target}"
    else
      "#{@target}/#{date.year}/#{'%02d' % date.month}"
    end
  end
end
