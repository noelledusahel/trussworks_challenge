require 'csv'
require 'time'
require 'date'

class Normalizer
  def initialize
  end

  def read_file
    text = $stdin.read
    text = encode_utf8(text)
    csv = CSV.parse(text, headers: true)
    new_thang = csv.map do |row|
      sample = []
      sample << format_timestamp(row['Timestamp'])
      sample << format_address(row['Address'])
      sample << format_zip(row['ZIP'])
      sample << format_fullname(row['FullName'])
      sample << format_duration(row['FooDuration'])
      sample << format_duration(row['BarDuration'])
      sample << total_duration(row['FooDuration'], row['BarDuration'])
      sample << remove_invalid_chars(row['Notes'])
    end

    new_thang
  end

  def encode_utf8(file)
    file.encode('utf-8')
  end

  def write_file
    file = read_file

    output_file = CSV.generate do |sample|
      file.each do |entry|
        sample << entry
      end
    end
    $stdout.print output_file
  end

  def format_timestamp(time)
    # need method to convert timezone to EST
    begin
      time_obj = DateTime.parse(time)
      time_obj.iso8601
    rescue ArgumentError
      # return to this, allowing valid leap year dates
      time_obj = "Invalid Date"
    end
  end

  def format_zip(zipcode)
    if zipcode.length < 5
      num  = 5 - zipcode.length
      zipcode.insert(0, ('0' * num))
    end
    zipcode
  end

  def format_fullname(fullname)
    fullname.upcase
  end


  def format_address(address)
    address = encode_utf8(address)
    address.unicode_normalize
  end

  def format_duration(duration)
    duration.split(':').map { |a| a.to_f }.inject(0) { |a, b| a * 60 + b}
  end

  def total_duration(foo, bar)
    format_duration(foo) + format_duration(bar)
  end

  def remove_invalid_chars(notes)
    if notes.respond_to?(:encode)
      notes.encode("UTF-8", invalid: :replace, undef: :replace)
    end
  end
end

# Method Calls
normalizer = Normalizer.new
normalizer.write_file
